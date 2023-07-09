using JvLib.Services;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Project.Systems.Input
{
    [ServiceInterface(Name = "Input"), RequireComponent(typeof(PlayerInputManager))]
    public class InputServiceManager : MonoBehaviour, IService
    {
        public bool IsServiceReady { get; private set; }
        public PlayerInputManager InputManager { get; private set; }
        
        private void Awake()
        {
            InputManager = GetComponent<PlayerInputManager>();
            ServiceLocator.Instance.Register(this);
        }

        private void Start()
        {
            IsServiceReady = true;
            ServiceLocator.Instance.ReportInstanceReady(this);
        }
    }
}
