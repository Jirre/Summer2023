using JvLib.Data;
using Project.World.Rooms;
using UnityEngine;

namespace Project.Data.Rooms
{
    public class RoomConfig : DataEntry
    {
        [SerializeField] private RoomController _Prefab;
        public RoomController Prefab => _Prefab;
    }
}
