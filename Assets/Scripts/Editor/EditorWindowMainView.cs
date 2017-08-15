//=============================================================================
/// Author : Peng Jiawei
//=============================================================================

using UnityEditor;
using UnityEngine;

namespace SelfEditorWindow
{
	public class EditorWindowMainView : EditorWindow
	{
		private MyEditorWindowBase m_CurrentWindow = null;

		private void Awake()
		{
			EditorWindowManager.Instance.CurrentWindowType = E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_MAIN;
		}

		private void OnGUI()
		{
			switch (EditorWindowManager.Instance.CurrentWindowType)
			{
				case E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_1:
					m_CurrentWindow = EditorFuncWindow.Instance;
					break;
				case E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_2:
					break;
				case E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_3:
					break;
				case E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_MAIN:
					m_CurrentWindow = EditorMainWindow.Instance;
					break;
			}

			m_CurrentWindow.OnEditorWindowGUI();
		}


	}
}









// EOF