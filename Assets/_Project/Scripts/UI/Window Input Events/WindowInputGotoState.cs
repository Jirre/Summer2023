using JvLib.Services;
using JvLib.Windows;
using Project.StateMachines.Main;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Project.UI.Windows.Windows
{
    public class WindowInputGotoState : MonoBehaviour, IOnWindowShow, IOnWindowHide
    {
        [SerializeField] private InputActionReference _PauseInput;
        private PlayerInput _input;

        [SerializeField] private GameStates _ActiveState;
        [SerializeField] private GameStates _GotoState;

        public void OnWindowShow(object context)
        {
            _input ??= Svc.Input.PlayerInput;
            _input.actions[_PauseInput.action.name].AddListeners(OnInput);
        }

        public void OnWindowHide()
        {
            _input ??= Svc.Input.PlayerInput;
            _input.actions[_PauseInput.action.name].RemoveListeners(OnInput);
        }

        private void OnInput(InputAction.CallbackContext pContext)
        {
            if (!pContext.started) 
                return;
            
            if (Svc.GameStateMachine.CurrentState.StateType == _ActiveState)
                Svc.GameStateMachine.TransitionTo(_GotoState);
        }
    }
}
