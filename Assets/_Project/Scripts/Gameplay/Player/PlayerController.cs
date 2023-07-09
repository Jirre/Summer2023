using System.Collections;
using JvLib.Routines;
using JvLib.Services;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Project.Gameplay
{
    [RequireComponent(typeof(Rigidbody))]
    public partial class PlayerController : MonoBehaviour
    {
        private Rigidbody _rigidbody;
        private PlayerInput _input;

        private void Awake()
        {
            _rigidbody = GetComponent<Rigidbody>();
            
            InitNavigation();
            Routine.Start(LoadPlayerInput());
            
            Svc.Ref.Gameplay.WaitForInstanceReady(() => Svc.Gameplay.InvokeOnPlayerChange(this));
        }

        private void OnDestroy()
        {
            Svc.Gameplay.InvokeOnPlayerChange(null);
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
            _input = Svc.Input.PlayerInput;
            
            AddNavigationListeners();
        }

        private void UnloadPlayerInput()
        {
            RemoveNavigationListeners();
        }

        #endregion
    }
}
