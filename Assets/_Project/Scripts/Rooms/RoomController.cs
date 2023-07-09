using UnityEngine;

namespace Project.Rooms
{
    public class RoomController : MonoBehaviour
    {
        private void OnDrawGizmosSelected()
        {
            Gizmos.color = Color.cyan;
            Gizmos.DrawWireCube(transform.position, Constants.ROOM_SIZE_XZ + new Vector3(1, 0, 1) * Constants.ROOM_BORDER_WIDTH * 2f);
            
            Gizmos.color = Color.blue;
            Gizmos.DrawWireCube(transform.position, Constants.ROOM_SIZE_XZ);
        }
    }
}
