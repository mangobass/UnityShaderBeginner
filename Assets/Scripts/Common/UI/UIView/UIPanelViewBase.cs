//=============================================================================
/// Author : Peng Jiawei
/// FileName : UIPanelViewBase.cs
//=============================================================================
using UnityEngine;
using System.Collections;

namespace Common.UI.UIView
{
	public class UIPanelViewBase : MonoBehaviour
	{
		#region Parameter Definition
		protected GameObject m_GameObject;
		#endregion Parameter Definition

		protected void Awake()
		{
			m_GameObject = gameObject;
		}

		public virtual void Show() { }
		public virtual void Hide() { }
	}
}

// EOF