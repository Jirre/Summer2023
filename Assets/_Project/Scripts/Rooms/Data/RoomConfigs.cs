using JvLib.Data;
using UnityEngine;

namespace Project.Rooms.Data
{
    [CreateAssetMenu(
        menuName = "Data/Rooms",
        fileName = nameof(RoomConfigs),
        order = 170)]
    public class RoomConfigs : DataList<RoomConfig>
    {
    }
}
