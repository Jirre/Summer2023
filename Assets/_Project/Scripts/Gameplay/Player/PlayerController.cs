using System.Collections;
using JvLib.Routines;
using JvLib.Services;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Project.Gameplay
{
    [RequireComponent(
        typeof(Rigidbody), 
        typeof(PlayerInput))]
    public partial class PlayerController : MonoBehaviour
    {
        private Rigidbody _rigidbody;
        
        private PlayerInput _input;

        private void Awake()
        {
            _rigidbody = GetComponent<Rigidbody>();
            
            InitNavigation();
            Routine.Start(LoadPlayerInput());
        }

        private void OnDestroy()
        {
            UnloadPlayerInput();
        }

        private void Update()
        {
            NavigationUpdate();
        }

        #region --- Input ---

        private IEnumerator LoadPlayerInput()
        {
            yield return Svc.Ref.Input.WaitForInstanceReadyAsync();
            _input ??= GetComponent<PlayerInput>();
            _input.ActivateInput();
            
            AddNavigationListeners();
        }

        private void UnloadPlayerInput()
        {
            _input ??= GetComponent<PlayerInput>();
            _input.DeactivateInput();

            RemoveNavigationListeners();
        }

        #endregion
    }
}
