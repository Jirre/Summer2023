using JvLib.Data;
using UnityEngine;

namespace Project.Data.Rooms
{
    [CreateAssetMenu(
        menuName = "Data/Room",
        fileName = nameof(RoomConfigs),
        order = 170)]
    public class RoomConfigs : DataList<RoomConfig>
    {
        
    }
}
