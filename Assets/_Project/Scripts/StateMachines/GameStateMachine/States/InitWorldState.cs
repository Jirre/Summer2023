using System;
using System.Collections;
using JvLib.Routines;
using JvLib.Services;
using Project.Data;
using UnityEngine;

namespace Project.StateMachines.Main
{
    public partial class InitWorldState : GameState
    {
        protected override void OnEnter(GameStates pPrevious)
        {
            base.OnEnter(pPrevious);
            
            Routine.Start(InitializationRoutine());
        }

        private static IEnumerator InitializationRoutine()
        {
            Svc.World.SetConfig(GameConfig.Default, Mathf.RoundToInt(DateTime.Now.Ticks % int.MaxValue));
            
            Svc.World.Generate();
            yield return Svc.World.WaitForCompleteBuild();
            
            Svc.Gameplay.SpawnPlayer(Vector2.zero);
            Svc.GameStateMachine.TransitionTo(GameStates.Gameplay);
        }
    }
}
