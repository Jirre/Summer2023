using UnityEngine;

namespace Project.Gameplay
{
    public partial class CameraController // Movement
    {
        private Vector3 _cachedTarget;
        [SerializeField, Range(0, 3)] private float _offsetMultiplier;
        [SerializeField] private float _movementSpeed;

        private void MovementOnPlayerChanged()
        {
            if (_player == null)
                return;
            
            transform.position = CalculateTarget();
        }
        
        private void MovementUpdate()
        {
            if (_player == null)
                return;

            CalculateTarget();

            transform.position = Vector3.Lerp(transform.position, _cachedTarget, _movementSpeed * Time.deltaTime);
        }

        private Vector3 CalculateTarget()
        {
            Vector3 playerPos = _player.transform.position;
            
            Vector2 position = new Vector2(
                Mathf.Round(playerPos.x / Constants.CELL_SIZE_XZ.x),
                Mathf.Round(playerPos.z / Constants.CELL_SIZE_XZ.z));

            Vector2 offSet = new Vector2(
                playerPos.x / Constants.CELL_SIZE_XZ.x,
                playerPos.z / Constants.CELL_SIZE_XZ.z);

            offSet -= position;
            offSet *= _offsetMultiplier * 0.5f;

            _cachedTarget = new Vector3(
                (position.x + offSet.x) * Constants.CELL_SIZE_XZ.x,
                0,
                (position.y + offSet.y) * Constants.CELL_SIZE_XZ.z);

            return _cachedTarget;
        }
    }
}
