using JvLib.StateMachine;

namespace Project.StateMachines.Main
{
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // This code is generated. Your changes will be reverted on regeneration
    // Use GameStateMachine.cs
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    public partial class GameStateMachine : StateMachine<GameStates, GameState, GameStateMachine>
    {
        protected virtual void Awake()
        {
            Initialize();
        }

        private void Initialize()
        {
            AddState<InitState>(GameStates.Init);
            AddState<MenuStateState>(GameStates.MenuState);
            AddState<OptionsState>(GameStates.Options);

            CreateTransition(GameStates.Init, GameStates.MenuState);

            CreateFromAnyTransition(GameStates.Options);
            CreateToAnyTransition(GameStates.Options);

            SetStartState(GameStates.Init);

            EnterStartState();
        }
    }

    public enum GameStates
    {
        Init,
        MenuState,
        Options,
    }
}
