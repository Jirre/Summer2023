using JvLib.Data;
using UnityEngine;

namespace JvLib.Misc.Generation.Crawler
{
    /// <summary>
    /// The Data List used to store the <see cref="CrawlerConfig"/>
    /// </summary>
    [CreateAssetMenu(
        menuName = "JvLib/Generation/Crawler Configs",
        fileName = nameof(CrawlerConfigs),
        order = 201)]
    public class CrawlerConfigs : DataList<CrawlerConfig>
    {
    }
}
