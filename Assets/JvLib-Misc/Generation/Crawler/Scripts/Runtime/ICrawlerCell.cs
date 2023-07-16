using System;
using UnityEngine;

namespace JvLib.Misc.Generation.Crawler
{
    /// <summary>
    /// An abstract base-class used to store the data of a Cell created by a <see cref="Crawler"/>
    /// </summary>
    public interface ICrawlerCell : IDisposable
    {
        /// <summary>
        /// The position of the cell on the Grid as defined in the <see cref="CrawlerManager{TCell}"/>
        /// </summary>
        public Vector2Int Position { get; set; }
    }
}
