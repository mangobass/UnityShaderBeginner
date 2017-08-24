//=============================================================================
/// DESC: If defined DEBUG_OFF symbol, no log display.
/// AUTH: PJW
//=============================================================================
using UnityEngine;

namespace Common
{
	public sealed class DebugLogCtrl
	{
		public static void Log(string content)
		{
#if DEBUG_OFF
#else
			Debug.Log(content);
#endif
		}

		public static void LogWarning(string content)
		{
#if DEBUG_OFF
#else
			Debug.LogWarning(content);
#endif
		}

		public static void LogError(string content)
		{
#if DEBUG_OFF
#else
			Debug.LogError(content);
#endif
		}

		public static void LogFormat(string format, params object[] args)
		{
#if DEBUG_OFF
#else
			Debug.LogFormat(format, args);
#endif
		}

		public static void LogWarningFormat(string format, params object[] args)
		{
#if DEBUG_OFF
#else
			Debug.LogWarningFormat(format, args);
#endif
		}

		public static void LogErrorFormat(string format, params object[] args)
		{
#if DEBUG_OFF
#else
			Debug.LogErrorFormat(format, args);
#endif
		}

		public static void LogWithColor(string content, Color color)
		{
#if DEBUG_OFF
#else
			string colorContent = "<color=#" + ColorHelper.ColorToHexString(color) + ">" + content + "</color>";
			Debug.Log(colorContent);
#endif
		}

		public static void LogWithColor32(string content, Color32 color)
		{
#if DEBUG_OFF
#else
			string colorContent = "<color=#" + ColorHelper.ColorToHexString(color) + ">" + content + "</color>";
			Debug.Log(colorContent);
#endif
		}
	}
}

// EOF