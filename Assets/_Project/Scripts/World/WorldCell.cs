using System;
using System.Collections.Generic;
using JvLib.Events;
using JvLib.Misc.Generation.Crawler;
using UnityEngine;

namespace Project.World
{
    public class WorldCell : ICrawlerCell
    {
        public Vector2Int Position { get; set; }
        public EWorldDirection Connections { get; private set; }

        public bool IsConnectedToRoot { get; private set; }
        private List<WorldCell> _connections;

        private SafeEvent<WorldCell> _onConnectToRoot = new SafeEvent<WorldCell>();
        public event Action<WorldCell> OnConnectToRoot
        {
            add => _onConnectToRoot += value;
            remove => _onConnectToRoot -= value;
        }

        public void SetAsRoot()
        {
            IsConnectedToRoot = true;
        }

        public bool SetAsExit(EWorldDirection pDirection)
        {
            return false;
        }
        
        public void Connect(WorldCell pCell)
        {
            _connections ??= new List<WorldCell>();
            if (pCell.IsConnectedToRoot && !IsConnectedToRoot)
            {
                IsConnectedToRoot = true;
                _onConnectToRoot.Dispatch(this);
                foreach (WorldCell cell in _connections)
                {
                    cell.Connect(this);
                }
            }

            if (_connections.Contains(pCell)) return;
            _connections.Add(pCell);
            Vector2Int vector = pCell.Position - Position;

            if (vector == Vector2Int.right)
                Connections += (int)EWorldDirection.Right;
            else if (vector == Vector2Int.up)
                Connections += (int)EWorldDirection.Up;
            else if (vector == Vector2Int.left)
                Connections += (int)EWorldDirection.Left;
            else if (vector == Vector2Int.down)
                Connections += (int)EWorldDirection.Down;
            
            pCell.Connect(this);
        }

        public void Dispose()
        {
            //throw new System.NotImplementedException();
        }
    }
}
