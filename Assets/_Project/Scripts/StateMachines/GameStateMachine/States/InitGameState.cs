using JvLib.Services;
using JvLib.Windows;

namespace Project.StateMachines.Main
{
    public partial class InitGameState : GameState
    {
        protected override void OnEnter(GameStates pPrevious)
        {
            base.OnEnter(pPrevious);
            Svc.Gameplay.InitStats();
            Svc.Window.Close(WindowID.MainMenu);
            Svc.Window.Close(WindowID.PauseMenu);
            Svc.Window.Open(WindowID.Gameplay);
            
            Svc.GameStateMachine.TransitionTo(GameStates.InitWorld);
        }
    }
}
