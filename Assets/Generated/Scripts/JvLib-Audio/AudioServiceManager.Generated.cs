namespace JvLib.Audio
{
    public partial class AudioServiceManager // Generated
    {
        public JvLib.Audio.MasterMixer Master { get; private set; }
        public JvLib.Audio.LoopMixer Ambience { get; private set; }
        public JvLib.Audio.LoopMixer Music { get; private set; }
        public JvLib.Audio.ParallelMixer Sfx { get; private set; }
        public JvLib.Audio.SimpleMixer Notifications { get; private set; }
        public JvLib.Audio.ParallelMixer UI { get; private set; }

        protected override void RegisterMixers()
        {
            Master = new JvLib.Audio.MasterMixer();
            Master.Register(transform, BootstrapAudioSettings.Instance.Mixers[0]);
            Ambience = new JvLib.Audio.LoopMixer();
            Ambience.Register(transform, BootstrapAudioSettings.Instance.Mixers[1]);
            Music = new JvLib.Audio.LoopMixer();
            Music.Register(transform, BootstrapAudioSettings.Instance.Mixers[2]);
            Sfx = new JvLib.Audio.ParallelMixer();
            Sfx.Register(transform, BootstrapAudioSettings.Instance.Mixers[3]);
            Notifications = new JvLib.Audio.SimpleMixer();
            Notifications.Register(transform, BootstrapAudioSettings.Instance.Mixers[4]);
            UI = new JvLib.Audio.ParallelMixer();
            UI.Register(transform, BootstrapAudioSettings.Instance.Mixers[5]);
        }
        protected override void InitializeMixers()
        {
            Master.Initialize(BootstrapAudioSettings.Instance.Mixers[0].DefaultVolume);
            Ambience.Initialize(BootstrapAudioSettings.Instance.Mixers[1].DefaultVolume);
            Music.Initialize(BootstrapAudioSettings.Instance.Mixers[2].DefaultVolume);
            Sfx.Initialize(BootstrapAudioSettings.Instance.Mixers[3].DefaultVolume);
            Notifications.Initialize(BootstrapAudioSettings.Instance.Mixers[4].DefaultVolume);
            UI.Initialize(BootstrapAudioSettings.Instance.Mixers[5].DefaultVolume);
        }
    }
}

