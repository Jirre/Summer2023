using JvLib.Services;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Project.Systems.Input
{
    [ServiceInterface(Name = "Input"), 
     RequireComponent(
         typeof(PlayerInputManager),
         typeof(PlayerInput))]
    public class InputServiceManager : MonoBehaviour, IService
    {
        public bool IsServiceReady { get; private set; }
        private PlayerInputManager _inputManager;
        public PlayerInput PlayerInput { get; private set; }
        private Gamepad _gamepad;
        
        private void Awake()
        {
            _inputManager = GetComponent<PlayerInputManager>();
            PlayerInput = GetComponent<PlayerInput>();
            PlayerInput.onControlsChanged += OnDeviceChange;
            StopHaptics();
            ServiceLocator.Instance.Register(this);
        }

        private void Start()
        {
            IsServiceReady = true;
            ServiceLocator.Instance.ReportInstanceReady(this);
        }

        private void OnDeviceChange(PlayerInput pInput)
        {
            _gamepad = PlayerInput.GetDevice<Gamepad>();
            StopHaptics();
        }

        public void StopHaptics() => SetHaptics(0f, 0f);
        
        public void SetHaptics(float pLow, float pHigh)
        {
            _gamepad?.SetMotorSpeeds(pLow, pHigh);
        }
    }
}
