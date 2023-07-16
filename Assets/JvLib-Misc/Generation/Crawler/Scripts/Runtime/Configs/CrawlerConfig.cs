using JvLib.Data;
using UnityEngine;
using Random = System.Random;

namespace JvLib.Misc.Generation.Crawler
{
    /// <summary>
    /// The config container for a Crawler to derive its base settings from
    /// Instances are created and stored through an instance of <see cref="CrawlerConfigs"/>
    /// </summary>
    public class CrawlerConfig : DataEntry
    {
        [Space]
        [Tooltip("Maximum number of tiles to spawn during creation")]
        [SerializeField] private int _MaxCells = 100;
        
        /// <summary>
        /// Returns the Maximum Number of Cells as per the provided Settings
        /// </summary>
        public int MaxCells => _MaxCells;
        
        [Header("Direction")]
        [Tooltip("Chance that a crawler continues its trajectory")]
        [SerializeField] [Range(0, 100)] private float _ForwardChance = 50;
        [Tooltip("Chance that a crawler turns 90 degrees to the left")]
        [SerializeField] [Range(0, 100)] private float _TurnLeftChance = 50;
        [Tooltip("Chance that a crawler turns 90 degrees to the right")]
        [SerializeField] [Range(0, 100)] private float _TurnRightChance = 50;
        [Tooltip("Chance that a crawler turns 180 degrees backwards")]
        [SerializeField] [Range(0, 100)] private float _ReverseChance = 50;
        
        /// <summary>
        /// Target direction relative to its current direction
        /// </summary>
        public enum EDirection
        {
            Forward,
            Left,
            Right,
            Reverse
        }

        /// <summary>
        /// Calculate a new direction corresponding with the given ranges
        /// </summary>
        /// <returns>The relative direction to move in based on the current direction</returns>
        public EDirection GetDirection(Random pRandom)
        {
            float dTotal = _ForwardChance + _TurnLeftChance + _TurnRightChance + _ReverseChance;

            double value = pRandom.NextDouble();
            if (value <= _ForwardChance / dTotal) 
                return EDirection.Forward;
            value -= (_ForwardChance / dTotal);

            if (value <= _TurnLeftChance / dTotal) 
                return EDirection.Left;
            value -= (_TurnLeftChance / dTotal);

            return value <= _TurnRightChance / dTotal ? EDirection.Right : EDirection.Reverse;
        }
        
        [Space]
        [Header("Spawn Grid")]
        [Tooltip("Chance that a crawler spawns a 1x1 grid of ground every step")]
        [SerializeField] [Range(0, 100)] private float _1X1Chance = 50;
        [Tooltip("Chance that a crawler spawns a 2x2 grid of ground every step")]
        [SerializeField] [Range(0, 100)] private float _2X2Chance = 50;
        [Tooltip("Chance that a crawler spawns a 3x3 grid of ground every step")]
        [SerializeField] [Range(0, 100)] private float _3X3Chance = 50;
        
        /// <summary>
        /// Calculate how many cells to create in a grid-like pattern
        /// </summary>
        /// <returns>An array of positions to create cells on</returns>
        public Vector2Int[] GetGrid(Random pRandom)
        {
            float cTotal = _1X1Chance + _2X2Chance + _3X3Chance;

            double value = pRandom.NextDouble();
            if (value <= _1X1Chance / cTotal) 
                return new [] {Vector2Int.zero };
            
            value -= (_1X1Chance / cTotal);
            if (value <= _2X2Chance / cTotal)
            {
                int x = Mathf.RoundToInt(Mathf.Sign((float)pRandom.NextDouble() - .5f));
                int y = Mathf.RoundToInt(Mathf.Sign((float)pRandom.NextDouble() - .5f));
                
                return new []
                {
                    new Vector2Int(0, 0), new Vector2Int(x, 0),
                    new Vector2Int(0, y), new Vector2Int(x, y),
                };
            }

            return new[]
            {
                new Vector2Int(-1, -1), new Vector2Int(0, -1), new Vector2Int(1, -1),
                new Vector2Int(-1, 0), new Vector2Int(0, 0), new Vector2Int(1, 0),
                new Vector2Int(-1, 1), new Vector2Int(0, 1), new Vector2Int(1, 1),
            };
        }
        
        [Space]
        [Header("Lifetime")]
        [Tooltip("Base chance that a crawler spawns a new spawner")]
        [SerializeField] [Range(-100, 100)] private float _BaseSpawnChance;
        [Tooltip("Added Chance that a crawler spawns a new spawner based on the number of active crawlers")]
        [SerializeField] [Range(-100, 100)] private float _AddedSpawnChance;
        
        /// <summary>
        /// Returns whether to spawn a new Crawler based on current active Crawlers and provided parameters
        /// </summary>
        public bool ShouldSpawnCrawler(Random pRandom, int pActiveCrawlerCount) =>
            pRandom.Next(101) < _BaseSpawnChance + _AddedSpawnChance * pActiveCrawlerCount;

        [Space]
        [Tooltip("Base chance that a generator is removed")]
        [SerializeField] [Range(-100, 100)] private float _BaseRemoveChance;
        [Tooltip("Added Chance that a generator is removed based on the number of active crawlers")]
        [SerializeField] [Range(-100, 100)] private float _AddedRemoveChance;

        /// <summary>
        /// Returns whether to remove a Crawler based on current active Crawlers and provided parameters
        /// </summary>
        public bool ShouldRemoveCrawler(Random pRandom, int pActiveCrawlerCount) =>
            pRandom.Next(101) < _BaseRemoveChance + _AddedRemoveChance * pActiveCrawlerCount;
    }
}
