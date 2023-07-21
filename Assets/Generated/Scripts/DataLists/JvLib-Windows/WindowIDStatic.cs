using JvLib.Data;

namespace JvLib.Windows
{
    public partial class WindowID
    {
        private static JvLib.Windows.WindowIDs values;
        private static JvLib.Windows.WindowID mainMenu;

        public static JvLib.Windows.WindowIDs Values
        {
            get
            {
                if (values == null)
                    values = (JvLib.Windows.WindowIDs)DataRegistry.GetList("36ec9665ec7bc904186f659b23774708");
                return values;
            }
        }

        public static JvLib.Windows.WindowID MainMenu
        {
            get
            {
                if (mainMenu == null && Values != null)
                    mainMenu = (JvLib.Windows.WindowID)Values.GetEntry("b20ce22edbb1bf341852adad3367db65");
                return mainMenu;
            }
        }

    }
}

