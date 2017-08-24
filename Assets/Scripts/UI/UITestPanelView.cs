//=============================================================================
/// Author : Peng Jiawei
/// FileName : UITestPanelView.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using Common;
using Common.UI.UIView;

namespace UI.UITestPanelView
{
	public class UITestPanelView : UIPanelViewBase
	{
		private void Awake()
		{
			DebugLogCtrl.LogWithColor32("Text color", new Color32(255, 128, 128, 255));
			base.Awake();
		}
		

	}
}

// EOF