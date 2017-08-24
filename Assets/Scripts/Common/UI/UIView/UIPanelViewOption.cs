//=============================================================================
/// Author : Peng Jiawei
/// FileName : UIPanelViewOption.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using Common;

namespace Common.UI.UIView
{
	public struct UIPanelViewOption
	{
		public string UIViewName;
		public string UIPath;

		public UIPanelViewOption(string name, string path)
		{
			UIViewName = name;
			UIPath = path;
		}
	}

	public struct UIPanelViewOptionInfo
	{
		public static UIPanelViewOption TestView = new UIPanelViewOption("TestView", ConstParams.UIPrefabPath+"UITestPanel.prefab");
	}
}

// EOF