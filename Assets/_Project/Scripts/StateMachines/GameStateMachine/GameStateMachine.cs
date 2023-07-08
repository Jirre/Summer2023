using JvLib.Services;

namespace Project.StateMachines.Main
{
    [ServiceInterface]
    public partial class GameStateMachine : IService
    {
        public bool IsServiceReady { get; private set; }

        private void Start()
        {
            ServiceLocator.Instance.Register(this);
            IsServiceReady = true;
            ServiceLocator.Instance.ReportInstanceReady(this);
        }

        private void OnDestroy()
        {
            ServiceLocator.Instance.Remove(this);
        }
    }
}
