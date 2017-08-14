//=============================================================================
/// Author : Peng Jiawei
//=============================================================================

using UnityEditor;
using UnityEngine;

namespace SelfEditorWindow {
	public class EditorMainWindow : EditorWindow
	{
		enum E_EditorFuncType
		{
			ENUM_Editor_Func_Type_1 = 0,
			ENUM_Editor_Func_Type_2,
			ENUM_Editor_Func_Type_3,

			ENUM_Editor_Func_Type_max
		}

		private int m_SelectIndex = 0;

		private void OnGUI()
		{
			OnMainEditorWindowGUI();
		}

		private void OnMainEditorWindowGUI()
		{
			GUILayout.Label("Select function type:");
			m_SelectIndex = GUILayout.SelectionGrid(0, new[] { "Func1", "Func2", "Func3" }, 1);

			GUILayout.BeginVertical();
			GUILayout.Space(10);
			GUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			if (GUILayout.Button("Go", GUILayout.Width(50), GUILayout.Height(25)))
			{
				GotoFuncWindow();
			}
			GUILayout.EndHorizontal();
			GUILayout.EndVertical();

			GUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			GUILayout.BeginVertical();
			GUILayout.FlexibleSpace();

			if (GUILayout.Button("Close", GUILayout.Width(50), GUILayout.Height(25)))
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
				case (int)E_EditorFuncType.ENUM_Editor_Func_Type_1:
					break;
				case (int)E_EditorFuncType.ENUM_Editor_Func_Type_2:
					break;
				case (int)E_EditorFuncType.ENUM_Editor_Func_Type_3:
					break;
				default:
					Debug.LogWarning("=== Select index is not matching. ===");
					return;
			}
			Debug.Log("=== Select index is : " + m_SelectIndex + "  ===");
		}


		/// <summary>
		/// 点击"Close"按钮的回调
		/// </summary>
		private void CloseWindow()
		{
			Close();
		}
	}
}









// EOF