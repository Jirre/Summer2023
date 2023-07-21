using System;
using JvLib.Events;
using JvLib.Services;
using UnityEngine;

namespace Project.Gameplay
{
    [ServiceInterface(Name = "Gameplay")]
    public partial class GameplayServiceManager : MonoBehaviour, IService
    {
        [SerializeField] private PlayerController _PlayerPrefab;
        [SerializeField] private PlayerController _currentPlayer;
        
        public bool IsServiceReady { get; private set; }

        private SafeEvent<PlayerController> _onPlayerChanged = new SafeEvent<PlayerController>();
        public event Action<PlayerController> OnPlayerChanged
        {
            add => _onPlayerChanged += value;
            remove => _onPlayerChanged -= value;
        }
        public void InvokeOnPlayerChange(PlayerController pController) => _onPlayerChanged.Dispatch(pController);

        private void Awake()
        {
            ServiceLocator.Instance.Register(this);
        }

        private void Start()
        {
            IsServiceReady = true;
            ServiceLocator.Instance.ReportInstanceReady(this);
        }

        public void SpawnPlayer(Vector2 pPosition)
        {
            if (_currentPlayer != null)
            {
                Destroy(_currentPlayer.gameObject);
                _currentPlayer = null;
            }
            _currentPlayer = Instantiate(_PlayerPrefab, pPosition, Quaternion.Euler(0, 90f, 0));
            _onPlayerChanged.Dispatch(_currentPlayer);
        }
    }
}
