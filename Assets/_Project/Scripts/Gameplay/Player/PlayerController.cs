using System.Collections;
using JvLib.Routines;
using JvLib.Services;
using JvLib.Utilities;
using Project.StateMachines.Main;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Project.Gameplay
{
    [RequireComponent(typeof(Rigidbody))]
    public partial class PlayerController : MonoBehaviour
    {
        private Rigidbody _rigidbody;
        private PlayerInput _input;
        
        [SerializeField, BoxGroup("Stats")] private float _MovementSpeed;
        [SerializeField, BoxGroup("Stats")] private float _AttackRepeatDelay = 0.75f;
        [SerializeField, BoxGroup("Stats"), Indent] private float _AttackReleasedDelay = 0.25f;
        private float _currentAttackDelay;

        private void Awake()
        {
            _rigidbody = GetComponent<Rigidbody>();
            
            InitInput();
            Routine.Start(LoadPlayerInput());
            
            Svc.Ref.Gameplay.WaitForInstanceReady(() => Svc.Gameplay.InvokeOnPlayerChange(this));
        }

        private void OnDestroy()
        {
            UnloadPlayerInput();
        }

        private void Update()
        {
            if (Svc.GameStateMachine.CurrentState.StateType != GameStates.Gameplay)
                return;
            
            MovementUpdate();
            AttackUpdate();
            AnimatorSpeedUpdate();
        }

        #region --- Input ---

        private IEnumerator LoadPlayerInput()
        {
            yield return Svc.Ref.Input.WaitForInstanceReadyAsync();
            _input = Svc.Input.PlayerInput;
            
            AddInputListeners();
        }

        private void UnloadPlayerInput()
        {
            RemoveInputListeners();
        }

        #endregion
        
        private void MovementUpdate()
        {
            _rigidbody.position += new Vector3(_cachedMovementInput.x, 0f, _cachedMovementInput.y) * _MovementSpeed * Time.deltaTime;

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
                            MathUtility.DegPointDirection(_rigidbody.position.x, -_rigidbody.position.z, 
                                position.x, -position.z), 0);
                    }
                    break;
            }
        }

        private void AttackUpdate()
        {
            _currentAttackDelay = Mathf.Max(_currentAttackDelay - Time.deltaTime, 0f);
            
            if (!_cachedAttackInput)
                return;

            if (_currentAttackDelay <= 0)
            {
                TriggerAnimatorAttack();
                _currentAttackDelay = _AttackRepeatDelay;
            }
        }
    }
}
