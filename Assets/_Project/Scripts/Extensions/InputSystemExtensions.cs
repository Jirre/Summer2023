#if ENABLE_INPUT_SYSTEM
namespace UnityEngine.InputSystem
{
    public static class InputSystemExtensions
    {
        public static void AddListeners(this InputAction action, System.Action<InputAction.CallbackContext> contextEvent)
        {
            action.performed += contextEvent;
            action.canceled += contextEvent;
            action.started += contextEvent;
        }
        
        public static void RemoveListeners(this InputAction action, System.Action<InputAction.CallbackContext> contextEvent)
        {
            action.performed -= contextEvent;
            action.canceled -= contextEvent;
            action.started -= contextEvent;
        }
    }
}
#endif