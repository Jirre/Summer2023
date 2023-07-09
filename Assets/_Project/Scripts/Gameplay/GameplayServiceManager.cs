using System;
using JvLib.Events;
using JvLib.Services;
using UnityEngine;

namespace Project.Gameplay
{
    [ServiceInterface(Name = "Gameplay")]
    public class GameplayServiceManager : MonoBehaviour, IService
    {
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
        

    }
}
