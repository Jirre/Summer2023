using JvLib.Data;
using UnityEngine;

namespace Project.Data.World
{
    [CreateAssetMenu(
        menuName = "Data/World",
        fileName = nameof(WorldConfigs),
        order = 170)]
    public class WorldConfigs : DataList<WorldConfig>
    {
    }
}
