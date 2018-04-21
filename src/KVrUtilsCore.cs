using System.IO;
using UnityEngine;

namespace KronalUtils
{
    [KSPAddon(KSPAddon.Startup.EditorAny, true)]
    class KVrUtilsCore : MonoBehaviour
    {
        public static BundleIndex AssetIndex;
        public static string ModPath = Path.Combine(Directory.GetParent(KSPUtil.ApplicationRootPath).ToString() + Path.DirectorySeparatorChar + "GameData" + Path.DirectorySeparatorChar, "KronalUtils");
        public static string SavePath = Path.Combine(Directory.GetParent(KSPUtil.ApplicationRootPath).ToString(), "Screenshots");
        private void Awake()
        {
             AssetIndex = gameObject.AddComponent<BundleIndex>(); // new BundleIndex();
        }
        public static string ModRoot()
        {
            return ModPath;
        }
        public static string ModExport()
        {
            return SavePath;
        }
        public static Shader getShaderById(string idIn)
        {
            return AssetIndex.getShaderById(idIn);
        }

    }
}
