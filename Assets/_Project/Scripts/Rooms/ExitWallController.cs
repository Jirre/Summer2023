using UnityEngine;

namespace Project.World.Rooms
{
    public class ExitWallController : AWallController
    {
        [SerializeField] private Renderer _Renderer;
        [SerializeField] private GameObject _Collider;

        protected override void Awake()
        {
            base.Awake();
            
        }
    }
}
