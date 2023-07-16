using JvLib.Misc.Generation.Crawler;

namespace Project.World
{
    public class WorldCrawler : CrawlerManager<WorldCell>
    {
        public WorldCrawler(CrawlerConfig pConfig, int pSeed) : 
            base(pConfig, pSeed)
        {
        }
    }
}
