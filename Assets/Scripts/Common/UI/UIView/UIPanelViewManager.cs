//=============================================================================
/// Author : Peng Jiawei
/// FileName : UIPanelViewManager.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Common;

namespace Common.UI.UIView
{
	public class UIPanelViewManager
	{
		#region Parameter Definition
		private static UIPanelViewManager m_Instance;

		public static UIPanelViewManager Instance
		{
			get { return m_Instance ?? new UIPanelViewManager(); }
		}

		private Transform m_UIMainCanvasTrans;

		private Dictionary<string, GameObject> m_UIPrefabDic = new Dictionary<string, GameObject>();
		#endregion Parameter Definition

		private UIPanelViewManager()
		{
			m_Instance = this;
			DebugLogCtrl.LogWithColor("=== UIPanelViewManager is initialized!!! ===", Color.green);

			m_UIMainCanvasTrans = GameObject.FindGameObjectWithTag("UIMainCanvas").transform;
		}

		public bool OpenPanelView(UIPanelViewOption option)
		{
			DebugLogCtrl.Log("OpenPanelView");
			//if () return false;

			//if (m_UIPrefabDic.ContainsKey())

			return true;
		}
	}
}

// EOF