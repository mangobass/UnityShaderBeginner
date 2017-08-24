using UnityEngine;
using System.Collections;
using Common.UI.UIView;

namespace GameMain
{
	public class GameMain : MonoBehaviour
	{
		#region Parameter Definition

		public UIPanelViewManager UIPanelViewMgr { set; get; }

		#endregion Parameter Definition

		private void Awake()
		{
			UIPanelViewMgr = UIPanelViewManager.Instance;
			UIPanelViewManager.Instance.OpenPanelView(UIPanelViewOptionInfo.TestView);
		}
	}

}
// EOF