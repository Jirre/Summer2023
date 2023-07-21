using System;
using JvLib.Audio;
using JvLib.Audio.Data;
using JvLib.Services;
using JvLib.UI;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Project.UI.Audio
{
    [RequireComponent(typeof(AUISelectable))]
    public class SfxSelectableEffect : UIBehaviour
    {
        [SerializeField] private ParallelAudioCollection _OnTriggerSound;

        private AudioChannel _channel;
        private bool _isPlaying;
        
        protected override void Awake()
        {
            base.Awake();
            AUISelectable selectable = GetComponentInChildren<AUISelectable>();
            switch (selectable)
            {
                case UIButton button:
                    button.OnClick.AddListener(Trigger);
                    break;
                case UIDropdown dropdown:
                    dropdown.OnValueChanged.AddListener(v => Trigger());
                    break;
                case UISlider slider:
                    slider.OnValueChanged.AddListener(v => Trigger());
                    break;
                case UIToggle toggle:
                    toggle._OnValueChanged.AddListener(v =>
                    {
                        if (v) Trigger();
                    });
                    break;
                
                default:
                    throw new Exception("Selectable is not yet supported by SfxSelectableEffect Component");
            }
        }

        protected override void OnDisable()
        {
            base.OnEnable();
            _isPlaying = false;
        }

        private void Trigger()
        {
            Svc.Audio.UI.Play(_OnTriggerSound);
        }
    }
}
