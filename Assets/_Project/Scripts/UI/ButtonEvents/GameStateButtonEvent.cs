using JvLib.Services;
using JvLib.UI.Events;
using Project.StateMachines.Main;
using UnityEngine;

namespace Project.UI.Events
{
    public class GameStateButtonEvent : AUIButtonEvent
    {
        [SerializeField] private GameStates _State;
    
        public override void OnClick() => Svc.GameStateMachine.TransitionTo(_State);
    }
}
