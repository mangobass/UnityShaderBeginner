//=============================================================================
/// Author : Peng Jiawei
/// FileName : EditorFuncWindow.cs
//=============================================================================
using UnityEngine;
using System.Collections;

namespace SelfEditorWindow

{
	public class EditorFuncWindow : MyEditorWindowBase
	{
		protected static MyEditorWindowBase m_Instance = null;
		public static MyEditorWindowBase Instance
		{
			get { return m_Instance ?? new EditorFuncWindow(); }
		}

		public EditorFuncWindow()
		{
			m_Instance = this;
		}

		public override void OnEditorWindowGUI()
		{
			GUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			GUILayout.BeginVertical();
			GUILayout.FlexibleSpace();
			if (GUILayout.Button("Back", GUILayout.Width(50), GUILayout.Height(30)))
			{
				BackWindow();
			}
			GUILayout.EndVertical();
			GUILayout.EndHorizontal();
		}
	}
}

// EOF