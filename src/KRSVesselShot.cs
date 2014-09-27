using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;
using KSP;

namespace KronalUtils
{
    class KRSVesselShot
    {
        public ShaderMaterial MaterialFXAA = new ShaderMaterial(KronalUtils.Properties.Resources.ShaderFXAA);
        public ShaderMaterial MaterialColorAdjust = new ShaderMaterial(KSP.IO.File.ReadAllText<KRSVesselShot>("coloradjust"));
        public ShaderMaterial MaterialEdgeDetect = new ShaderMaterial(KSP.IO.File.ReadAllText<KRSVesselShot>("edn2"));
        public ShaderMaterial MaterialBluePrint = new ShaderMaterial(KSP.IO.File.ReadAllText<KRSVesselShot>("blueprint"));
        private List<string> Shaders = new List<string>() { "edn", "cutoff", "diffuse", "bumped", "bumpedspecular", "specular", "unlit", "emissivespecular", "emissivebumpedspecular" };
        private Dictionary<string, Material> Materials;
        public readonly IDictionary<string, ShaderMaterial> Effects;

        private Camera[] cameras;
        private RenderTexture rt;
        private int maxWidth = 9999;
        private int maxHeight = 5000;
        private Bounds shipBounds;
        internal Camera Camera { get; private set; }
        internal Vector3 direction;
        internal Vector3 position;
        internal bool EffectsAntiAliasing { get; set; }//consider obsolete?
        internal bool Orthographic
        {
            get
            {
                return this.Camera == this.cameras[0];//if this currently selected camera is the first camera then Orthographic is true
            }
            set
            {
                this.Camera = this.cameras[value ? 0 : 1];//if setting to true use the first camera (which is ortho camera). if false use the non-ortho
            }
        }
        internal VesselViewConfig Config { get; private set; }
        internal IShipconstruct Ship
        {
            get
            {
                if (EditorLogic.fetch)
                {
                    return EditorLogic.fetch.ship;
                }
                else
                {
                    return null;
                }
            }
        }

        internal string ShipName
        {
            get
            {
                if (EditorLogic.fetch && EditorLogic.fetch.ship != null)
                {
                    
                    return MakeValidFileName(EditorLogic.fetch.ship.shipName);
                }
                else
                {
                    return "vessel";
                }
            }
        }

        public KRSVesselShot()
        {
            SetupCameras();
            this.Config = new VesselViewConfig();
            this.direction = Vector3.forward;
            this.Materials = new Dictionary<string, Material>();
            this.Effects = new Dictionary<string, ShaderMaterial>() {
                {"Color Adjust",MaterialColorAdjust},
                {"Edge Detect", MaterialEdgeDetect},
                {"Blue Print", MaterialBluePrint},
                {"FXAA", MaterialFXAA}
            };
            LoadShaders();
            UpdateShipBounds();

            GameEvents.onPartAttach.Add(PartAttached);
            GameEvents.onPartRemove.Add(PartRemoved);
        }

        ~KRSVesselShot()
        {
            GameEvents.onPartAttach.Remove(PartAttached);
            GameEvents.onPartRemove.Remove(PartRemoved);
        }

        private void SetupCameras()
        {
            this.cameras = new Camera[2];
            this.cameras[0] = new GameObject().AddComponent<Camera>();
            this.cameras[0].enabled = false;
            this.cameras[0].orthographic = true;
            this.cameras[0].cullingMask = EditorLogic.fetch.editorCamera.cullingMask & ~(1 << 16); /// hides kerbals
            this.cameras[0].transparencySortMode = TransparencySortMode.Orthographic;
            this.cameras[1] = new GameObject().AddComponent<Camera>();
            this.cameras[1].enabled = false;
            this.cameras[1].orthographic = false;
            this.cameras[1].cullingMask = this.cameras[0].cullingMask;
            this.Camera = this.cameras[0];
        }

