//=============================================================================
/// Desc: All editor windows' controller
/// Auth: Peng Jiawei
//=============================================================================

using Common.ConstParams;
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

			if (m_CurrentWindow == null)
			{
				// œ‘ æπÿ±’∞¥≈•
				GUILayout.BeginHorizontal();
				GUILayout.FlexibleSpace();
				GUILayout.BeginVertical();
				GUILayout.FlexibleSpace();
				if (GUILayout.Button("Close", ConstParams.GetCommonBtnWidth(), ConstParams.GetCommonBtnHeight()))
				{
					Close();
				}
				GUILayout.EndVertical();
				GUILayout.EndHorizontal();
				return;
			}

			m_CurrentWindow.OnEditorWindowGUI();
		}
	}
}

// EOF