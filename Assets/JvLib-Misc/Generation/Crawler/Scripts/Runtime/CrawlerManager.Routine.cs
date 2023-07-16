using System;
using System.Collections;
using JvLib.Data;
using JvLib.Events;
using JvLib.Routines;
using UnityEngine;

namespace JvLib.Misc.Generation.Crawler
{
    public partial class CrawlerManager<TCell> // Routine
        where TCell : ICrawlerCell, new()
    {
        private Routine _routine;

        /// <summary>
        /// Checks if any <see cref="Crawler"/> managed by this manager is currently running
        /// </summary>
        public bool IsRunning() => _routine?.IsRunning() ?? false;
        

        private SafeEvent _onStart = new SafeEvent();
        /// <summary>
        /// Callback that is called when a build is started
        /// </summary>
        public event Action OnStart
        {
            add => _onStart += value;
            remove => _onStart -= value;
        }
        
        private SafeEvent<Grid2D<TCell>> _onComplete = new SafeEvent<Grid2D<TCell>>();
        /// <summary>
        /// Callback that is called when a build is finished
        /// </summary>
        public event Action<Grid2D<TCell>> OnComplete
        {
            add => _onComplete += value;
            remove => _onComplete -= value;
        }
        
        private IEnumerator RunningRoutine()
        {
            OnStartBuild();
            _onStart.Dispatch();

            while (_crawlers.Count != 0)
            {
                int count = _crawlers.Count;
                for (int i = 0; i < count; i++)
                {
                    _crawlers[i].Move(Config.GetDirection(Random));
                    Vector2Int[] grid = Config.GetGrid(Random);
                
                    for (int j = 0; j < grid.Length; j++)
                    {
                        Vector2Int rPos = grid[j] + _crawlers[i].Position;
                        if (!_grid.Contains(rPos))
                            _grid.Add(rPos, CreateCell(rPos));
                    }
                
                    if (Config.ShouldSpawnCrawler(Random, count))
                    {
                        //Add new Crawler but dont increase count this iteration
                        //New Crawler should wait one iteration before acting
                        _crawlers.Add(new Crawler(_crawlers[i].Position, Random.Next(4) * 90f));
                        OnCrawlerSpawn(_crawlers[i].Position);
                    }

                    if (Config.ShouldRemoveCrawler(Random, count))
                    {
                        //Remove current digger from list, as well as reduce count by 1 to prevent an out of bound error
                        count--;
                        OnCrawlerRemove(_crawlers[i].Position);
                        EndPoints.Add(_crawlers[i].Position);
                        _crawlers.RemoveAt(i--);
                    }
                }
                
                if (_grid.Count >= MaxCells)
                {
                    for (int i = 0; i < _crawlers.Count; i++)
                    {
                        OnCrawlerRemove(_crawlers[i].Position);
                        EndPoints.Add(_crawlers[i].Position);
                    }
                    _crawlers.Clear();
                }

                yield return new WaitForEndOfFrame();
            }
            
            OnEndBuild();
            _onComplete.Dispatch(_grid);
        }

        /// <summary>
        /// Create a new <see cref="ICrawlerCell"/> of type <typeparamref name="TCell"/> at a position in the Grid <see cref="Cells"/>
        /// </summary>
        /// <param name="pPosition">The position to create the new <see cref="ICrawlerCell"/> of type <typeparamref name="TCell"/> at</param>
        /// <returns>The <see cref="ICrawlerCell"/> of type <typeparamref name="TCell"/> instance created during this call</returns>
        protected virtual TCell CreateCell(Vector2Int pPosition)
        {
            return new TCell
            {
                Position = pPosition
            };
        }
        
        /// <summary>
        /// Internal callback that is called when a build is started
        /// </summary>
        protected virtual void OnStartBuild() { }
        
        /// <summary>
        /// Internal callback that is called when a build is finished
        /// </summary>
        protected virtual void OnEndBuild() { }
        
        /// <summary>
        /// Internal callback that is called when a new <see cref="Crawler"/> is created
        /// </summary>
        /// <param name="pPosition">The position where the newly created <see cref="Crawler"/> is spawned, that corresponds to the Grid <see cref="Cells"/></param>
        protected virtual void OnCrawlerSpawn(Vector2Int pPosition) { }
        /// <summary>
        /// Internal callback that is called when an existing <see cref="Crawler"/> is Destroyed
        /// </summary>
        /// <param name="pPosition">The position where the <see cref="Crawler"/> was located when spawned, that corresponds to the Grid <see cref="Cells"/></param>
        protected virtual void OnCrawlerRemove(Vector2Int pPosition) { }
    }
}
