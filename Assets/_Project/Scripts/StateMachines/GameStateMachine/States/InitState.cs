using System.Collections;
using System.Threading.Tasks;
using JvLib.Routines;
using JvLib.Services;

namespace Project.StateMachines.Main
{
    public partial class InitState : GameState
    {
        private bool _isReady = false;
        
        protected override void OnEnter(GameStates pPrevious)
        {
            base.OnEnter(pPrevious);
            Routine.Start(LoadDependenciesEnumerator());
        }

        private IEnumerator LoadDependenciesEnumerator()
        {
            yield return Svc.Ref.Window.WaitForInstanceReadyAsync();
            yield return new WaitForRealSeconds(0.1f);
            
            yield return Svc.Ref.Audio.WaitForInstanceReadyAsync();
            Svc.Audio.Initialize();

            _isReady = true;
        }
        
        public async Task WaitForReadyAsync()
        {
            while (!_isReady)
                await Task.Yield();
        }
    }
}
