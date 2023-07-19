using System;
using JvLib.Events;
using JvLib.Services;
using UnityEngine;

namespace Project.World.Rooms
{
    public class RoomController : MonoBehaviour
    {
        public EWorldDirection Connections { get; private set; }
        private Vector2Int _position;
        private bool _isActive;

        private SafeEvent _onEnter = new SafeEvent();
        public event Action OnEnter
        {
            add => _onEnter += value;
            remove => _onEnter -= value;
        }

        private SafeEvent _onExit = new SafeEvent();
        public event Action OnExit
        {
            add => _onExit += value;
            remove => _onExit -= value;
        }
        
        public void Initialize(WorldCell pCell)
        {
            Connections = pCell.Connections;
            _position = pCell.Position;
            Svc.World.OnCellChange += OnCellChange;
            pCell.SetPrefab(this);
            
            SpawnWalls();
        }

        private void SpawnWalls()
        {
            for (int i = 0; i < 4; i++)
            {
                EWorldDirection dir = (EWorldDirection)(1 << (i + 1));
                GameObject obj;
                if ((Connections & dir) != 0)
                    obj = Instantiate(Svc.World.GetConnectedWall(), transform);
                else obj = Instantiate(Svc.World.GetSolidWall(), transform);

                obj.transform.localPosition = Vector3.zero;
                obj.transform.localEulerAngles = Vector3.up * i * -90f;
            }
        }

        private void OnDestroy()
        {
            Svc.World.OnCellChange -= OnCellChange;
        }

        private void OnCellChange(Vector2Int pPosition)
        {
            if (_isActive && pPosition != _position)
            {
                _onExit.Dispatch();
                return;
            }
            if (pPosition == _position)
                _onEnter.Dispatch();
        }
        
        private void OnDrawGizmos()
        {
            Gizmos.color = Color.cyan;
            Gizmos.DrawWireCube(transform.position, Constants.ROOM_SIZE_XZ + new Vector3(1, 0, 1) * Constants.ROOM_BORDER_WIDTH * 2f);
            
            Gizmos.color = Color.blue;
            Gizmos.DrawWireCube(transform.position, Constants.ROOM_SIZE_XZ);
            
            Gizmos.color = Color.red;
            Vector3 sizes = (Constants.ROOM_SIZE_XZ + Vector3.one * Constants.ROOM_BORDER_WIDTH);
            if ((Connections & EWorldDirection.Right) != 0) 
                Gizmos.DrawLine(transform.position, transform.position + Vector3.right * sizes.x);
            if ((Connections & EWorldDirection.Up) != 0)
                Gizmos.DrawLine(transform.position, transform.position + Vector3.forward * sizes.z);

            if ((Connections & EWorldDirection.Left) != 0)
                Gizmos.DrawLine(transform.position, transform.position + Vector3.left * sizes.x);
            if ((Connections & EWorldDirection.Down) != 0)
                Gizmos.DrawLine(transform.position, transform.position + Vector3.back * sizes.z);
        }
    }
}
