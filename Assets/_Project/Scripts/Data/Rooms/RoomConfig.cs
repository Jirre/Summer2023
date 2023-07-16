using JvLib.Data;
using Project.World;
using Sirenix.OdinInspector;
using UnityEngine;

namespace Project.Data.Rooms
{
    public class RoomConfig : DataEntry
    {
        [SerializeField, EnumToggleButtons] private EWorldDirection _Connections;
        public EWorldDirection Connections => _Connections;
        
        [SerializeField] private GameObject _Prefab;
        public GameObject Prefab => _Prefab;
    }
}
