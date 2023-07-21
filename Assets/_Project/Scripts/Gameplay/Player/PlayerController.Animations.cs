using JvLib.Animators;
using Sirenix.OdinInspector;
using UnityEngine;

namespace Project.Gameplay
{
    public partial class PlayerController // Animations
    {
        [SerializeField, AllowFloats, BoxGroup("Animators")] private AnimatorParameter _AnimatorSpeedParam;
        [SerializeField, AllowTriggers, BoxGroup("Animators")] private AnimatorParameter _AnimatorAttackParam;

        private void AnimatorSpeedUpdate()
        {
            _AnimatorSpeedParam.SetFloat(_cachedMovementInput.magnitude);
        }

        private void TriggerAnimatorAttack()
        {
            _AnimatorAttackParam.Trigger();
        }
    }
}
