using JvLib.Services;
using JvLib.Windows;

namespace Project.StateMachines.Main
{
    public partial class MenuStateState : GameState
    {
        protected override void OnEnter(GameStates pPrevious)
        {
            base.OnEnter(pPrevious);
            Svc.Window.CloseAll();
            Svc.Window.Open(WindowID.MainMenu);
        }
    }
}
