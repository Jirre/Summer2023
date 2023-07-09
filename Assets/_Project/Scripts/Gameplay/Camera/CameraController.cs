using System;
using JvLib.Services;
using UnityEngine;

namespace Project.Gameplay
{
    public class CameraController : MonoBehaviour
    {
        private PlayerController _player;
        
        private void Awake()
        {
            _player = FindObjectOfType<PlayerController>();
            Svc.Gameplay.OnPlayerChanged += OnPlayerChange;
        }

        private void OnDestroy()
        {
            Svc.Gameplay.OnPlayerChanged -= OnPlayerChange;
        }

        private void Update()
        {

        }

        private void OnPlayerChange(PlayerController pController)
        {
            _player = pController;
        }
    }
}

