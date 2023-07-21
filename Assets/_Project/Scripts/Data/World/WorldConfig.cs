using JvLib.Data;
using Project.Data.Rooms;
using UnityEngine;

namespace Project.Data.World
{
    public partial class WorldConfig : DataEntry
    {
        [SerializeField] private RoomConfig[] _Rooms;
        public RoomConfig[] Rooms => _Rooms;
        
        [SerializeField] private GameObject[] _SolidWalls;
        public GameObject[] SolidWalls => _SolidWalls;
        [SerializeField] private GameObject[] _ConnectionWalls;
        public GameObject[] ConnectionWalls => _ConnectionWalls;
        [SerializeField] private GameObject[] _ExitWalls;
        public GameObject[] ExitWalls => _ExitWalls;

    }
}
