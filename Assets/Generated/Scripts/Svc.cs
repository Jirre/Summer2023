﻿using UnityEngine;

namespace JvLib.Services
{
    public static class Svc
    {
        public static class Ref
        {
            public static ServiceReference<JvLib.Audio.AudioServiceManager> Audio
                 = new ServiceReference<JvLib.Audio.AudioServiceManager>();
            public static ServiceReference<JvLib.Pooling.Objects.ObjectPoolServiceManager> ObjectPools
                 = new ServiceReference<JvLib.Pooling.Objects.ObjectPoolServiceManager>();
            public static ServiceReference<JvLib.Pooling.Particles.ParticlePoolServiceManager> ParticlePools
                 = new ServiceReference<JvLib.Pooling.Particles.ParticlePoolServiceManager>();
            public static ServiceReference<JvLib.Scenes.SceneServiceManager> Scenes
                 = new ServiceReference<JvLib.Scenes.SceneServiceManager>();
            public static ServiceReference<JvLib.Windows.WindowService> Window
                 = new ServiceReference<JvLib.Windows.WindowService>();
        }

        public static JvLib.Audio.AudioServiceManager Audio
        {
            get
            {
                return Ref.Audio.Reference;
            }
        }
        public static JvLib.Pooling.Objects.ObjectPoolServiceManager ObjectPools
        {
            get
            {
                return Ref.ObjectPools.Reference;
            }
        }
        public static JvLib.Pooling.Particles.ParticlePoolServiceManager ParticlePools
        {
            get
            {
                return Ref.ParticlePools.Reference;
            }
        }
        public static JvLib.Scenes.SceneServiceManager Scenes
        {
            get
            {
                return Ref.Scenes.Reference;
            }
        }
        public static JvLib.Windows.WindowService Window
        {
            get
            {
                return Ref.Window.Reference;
            }
        }

        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterAssembliesLoaded)]
        private static void ClearCache()
        {
            Ref.Audio = new ServiceReference<JvLib.Audio.AudioServiceManager>();
            Ref.ObjectPools = new ServiceReference<JvLib.Pooling.Objects.ObjectPoolServiceManager>();
            Ref.ParticlePools = new ServiceReference<JvLib.Pooling.Particles.ParticlePoolServiceManager>();
            Ref.Scenes = new ServiceReference<JvLib.Scenes.SceneServiceManager>();
            Ref.Window = new ServiceReference<JvLib.Windows.WindowService>();
        }
    }
}

