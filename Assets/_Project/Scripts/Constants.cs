using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class Constants
{
    public const float ROOM_WIDTH = 20f;
    public const float ROOM_HEIGHT = 20f;
    public const float ROOM_BORDER_WIDTH = 5f;

    public static readonly Vector3 ROOM_SIZE_XZ = new Vector3(ROOM_WIDTH, 0, ROOM_HEIGHT);
    public static readonly Vector3 ROOM_SIZE_XY = new Vector3(ROOM_WIDTH, ROOM_HEIGHT);

    public static readonly Vector3 CELL_SIZE_XZ =
        new Vector3(ROOM_WIDTH + ROOM_BORDER_WIDTH * 2f, 0, ROOM_HEIGHT + ROOM_BORDER_WIDTH * 2f);
    public static readonly Vector3 CELL_SIZE_XY =
        new Vector3(ROOM_WIDTH + ROOM_BORDER_WIDTH * 2f, ROOM_HEIGHT + ROOM_BORDER_WIDTH * 2f);
}
