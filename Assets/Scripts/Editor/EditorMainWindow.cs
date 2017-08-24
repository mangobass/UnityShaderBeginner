//=============================================================================
/// Author : Peng Jiawei
/// FileName : EditorMainWindow.cs
//=============================================================================

using Common;
using UnityEngine;

namespace SelfEditorWindow
{
	public class EditorMainWindow : MyEditorWindowBase
	{
		#region Parameters Definition
		protected static MyEditorWindowBase m_Instance = null;
		public static MyEditorWindowBase Instance
		{
			get { return m_Instance ?? new EditorMainWindow(); }
		}

		private int m_SelectIndex = 0;
		#endregion Parameters Definition

		private EditorMainWindow()
		{
			m_Instance = this;
			EditorWindowType = E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_MAIN;
		}

		public override void OnEditorWindowGUI()
		{
			GUILayout.Label("Select function type:");
			m_SelectIndex = GUILayout.SelectionGrid(m_SelectIndex, new[] { "Func1", "Func2", "Func3" }, 1);

			GUILayout.BeginVertical();
			GUILayout.Space(10);
			GUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			if (GUILayout.Button("Go", ConstParams.GetCommonBtnWidth(), ConstParams.GetCommonBtnHeight()))
			{
				GotoFuncWindow();
			}
			GUILayout.EndHorizontal();
			GUILayout.EndVertical();

			// 右下角显示关闭按钮
			GUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			GUILayout.BeginVertical();
			GUILayout.FlexibleSpace();
			if (GUILayout.Button("Close", ConstParams.GetCommonBtnWidth(), ConstParams.GetCommonBtnHeight()))
			{
				CloseWindow();
			}
			GUILayout.EndVertical();
			GUILayout.EndHorizontal();
		}

		private void GotoFuncWindow()
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
	}
}

// EOF