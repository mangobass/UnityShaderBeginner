//=============================================================================
/// Desc: Editor window base class
/// Auth: Peng Jiawei
//=============================================================================

using UnityEngine;

namespace SelfEditorWindow
{
	public abstract class MyEditorWindowBase
	{
		public E_EditorWindowType EditorWindowType { get; set; }

		protected void BackWindow()
		{
			EditorWindowManager.Instance.CurrentWindowType = E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_MAIN;
		}

		/// <summary>
		/// 点击"Close"按钮的回调
		/// </summary>
		protected void CloseWindow()
		{
			EditorWindowManager.Instance.MainPanel.Close();
		}

		#region abstract functions
		/// <summary>
		/// GUI draw function.
		/// </summary>
		public abstract void OnEditorWindowGUI();
		#endregion abstract functions
	}
}

// EOF