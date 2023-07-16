using System;
using System.Collections.Generic;
using JvLib.Data;
using JvLib.Routines;
using UnityEngine;
using Random = System.Random;

namespace JvLib.Misc.Generation.Crawler
{
    /// <summary>
    /// A crawler based generation behaviour that creates a 2-dimensional array of <see cref="ICrawlerCell"/>
    /// </summary>
    /// <typeparam name="TCell">Generic Type of the Cell to create</typeparam>
    public partial class CrawlerManager<TCell>
        where TCell : ICrawlerCell, new()
    {
        /// <summary>
        /// The <see cref="CrawlerConfig"/> the Manager provides as creation pattern for the generation of the Grid
        /// </summary>
        protected CrawlerConfig Config { get; }
        
        /// <summary>
        /// The Random Seed used during the generation
        /// </summary>
        protected Random Random { get; }
        
        /// <summary>
        /// Maximum number of cells as defined in the provided <see cref="CrawlerConfig"/>
        /// provided in the <see cref="CrawlerConfig"/> and adapted by the Generation Calls
        /// </summary>
        public int MaxCells { get; private set; }
        
        /// <summary>
        /// Returns the end points of the last Generation Cycles
        /// An end point is the point where a Crawler has been destroyed
        /// </summary>
        public ICollection<Vector2Int> EndPoints { get; private set; }

        private List<Crawler> _crawlers;
        private Grid2D<TCell> _grid;

        /// <summary>
        /// Constructor of the Crawler generation Behaviour
        /// </summary>
        /// <param name="pConfig">The base config defining the settings for each <see cref="Crawler"/> behaviour</param>
        /// <param name="pSeed">The seed to use for the Random Number Generator</param>
        public CrawlerManager(CrawlerConfig pConfig, int pSeed)
        {
            Config = pConfig;
            Random = new Random(pSeed);
            MaxCells = pConfig.MaxCells;
        }

        /// <summary>
        /// Begins a new process of generation by this manager
        /// </summary>
        /// <param name="pGrid">Base <see cref="Grid2D{TCell}"/> to extend and build upon</param>
        /// <param name="pStartPosition">Starting position to spawn the first <see cref="Crawler"/> at</param>
        /// <param name="pAddedMaxCells">
        /// Number to increase the Maximum number of cells by.
        /// Increases the current amount by the given amount.
        /// (Initial amount set through the <see cref="CrawlerConfig"/> provided in the constructor)
        /// </param>
        public void Generate(Grid2D<TCell> pGrid, Vector2Int pStartPosition, int pAddedMaxCells = 0)
        {
            if (IsRunning())
                throw new Exception("Can't start construction while another build is in progress");
            
            _grid = pGrid;
            MaxCells = Mathf.Max(_grid.Count, MaxCells);
            MaxCells += pAddedMaxCells;

            if (_grid.Count >= MaxCells)
            {
                _onComplete.Dispatch(_grid);
                return;
            }
            
            _crawlers = new List<Crawler> {new Crawler(pStartPosition, Random.Next(4) * 90f)};
            EndPoints = new List<Vector2Int>();
            OnCrawlerSpawn(pStartPosition);
            if (!_grid.Contains(pStartPosition))
                _grid.Add(Vector2Int.zero, CreateCell(pStartPosition));
            
            _routine = Routine.Start(RunningRoutine());
        }
    }
}
