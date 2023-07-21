using JvLib.Services;
using JvLib.Windows;

namespace Project.StateMachines.Main
{
    public partial class GameplayState : GameState
    {
        protected override void OnEnter(GameStates pPrevious)
        {
            base.OnEnter(pPrevious);
            Svc.Window.Close(WindowID.PauseMenu);
        }
    }
}
