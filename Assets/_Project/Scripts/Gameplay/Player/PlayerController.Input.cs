using JvLib.Services;
using Project.StateMachines.Main;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Project.Gameplay
{
    public partial class PlayerController // Input
    {
        private enum LookStyle
        {
            VectorToDirection,
            MouseLookAt
        }
        
        [SerializeField, BoxGroup("Input")] private InputActionReference _MovementInput;
        [SerializeField, BoxGroup("Input")] private InputActionReference _LookInput;
        [SerializeField, BoxGroup("Input"), Indent] private float _LookPlaneHeight = 0.5f;
        [SerializeField, BoxGroup("Input")] private InputActionReference _AttackInput;
        private Vector2 _cachedMovementInput;
        private Vector2 _cachedLookInput;
        private LookStyle _lookStyle;
        private Plane _lookPlane;
        private bool _cachedAttackInput;

        private void InitInput()
        {
            _lookPlane = new Plane(Vector3.down, _LookPlaneHeight);
        }
        
        private void AddInputListeners()
        {
            _input.actions[_MovementInput.action.name].AddListeners(OnMovementInput);
            _input.actions[_LookInput.action.name].AddListeners(OnLookInput);
            _input.actions[_AttackInput.action.name].AddListeners(OnAttackInput);

            _input.onControlsChanged += OnInputSchemeChange;
            OnInputSchemeChange(_input);
        }

        private void RemoveInputListeners()
        {
            if (_input == null)
                return;
            
            _input.actions[_MovementInput.action.name].RemoveListeners(OnMovementInput);
            _input.actions[_LookInput.action.name].RemoveListeners(OnLookInput);
            _input.actions[_AttackInput.action.name].RemoveListeners(OnAttackInput);
            
            _input.onControlsChanged -= OnInputSchemeChange;
        }
        
        private void OnMovementInput(InputAction.CallbackContext pContext)
        {
            _cachedMovementInput = pContext.ReadValue<Vector2>();
        }
        private void OnLookInput(InputAction.CallbackContext pContext)
        {
            _cachedLookInput = pContext.ReadValue<Vector2>();
        }
        private void OnAttackInput(InputAction.CallbackContext pContext)
        {
            _cachedAttackInput = pContext.ReadValueAsButton();
            if (pContext.canceled)
                _currentAttackDelay = Mathf.Min(_currentAttackDelay, _AttackReleasedDelay);
        }

        private void OnInputSchemeChange(PlayerInput pInput)
        {
            _cachedLookInput = Vector2.zero;

            switch (pInput.currentControlScheme)
            {
                case "Gamepad": 
                    if (_lookStyle != LookStyle.VectorToDirection)
                        _cachedLookInput = Vector2.zero;
                    _lookStyle = LookStyle.VectorToDirection;
                    return;
                
                default:
                    if (_lookStyle != LookStyle.MouseLookAt)
                        _cachedLookInput = Vector2.zero;
                    _lookStyle = LookStyle.MouseLookAt;
                    return;
            }
        }
    }
}
