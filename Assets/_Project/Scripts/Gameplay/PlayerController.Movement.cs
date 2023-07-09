using JvLib.Utilities;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Project.Gameplay
{
    public partial class PlayerController // Navigation
    {
        private enum LookStyle
        {
            VectorToDirection,
            MouseLookAt
        }
        
        [SerializeField, BoxGroup("Input")] private InputActionReference _MovementInput;
        [SerializeField, BoxGroup("Input")] private InputActionReference _LookInput;
        [SerializeField, BoxGroup("Input")] private float _LookPlaneHeight = 0.5f;
        private Vector2 _cachedMovementInput;
        private Vector2 _cachedLookInput;
        private LookStyle _lookStyle;
        private Plane _lookPlane;

        [SerializeField, BoxGroup("Stats")] private float _MovementSpeed;

        private void InitNavigation()
        {
            _lookPlane = new Plane(Vector3.up, _LookPlaneHeight);
        }
        
        private void AddNavigationListeners()
        {
            _input.actions[_MovementInput.action.name].AddListeners(OnMovementInput);
            _input.actions[_LookInput.action.name].AddListeners(OnLookInput);

            _input.onControlsChanged += OnNavigationSchemeChange;
            OnNavigationSchemeChange(_input);
        }

        private void RemoveNavigationListeners()
        {
            _input.actions[_MovementInput.action.name].RemoveListeners(OnMovementInput);
            _input.actions[_LookInput.action.name].RemoveListeners(OnLookInput);
            
            _input.onControlsChanged -= OnNavigationSchemeChange;
        }
        
        private void OnMovementInput(InputAction.CallbackContext pContext)
        {
            _cachedMovementInput = pContext.ReadValue<Vector2>();
        }
        private void OnLookInput(InputAction.CallbackContext pContext)
        {
            _cachedLookInput = pContext.ReadValue<Vector2>();
        }

        private void OnNavigationSchemeChange(PlayerInput pInput)
        {
            _cachedLookInput = Vector2.zero;

            Debug.Log(pInput.currentControlScheme);
            
            if (pInput.currentControlScheme == "Gamepad")
            {
                if (_lookStyle != LookStyle.VectorToDirection)
                    _cachedLookInput = Vector2.zero;
                _lookStyle = LookStyle.VectorToDirection;
                return;
            }
            else
            {
                if (_lookStyle != LookStyle.MouseLookAt)
                    _cachedLookInput = Vector2.zero;
                _lookStyle = LookStyle.MouseLookAt;
                return;
            }
        }

        private void NavigationUpdate()
        {
            transform.position += new Vector3(_cachedMovementInput.x, 0f, _cachedMovementInput.y) * _MovementSpeed * Time.deltaTime;

            switch (_lookStyle)
            {
                case LookStyle.VectorToDirection:
                    if (Vector2.Distance(Vector2.zero, _cachedLookInput) < 0.2f)
                        return;
                    transform.localEulerAngles = new Vector3(0, MathUtility.DegAtan2(-_cachedLookInput.y, _cachedLookInput.x), 0);
                    break;
                
                case LookStyle.MouseLookAt:
                    Ray ray = Camera.main.ScreenPointToRay(_cachedLookInput);
                    if (_lookPlane.Raycast(ray, out float distance))
                    {
                        Vector3 position = ray.GetPoint(distance);
                        transform.localEulerAngles = new Vector3(0, 
                            MathUtility.DegPointDirection(transform.position.x, transform.position.z, 
                                position.x, -position.z), 0);
                    }
                    break;
            }
        }
    }
}
