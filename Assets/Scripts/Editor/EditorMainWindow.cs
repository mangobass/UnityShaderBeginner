//=============================================================================
/// Author : Peng Jiawei
/// FileName : EditorMainWindow.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using SelfEditorWindow;

namespace SelfEditorWindow
{
	public class EditorMainWindow : MyEditorWindowBase
	{
		protected static MyEditorWindowBase m_Instance = null;
		public static MyEditorWindowBase Instance
		{
			get { return m_Instance ?? new EditorMainWindow(); }
		}

		public EditorMainWindow()
		{
			m_Instance = this;
		}

		public override void OnEditorWindowGUI()
		{
			GUILayout.Label("Select function type:");
			m_SelectIndex = GUILayout.SelectionGrid(m_SelectIndex, new[] { "Func1", "Func2", "Func3" }, 1);

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


		/// <summary>
		/// 点击"Close"按钮的回调
		/// </summary>
		private void CloseWindow()
		{
			EditorWindowManager.Instance.MainPanel.Close();
		}

	}
}

// EOF