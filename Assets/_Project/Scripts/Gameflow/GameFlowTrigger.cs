using System.Collections;
using JvLib.Routines;
using JvLib.Services;
using Project.StateMachines.Main;
using UnityEngine;

namespace Project.GameFlow
{
    public class GameFlowTrigger : MonoBehaviour
    {
        private void Awake()
        {
            Routine.Start(LoadDependenciesEnumerator());
        }

        private static IEnumerator LoadDependenciesEnumerator()
        {
            yield return Svc.Ref.GameStateMachine.WaitForInstanceReadyAsync();
            
            // Only go to MenuState if currently in the InitState
            if (Svc.GameStateMachine.CurrentState is not InitState initState) yield break;
            
            // Wait for Completion of InitState
            yield return initState.WaitForReadyAsync();
            Svc.GameStateMachine.TransitionTo(GameStates.MenuState);
        }
    }
}
