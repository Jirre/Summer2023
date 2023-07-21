using System;
using JvLib.Events;
using UnityEngine;

namespace Project.Gameplay
{
    public partial class GameplayServiceManager // Stats
    {
        [SerializeField] private float _MaxHealth;
        public int MaxHealth => Mathf.CeilToInt(_MaxHealth);
        public int CurrentHealth { get; private set; }

        [SerializeField] private float _MaxMana;
        public float MaxMana => _MaxHealth;
        public float CurrentMana { get; private set; }

        private SafeEvent _onPlayerDeath = new SafeEvent();
        public event Action OnPlayerDeath
        {
            add => _onPlayerDeath += value;
            remove => _onPlayerDeath -= value;
        }

        public void InitStats()
        {
            CurrentHealth = MaxHealth;
            CurrentMana = _MaxMana;
        }
        
        public void SetHealth(int pHealth)
        {
            CurrentHealth = Mathf.Clamp(pHealth, 0, MaxHealth);
            if (CurrentHealth <= 0)
                _onPlayerDeath.Dispatch();
        }
        public void ModifyHealth(int pValue) => SetHealth(CurrentHealth + pValue);

        public void SetMana(int pMana) => CurrentMana = Mathf.Clamp(pMana, 0, MaxMana);
        public bool TryModifyMana(float pValue)
        {
            if (CurrentMana > pValue)
                return false;
            CurrentMana = Mathf.Min(CurrentMana + pValue, MaxMana);
            
            return true;
        }
    }
}
