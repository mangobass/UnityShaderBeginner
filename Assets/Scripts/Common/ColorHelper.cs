//=============================================================================
/// Author : Peng Jiawei
/// FileName : ColorHelper.cs
//=============================================================================
using UnityEngine;
using System.Collections;

namespace Common
{
	public class ColorHelper
	{
		public static string ColorToHexString(Color color)
		{
			int colorNum = Mathf.FloorToInt(color.r * 255);
			colorNum = colorNum << 8;
			colorNum += Mathf.FloorToInt(color.g * 255);
			colorNum = colorNum << 8;
			colorNum += Mathf.FloorToInt(color.b * 255);
			colorNum = colorNum << 8;
			colorNum += Mathf.FloorToInt(color.a * 255);

			return colorNum.ToString("x8");
		}

		public static string ColorToHexString(Color32 color)
		{
			int colorNum = color.r;
			colorNum = colorNum << 8;
			colorNum += color.g;
			colorNum = colorNum << 8;
			colorNum += color.b;
			colorNum = colorNum << 8;
			colorNum += color.a;

			return colorNum.ToString("x8");
		}
	}
}

// EOF