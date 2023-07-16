using Project.World;
using UnityEngine;

namespace Project.Rooms
{
    public class RoomController : MonoBehaviour
    {
        public EWorldDirection Connections { get; private set; }
        
        public void Initialize(WorldCell pCell)
        {
            Connections = pCell.Connections;
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
