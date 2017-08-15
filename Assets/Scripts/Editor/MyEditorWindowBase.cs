//=============================================================================
/// Author : Peng Jiawei
//=============================================================================

using UnityEditor;
using UnityEngine;

namespace SelfEditorWindow
{
	public abstract class MyEditorWindowBase
	{
		public E_EditorWindowType EditorWindowType { get; set; }

		protected int m_SelectIndex = 0;
		protected void GotoFuncWindow()
		{
			switch (m_SelectIndex)
			{
				case (int)E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_1:
					EditorWindowManager.Instance.CurrentWindowType = E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_1;
					break;
				case (int)E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_2:
					break;
				case (int)E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_3:
					break;
				default:
					Debug.LogWarning("=== Select index is not matching. ===");
					return;
			}
			Debug.Log("=== Select index is : " + m_SelectIndex + "  ===");
		}

		protected void BackWindow()
		{
			EditorWindowManager.Instance.CurrentWindowType = E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_MAIN;
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