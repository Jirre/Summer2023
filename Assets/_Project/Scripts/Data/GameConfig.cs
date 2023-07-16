using JvLib.Audio.Data;
using JvLib.Data;
using JvLib.Misc.Generation.Crawler;
using Project.Data.World;
using Sirenix.OdinInspector;
using UnityEngine;

namespace Project.Data
{
    public partial class GameConfig : DataEntry
    {
        [SerializeField, TabGroup("Creation")] private WorldConfig _WorldConfig;
        public WorldConfig WorldConfig => _WorldConfig;
        [SerializeField, TabGroup("Creation")] private CrawlerConfig _CrawlerConfig;
        public CrawlerConfig CrawlerConfig => _CrawlerConfig;
        
        [SerializeField, TabGroup("Sound")] private LoopAudioCollection _Music;
        public LoopAudioCollection Music => _Music;
        
        [SerializeField, TabGroup("Sound")] private LoopAudioCollection _Ambience;
        public LoopAudioCollection Ambience => _Ambience;
    }
}
