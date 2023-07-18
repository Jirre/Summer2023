using System;
using System.Collections;
using System.Collections.Generic;
using JvLib.Data;
using JvLib.Events;
using Project.World.Rooms;
using Sirenix.OdinInspector;
using UnityEngine;

namespace Project.World
{
    public partial class WorldServiceManager // StateMachine
    {
        private List<WorldCell> _unconnectedCells;

        private enum EStates
        {
            Idle,
            
            Crawler,
            Pathing,
            Render
        }
        
        private EventStateMachine<EStates> _stateMachine;

        private void InitStates()
        {
            _stateMachine = new EventStateMachine<EStates>(nameof(WorldServiceManager));

            _stateMachine.Add(EStates.Idle, IdleState);
            
            _stateMachine.Add(EStates.Crawler, CrawlerState);
            _stateMachine.Add(EStates.Pathing, PathingState);
            _stateMachine.Add(EStates.Render, RenderState);
            
            _stateMachine.GotoState(EStates.Idle);
        }
        
        /// <summary>
        /// Flag State
        /// </summary>
        private static void IdleState(EventState<EStates> pState) { }
        
        public IEnumerator WaitForCompleteBuild()
        {
            if (!_stateMachine.IsCurrentState(EStates.Idle))
            {
                yield return null;
            }
        }
        
        [Button]
        public void Generate()
        {
            if (!_stateMachine.IsCurrentState(EStates.Idle))
                throw new Exception("Can't build a crawler while another build is in progress");

            _grid ??= new Grid2D<WorldCell>();
            _unconnectedCells = new List<WorldCell>();
            
            _crawler = new WorldCrawler(_crawlerConfig, (int) DateTime.Now.Ticks & int.MaxValue);

            _crawler.OnComplete += OnCrawlerFinish;
            _crawler.Generate(_grid, Vector2Int.zero);

            _stateMachine.GotoState(EStates.Crawler);
        }

        public void Clear()
        {
            if (!_stateMachine.IsCurrentState(EStates.Idle))
                throw new Exception("Can't start clearing of a world while another build is in progress");
            
            _grid ??= new Grid2D<WorldCell>();
            _grid.Dispose();
        }
        
        /// <summary>
        /// Flag State
        /// </summary>
        private static void CrawlerState(EventState<EStates> pState) { }

        private void OnCrawlerFinish(Grid2D<WorldCell> pResult)
        {
            _crawler.OnComplete -= OnCrawlerFinish;
            _grid = pResult;

            foreach (KeyValuePair<Vector2Int,WorldCell> kvp in _grid)
            {
                if (kvp.Key == Vector2Int.zero)
                {
                    kvp.Value.SetAsRoot();
                    continue;
                }
                
                _unconnectedCells.Add(kvp.Value);
                kvp.Value.OnConnectToRoot += OnConnectToRoot;
            }
            
            _stateMachine.GotoState(EStates.Pathing);
        }
        
        private void PathingState(EventState<EStates> pState)
        {
            if (_unconnectedCells.Count <= 0)
            {
                pState.GotoState(EStates.Render);
                return;
            }
            
            WorldCell cell = _unconnectedCells[Random.Next(_unconnectedCells.Count)];
            Vector2Int position = cell.Position;
            int pDirection = Random.Next(1 << 5);

            if ((pDirection & (int)EWorldDirection.Right) != 0 && _grid.Contains(position + Vector2Int.right))
                cell.Connect(_grid[position + Vector2Int.right]);
            if ((pDirection & (int)EWorldDirection.Up) != 0 && _grid.Contains(position + Vector2Int.up))
                cell.Connect(_grid[position + Vector2Int.up]);
            if ((pDirection & (int)EWorldDirection.Left) != 0 && _grid.Contains(position + Vector2Int.left))
                cell.Connect(_grid[position + Vector2Int.left]);
            if ((pDirection & (int)EWorldDirection.Down) != 0 && _grid.Contains(position + Vector2Int.down))
                cell.Connect(_grid[position + Vector2Int.down]);
        }

        private void OnConnectToRoot(WorldCell pCell)
        {
            if (_unconnectedCells.Contains(pCell))
                _unconnectedCells.Remove(pCell);
        }

        [SerializeField] private RoomController _RoomPrefab;
        
        private void RenderState(EventState<EStates> pState)
        {
            foreach (KeyValuePair<Vector2Int,WorldCell> kvp in _grid)
            {
                GameObject gObject = Instantiate(_RoomPrefab.gameObject, transform);
                Vector3 position = new Vector3(
                    kvp.Key.x * Constants.CELL_SIZE_XY.x, 0,
                    kvp.Key.y * Constants.CELL_SIZE_XY.y);
                gObject.transform.localPosition = position;
                gObject.name = $"Room[{kvp.Key.x}, {kvp.Key.y}]";
                RoomController controller = gObject.GetComponent<RoomController>();
                controller.Initialize(kvp.Value);
            }

            pState.GotoState(EStates.Idle);
        }
    }
}
