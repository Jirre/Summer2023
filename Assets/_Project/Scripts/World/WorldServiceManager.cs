using System;
using JvLib.Data;
using JvLib.Events;
using JvLib.Misc.Generation.Crawler;
using JvLib.Services;
using Project.Data;
using Project.Data.World;
using UnityEngine;
using Random = System.Random;

namespace Project.World
{
    [ServiceInterface(Name = "World")]
    public partial class WorldServiceManager : MonoBehaviour, IService
    {
#if UNITY_EDITOR
        [SerializeField] private bool _DebugBuildOnAwake = true;
        [SerializeField] private GameConfig _DebugBuildConfig;
#endif

        private WorldConfig _worldConfig;
        
        private CrawlerConfig _crawlerConfig;
        private WorldCrawler _crawler;

        private Grid2D<WorldCell> _grid;
        
        public Vector2Int MinBound => _grid?.MinBound ?? Vector2Int.zero;
        public Vector2Int MaxBound => _grid?.MaxBound ?? Vector2Int.zero;
        
        public Random Random { get; private set; }

        private SafeEvent _onBuildFinish = new SafeEvent();
        public event Action OnBuildFinish
        {
            add => _onBuildFinish += value;
            remove => _onBuildFinish -= value;
        }
        
        public bool IsServiceReady { get; private set; }

        private void Awake()
        {
            ServiceLocator.Instance.Register(this);
#if UNITY_EDITOR
            if (_DebugBuildOnAwake)
                SetConfig(_DebugBuildConfig, Mathf.RoundToInt(DateTime.Now.Ticks % int.MaxValue));
#endif
            InitStates();
        }
        
        private void Start()
        {
            IsServiceReady = true;
            ServiceLocator.Instance.ReportInstanceReady(this);
        }
        
        private void Update()
        {
            _stateMachine.Update();
        }

        private void OnDestroy()
        {
            ServiceLocator.Instance.Remove(this);
            _grid?.Dispose();
        }
        
        public void SetConfig(GameConfig pConfig, int pSeed)
        {
            _worldConfig = pConfig.WorldConfig;
            _crawlerConfig = pConfig.CrawlerConfig;

            Random = new Random(pSeed);
        }
    }
}