        private void LoadShaders()
        {
            foreach (var shaderFilename in Shaders)
            {
                try
                {
                    var mat = new Material(KRSUtils.GetResourceString(shaderFilename));
                    Materials[mat.shader.name] = mat;
                }
                catch
                {
                    MonoBehaviour.print("[ERROR] " + this.GetType().Name + " : Failed to load " + shaderFilename);
                }
            }
        }

        private void ReplacePartShaders(Part part)
        {
            var model = part.transform.Find("model");
            if (!model) return;

            foreach (var r in model.GetComponentsInChildren<MeshRenderer>())
            {
                Material mat;
                if (Materials.TryGetValue(r.material.shader.name, out mat))
                {
                    r.material.shader = mat.shader;
                }
                else
                {
                    MonoBehaviour.print("[Warning] " + this.GetType().Name + "No replacement for " + r.material.shader + " in " + part + "/*/" + r);
                }
            }
        }

        private void PartAttached(GameEvents.HostTargetAction<Part, Part> data)
        {
            ReplacePartShaders(data.host);
            ReplacePartShaders(data.target);
            UpdateShipBounds();
        }

        private void PartRemoved(GameEvents.HostTargetAction<Part, Part> data)
        {
            UpdateShipBounds();
        }

        internal void UpdateShipBounds()
        {
            if ((this.Ship != null) && (this.Ship.Parts.Count > 0))
            {
                this.shipBounds = CalcShipBounds();
            }
            else
            {
                this.shipBounds = new Bounds(EditorLogic.fetch.editorBounds.center, Vector3.zero);
            }
            this.shipBounds.Expand(1f);
        }

        private Bounds CalcShipBounds()
        {
            Bounds result = new Bounds(this.Ship.Parts[0].transform.position, Vector3.zero);
            foreach (var current in this.Ship.Parts)
            {
                if (current.collider && !current.Modules.Contains("LaunchClamp"))
                {
                    result.Encapsulate(current.collider.bounds);
                }
            }
            return result;
        }

        public Vector3 GetShipSize()
        {
            return CalcShipBounds().size;
        }

        public void GenTexture(Vector3 direction, int imageWidth = -1, int imageHeight = -1)
        {
            var minusDir = -direction;

            this.Camera.clearFlags = CameraClearFlags.SolidColor;
            this.Camera.backgroundColor = new Color(1f, 1f, 1f, 0.0f);
            this.Camera.transform.position = this.shipBounds.center;
            this.Camera.transform.rotation = Quaternion.AngleAxis(0f, Vector3.up);
            this.Camera.transform.Translate(Vector3.Scale(minusDir, this.shipBounds.extents) + minusDir * this.Camera.nearClipPlane);
            this.Camera.transform.LookAt(this.shipBounds.center);

            var tangent = this.Camera.transform.up;
            var binormal = this.Camera.transform.right;
            var height = Vector3.Scale(tangent, this.shipBounds.size).magnitude;
            var width = Vector3.Scale(binormal, this.shipBounds.size).magnitude;
            var depth = Vector3.Scale(minusDir, this.shipBounds.size).magnitude;

            float positionOffset = 0f;
            if (this.Orthographic)
            {
                this.Camera.transform.Translate(Vector3.Scale(this.position, new Vector3(1f, 1f, 0f)));
                this.Camera.orthographicSize = (height - this.position.z) / 2f;
                //positionOffset = 0f;
            }
            else
            {
                positionOffset = (height - this.position.z) / (2f * Mathf.Tan(Mathf.Deg2Rad * this.Camera.fieldOfView / 2f)) - depth * 0.5f;
                this.Camera.transform.Translate(new Vector3(this.position.x, this.position.y, -positionOffset));
            }
            this.Camera.farClipPlane = Camera.nearClipPlane + positionOffset + this.position.magnitude + depth;

            if (imageWidth <= 0 || imageHeight <= 0)
            {
                this.Camera.aspect = width / height;

                /*
                 * Deckblad : Trying to lock all renders to a nice beefy size. 
                 * My code will always use the largest image to fit within 5000x5000px as defined above in maxWidth / maxHeight
                 * Please double-check my math. It was late...

                    imageHeight = (int)Mathf.Clamp(100f * height, 0f, Math.Min(maxHeight, maxWidth / this.Camera.aspect));
                    imageWidth = (int)(imageHeight * this.Camera.aspect);
                */
                if (height >= width)
                {
                    imageHeight = (int)maxHeight;
                    imageWidth = (int)(imageHeight * this.Camera.aspect);
                }
                else
                {
                    imageWidth = (int)maxWidth;
                    imageHeight = (int)(imageWidth / this.Camera.aspect);
                }
            }
            else
            {
                this.Camera.aspect = (float) imageWidth / (float) imageHeight;
            }
            if (this.rt) RenderTexture.ReleaseTemporary(this.rt);
            this.rt = RenderTexture.GetTemporary(imageWidth, imageHeight, 24, RenderTextureFormat.ARGB32, RenderTextureReadWrite.sRGB);
            this.Camera.targetTexture = this.rt;
            this.Camera.depthTextureMode = DepthTextureMode.DepthNormals;
            this.Camera.Render();
            this.Camera.targetTexture = null;
            //Graphics.Blit(this.rt, this.rt, MaterialColorAdjust.Material);
            //Graphics.Blit(this.rt, this.rt, MaterialEdgeDetect.Material);
            foreach (var fx in Effects)
            {
                if (fx.Value.Enabled)
                {
                    Graphics.Blit(this.rt, this.rt, fx.Value.Material);
                }
            }
        }

