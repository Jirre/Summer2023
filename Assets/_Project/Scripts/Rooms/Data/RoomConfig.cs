using JvLib.Data;
using UnityEngine;

namespace Project.Rooms.Data
{
    public class RoomConfig : DataEntry
    {
        [SerializeField] private RoomController _Prefab;
        public RoomController Prefab => _Prefab;
    }
}

