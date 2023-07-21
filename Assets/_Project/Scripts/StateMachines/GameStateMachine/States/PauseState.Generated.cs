namespace Project.StateMachines.Main
{
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // This code is generated. Your changes will be reverted on regeneration
    // Use PauseState.cs
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    public partial class PauseState
    {
        protected void TransitionToGameplayState()
        {
            StateMachine.TransitionTo(GameStates.Gameplay);
        }
        protected void TransitionToInitGameState()
        {
            StateMachine.TransitionTo(GameStates.InitGame);
        }
        protected void TransitionToGameOverState()
        {
            StateMachine.TransitionTo(GameStates.GameOver);
        }
    }
}
