//=============================================================================
/// Auth: Peng Jiawei
//=============================================================================

using UnityEngine;

namespace Common.ConstParams
{
	public class ConstParams
	{
		public static float CommonButtonWidth = 50;
		public static float CommonButtonHeight = 25;

		public static GUILayoutOption GetCommonBtnWidth()
		{
			return GUILayout.Width(CommonButtonWidth);
		}

		public static GUILayoutOption GetCommonBtnHeight()
		{
			return GUILayout.Height(CommonButtonHeight);
		}
	}
}

// EOF