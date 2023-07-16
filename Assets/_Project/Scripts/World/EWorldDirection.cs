using System;

namespace Project.World
{
    [Flags]
    public enum EWorldDirection
    {
        Right = 1 << 1,
        Up = 1 << 2,
        Left = 1 << 3,
        Down = 1 << 4
    }
}
