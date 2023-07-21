using JvLib.Windows;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Project.UI.Windows
{
    public class SelectOnFocus : MonoBehaviour, IOnWindowFocus, IOnWindowUnfocus, IOnWindowShown
    {
        [SerializeField] private Selectable _DefaultSelection;
        [SerializeField] private bool _DefaultToFirstOnShown;
        [SerializeField] private bool _DefaultToFirstOnFocus;

        private Selectable _lastSelection;
        
        public void OnWindowFocus()
        {
            EventSystem.current.SetSelectedGameObject(_lastSelection == null || _DefaultToFirstOnFocus ? 
                _DefaultSelection.gameObject : 
                _lastSelection.gameObject);
        }

        public void OnWindowUnfocus()
        {
            _lastSelection = EventSystem.current.currentSelectedGameObject.GetComponent<Selectable>();
        }

        public void OnWindowShown()
        {
            if (_DefaultToFirstOnShown)
                SetToDefault();
        }

        public void SetToDefault()
        {
            EventSystem.current.SetSelectedGameObject(_DefaultSelection.gameObject);
        }
    }
}
