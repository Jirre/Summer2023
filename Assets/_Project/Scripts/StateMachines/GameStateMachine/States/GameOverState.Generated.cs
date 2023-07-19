namespace Project.StateMachines.Main
{
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // This code is generated. Your changes will be reverted on regeneration
    // Use GameOverState.cs
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    public partial class GameOverState
    {
        protected void TransitionToInitGameState()
        {
            StateMachine.TransitionTo(GameStates.InitGame);
        }
        protected void TransitionToMenuStateState()
        {
            StateMachine.TransitionTo(GameStates.MenuState);
        }
    }
}
