using JvLib.Windows;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Project.UI.Windows
{
    public class SelectOnFocus : MonoBehaviour, IOnWindowFocus, IOnWindowUnfocus, IOnWindowShown
    {
        [SerializeField] private Selectable _FirstSelection;
        [SerializeField] private bool _DefaultToFirstOnShown;
        [SerializeField] private bool _AlwaysDefaultToFirst;

        private Selectable _lastSelection;
        
        public void OnWindowFocus()
        {
            EventSystem.current.SetSelectedGameObject(_lastSelection == null || _AlwaysDefaultToFirst ? 
                _FirstSelection.gameObject : 
                _lastSelection.gameObject);
        }

        public void OnWindowUnfocus()
        {
            _lastSelection = EventSystem.current.currentSelectedGameObject.GetComponent<Selectable>();
        }

        public void OnWindowShown()
        {
            if (_DefaultToFirstOnShown)
                EventSystem.current.SetSelectedGameObject(_FirstSelection.gameObject);
        }
    }
}
