﻿namespace Project.StateMachines.Main
{
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // This code is generated. Your changes will be reverted on regeneration
    // Use InitGameState.cs
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    public partial class InitGameState
    {
        protected void TransitionToInitWorldState()
        {
            StateMachine.TransitionTo(GameStates.InitWorld);
        }
    }
}
