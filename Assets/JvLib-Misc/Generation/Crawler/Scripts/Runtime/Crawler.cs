using UnityEngine;

namespace JvLib.Misc.Generation.Crawler
{
    using EDirection = CrawlerConfig.EDirection;
    
    /// <summary>
    /// Crawler class that functions as the entity spawning new <see cref="ICrawlerCell"/> instances
    /// </summary>
    public class Crawler
    {
        /// <summary>
        /// The current position of the crawler on the Grid as defined in the <see cref="CrawlerManager{TCell}"/>
        /// </summary>
        public Vector2Int Position { get; private set; }
        private float _direction;

        /// <summary>
        /// Constructor of the Crawler
        /// </summary>
        /// <param name="pPosition">Starting position on the Grid as defined in the <see cref="CrawlerManager{TCell}"/></param>
        /// <param name="pStartDirection">Starting direction of the crawler (Must be a cardinal direction))</param>
        public Crawler(Vector2Int pPosition, float pStartDirection)
        {
            Position = pPosition;
            _direction = pStartDirection;
        }

        /// <summary>
        /// Moves the Crawler to a new position on the Grid as defined in the <see cref="CrawlerManager{TCell}"/>
        /// based on the <paramref name="pDirection"/> defined as a parameter.
        /// </summary>
        /// <param name="pDirection">Changes the rotation relative to the current rotation in this direction</param>
        internal void Move(EDirection pDirection)
        {
            _direction = pDirection switch
            {
                EDirection.Right => (_direction + 90f) % 360f,
                EDirection.Reverse => (_direction + 180f) % 360f,
                EDirection.Left => (_direction + 270f) % 360f,
                _ => _direction
            };

            Position += new Vector2Int(
                Mathf.RoundToInt(Mathf.Cos(_direction * Mathf.Deg2Rad)),
                Mathf.RoundToInt(Mathf.Sin(_direction * Mathf.Deg2Rad)));
        }
    }
}
