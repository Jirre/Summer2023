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
            _player = FindObjectOfType<PlayerController>();
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
        }

        private void OnPlayerChange(PlayerController pController)
        {
            _player = pController;
        }
    }
}

