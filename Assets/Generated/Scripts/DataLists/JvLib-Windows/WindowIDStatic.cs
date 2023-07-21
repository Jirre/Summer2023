using JvLib.Data;

namespace JvLib.Windows
{
    public partial class WindowID
    {
        private static JvLib.Windows.WindowIDs values;
        private static JvLib.Windows.WindowID mainMenu;
        private static JvLib.Windows.WindowID pauseMenu;
        private static JvLib.Windows.WindowID gameplay;

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

        public static JvLib.Windows.WindowID PauseMenu
        {
            get
            {
                if (pauseMenu == null && Values != null)
                    pauseMenu = (JvLib.Windows.WindowID)Values.GetEntry("f7cd80a62fffd364ba2e8a0eef03a17a");
                return pauseMenu;
            }
        }

        public static JvLib.Windows.WindowID Gameplay
        {
            get
            {
                if (gameplay == null && Values != null)
                    gameplay = (JvLib.Windows.WindowID)Values.GetEntry("dcb717a6348d17949a2113df07967b2e");
                return gameplay;
            }
        }

    }
}

