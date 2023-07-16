using JvLib.Data;
using UnityEngine;

namespace Project.Data
{
    [CreateAssetMenu(
        menuName = "Data/GameConfigs",
        fileName = nameof(GameConfigs),
        order = 170)]
    public class GameConfigs : DataList<GameConfig>
    {
    }
}
