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
            AddState<InitGameState>(GameStates.InitGame);
            AddState<InitWorldState>(GameStates.InitWorld);
            AddState<GameplayState>(GameStates.Gameplay);
            AddState<FInishWorldState>(GameStates.FInishWorld);
            AddState<GameOverState>(GameStates.GameOver);
            AddState<PauseState>(GameStates.Pause);

            CreateTransition(GameStates.Init, GameStates.MenuState);
            CreateTransition(GameStates.MenuState, GameStates.InitGame);
            CreateTransition(GameStates.FInishWorld, GameStates.InitWorld);
            CreateTransition(GameStates.InitWorld, GameStates.Gameplay);
            CreateTransition(GameStates.Gameplay, GameStates.FInishWorld);
            CreateTransition(GameStates.InitGame, GameStates.InitWorld);
            CreateTransition(GameStates.Gameplay, GameStates.Pause);
            CreateTransition(GameStates.Gameplay, GameStates.GameOver);
            CreateTransition(GameStates.Pause, GameStates.Gameplay);
            CreateTransition(GameStates.GameOver, GameStates.InitGame);
            CreateTransition(GameStates.Pause, GameStates.InitGame);
            CreateTransition(GameStates.GameOver, GameStates.MenuState);
            CreateTransition(GameStates.Pause, GameStates.GameOver);

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
        InitGame,
        InitWorld,
        Gameplay,
        FInishWorld,
        GameOver,
        Pause,
    }
}
