using JvLib.Data;

namespace Project.Data
{
    public partial class GameConfig
    {
        private static Project.Data.GameConfigs values;
        private static Project.Data.GameConfig _default;

        public static Project.Data.GameConfigs Values
        {
            get
            {
                if (values == null)
                    values = (Project.Data.GameConfigs)DataRegistry.GetList("c96eceaa2ce0c6f40a7d6fac48ebe546");
                return values;
            }
        }

        public static Project.Data.GameConfig Default
        {
            get
            {
                if (_default == null && Values != null)
                    _default = (Project.Data.GameConfig)Values.GetEntry("e4b2c8b99fb6aef40bcb95c0e78ec9a2");
                return _default;
            }
        }

    }
}

