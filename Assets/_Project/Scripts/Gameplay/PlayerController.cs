using System.Collections;
using JvLib.Routines;
using JvLib.Services;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Project.Gameplay
{
    [RequireComponent(typeof(PlayerInput))]
    public partial class PlayerController : MonoBehaviour
    {
        private PlayerInput _input;
        
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

        private void Awake()
        {
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
    }
}
