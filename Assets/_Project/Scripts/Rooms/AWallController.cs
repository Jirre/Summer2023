using UnityEngine;

namespace Project.World.Rooms
{
    public abstract class AWallController : MonoBehaviour
    {
        protected RoomController Room;

        protected virtual void Awake()
        {
            Room = GetComponentInParent<RoomController>();
            Room.OnEnter += OnRoomEnter;
            Room.OnExit += OnRoomExit;
        }
        
        protected virtual void OnRoomEnter() { }
        protected virtual void OnRoomExit() { }
    }
}