        private void SaveTexture(String fileName)
        {
            //TextureFormat.ARGB32 for transparent
            Texture2D screenShot = new Texture2D(this.rt.width, this.rt.height, TextureFormat.RGB24, false);
            
            var saveRt = RenderTexture.active;//why is this var and not typed?
            //RenderTexture saveRt = RenderTexture.active;//not this?
            RenderTexture.active = this.rt;
            screenShot.ReadPixels(new Rect(0, 0, this.rt.width, this.rt.height), 0, 0);
            screenShot.Apply();
            RenderTexture.active = saveRt;
            byte[] bytes = screenShot.EncodeToPNG();
			string ShipNameFileSafe = MakeValidFileName(fileName);
            uint file_inc = 0;
            //uint breakCount = 0;
            string filename = "";
            string filenamebase = "";
            
            do{
                ++file_inc;
                filenamebase = ShipNameFileSafe + "_" + file_inc.ToString() + ".png";
                filename = Path.Combine(System.IO.Directory.GetParent(KSPUtil.ApplicationRootPath).ToString(), "Screenshots" + Path.DirectorySeparatorChar + filenamebase);
            }while(File.Exists(filename));
            System.IO.File.WriteAllBytes(filename, bytes);

            Debug.Log(string.Format("KVV: Took screenshot to: {0}", filename));
        }
        private static string MakeValidFileName(string name)
        {
            string invalidChars = System.Text.RegularExpressions.Regex.Escape(new string(System.IO.Path.GetInvalidFileNameChars()));
            string invalidRegStr = string.Format(@"([{0}]*\.+$)|([{0}]+)", invalidChars);
            return System.Text.RegularExpressions.Regex.Replace(name, invalidRegStr, "_");
        }
        public void Execute() {
            if (!((EditorLogic.startPod) && (this.Ship != null)))
            {
                return;
            }

            SaveTexture("front" + "_" + ShipName);
        }

        public void Explode()
        {
            if (!EditorLogic.startPod || this.Ship == null)
            {
                return;
            }
            this.Config.Execute(this.Ship);
            UpdateShipBounds();

        }

        public void Update(int width = -1, int height = -1)
        {
            if (!EditorLogic.startPod || this.Ship == null)
            {
                return;
            }

            var dir = EditorLogic.startPod.transform.TransformDirection(this.direction);
            GenTexture(dir, width, height);
            
        }

        internal Texture Texture()
        {
            if (!((EditorLogic.startPod) && (this.Ship != null)))
            {
                return null;
            }
            else
            {
                return this.rt;
            }
        }
    }
}
