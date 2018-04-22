using UnityEngine;
using ToolbarControl_NS;

namespace KronalUtils
{
    [KSPAddon(KSPAddon.Startup.MainMenu, true)]
    public class RegisterToolbar : MonoBehaviour
    {
        void Start()
        {
            ToolbarControl.RegisterMod(KVrVesselShotUI.MODID, KVrVesselShotUI.MODNAME);
        }
    }
}