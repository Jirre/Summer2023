using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Project.Gameplay
{
    public partial class CameraController // SeeThrough
    {
        private static readonly int POS_ID = Shader.PropertyToID("_Position");
        private static readonly int SIZE_ID = Shader.PropertyToID("_Size");
        private static readonly int OPACITY_ID = Shader.PropertyToID("_Opacity");

        [SerializeField] private Material[] _SeeThroughMaterials;
        [SerializeField] private LayerMask _SeeThroughMask;
        [SerializeField] private float _SeeThroughFadeSpeed = 5;
        private float _SeeThroughAlpha = 0f;

        private void UpdateSeeThrough()
        {
            if (_player == null)
            {
                SetSeeThroughValue(SIZE_ID, 0);
                return;
            }
            Vector3 direction = _player.transform.position - _camera.transform.position ;
            Ray ray = new Ray(_camera.transform.position, direction.normalized);

            if (Physics.Raycast(ray, 3000, _SeeThroughMask))
                _SeeThroughAlpha += Time.deltaTime * _SeeThroughFadeSpeed;
            else _SeeThroughAlpha -= Time.deltaTime * _SeeThroughFadeSpeed;

            _SeeThroughAlpha = Mathf.Clamp01(_SeeThroughAlpha);
            
            SetSeeThroughValue(SIZE_ID, _SeeThroughAlpha);
            SetSeeThroughValue(OPACITY_ID, _SeeThroughAlpha);

            Vector2 viewPosition = _camera.WorldToViewportPoint(_player.transform.position);
            SetSeeThroughValue(POS_ID, viewPosition);
        }

        private void SetSeeThroughValue(int pID, float pValue)
        {
            foreach (Material material in _SeeThroughMaterials)
                material.SetFloat(pID, pValue);
        }
        
        private void SetSeeThroughValue(int pID, Vector2 pValue)
        {
            foreach (Material material in _SeeThroughMaterials)
                material.SetVector(pID, pValue);
        }
    }
}
