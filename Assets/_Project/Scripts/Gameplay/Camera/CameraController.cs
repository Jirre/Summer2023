using JvLib.Services;
using UnityEngine;

namespace Project.Gameplay
{
    public partial class CameraController : MonoBehaviour
    {
        private Camera _camera;
        private PlayerController _player;
        
        private void Awake()
        {
            _camera = GetComponentInChildren<Camera>();
            OnPlayerChange(FindObjectOfType<PlayerController>());
        }

        private void Start()
        {
            Svc.Gameplay.OnPlayerChanged += OnPlayerChange;
        }

        private void OnDestroy()
        {
            Svc.Gameplay.OnPlayerChanged -= OnPlayerChange;
        }

        private void Update()
        {
            UpdateSeeThrough();
            MovementUpdate();
        }

        private void OnPlayerChange(PlayerController pController)
        {
            _player = pController;
            MovementOnPlayerChanged();
        }
    }
}

