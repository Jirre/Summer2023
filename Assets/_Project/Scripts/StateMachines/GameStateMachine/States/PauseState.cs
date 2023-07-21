using JvLib.Services;
using JvLib.Windows;

namespace Project.StateMachines.Main
{
    public partial class PauseState : GameState
    {
        protected override void OnEnter(GameStates pPrevious)
        {
            base.OnEnter(pPrevious);
            Svc.Window.Open(WindowID.PauseMenu);
        }
    }
}
