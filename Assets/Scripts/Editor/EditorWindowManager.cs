//=============================================================================
/// Author : Peng Jiawei
/// FileName : EditorWindowManager.cs
//=============================================================================
using UnityEngine;
using System.Collections;

namespace SelfEditorWindow
{
	public enum E_EditorWindowType
	{
		ENUM_EDITOR_WINDOW_TYPE_1 = 0,
		ENUM_EDITOR_WINDOW_TYPE_2,
		ENUM_EDITOR_WINDOW_TYPE_3,

		ENUM_EDITOR_WINDOW_TYPE_MAIN,

		ENUM_EDITOR_WINDOW_TYPE_MAX
	}


	public class EditorWindowManager
	{
		private static EditorWindowManager m_Instance = null;

		public static EditorWindowManager Instance
		{
			get 
			{
				return m_Instance ?? new EditorWindowManager();
			}
		}

		public EditorWindowMainView MainPanel { get; set; }

		public E_EditorWindowType CurrentWindowType { get; set; }

		public EditorWindowManager()
		{
			m_Instance = this;
			CurrentWindowType = E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_MAIN;
		}
	}
}

// EOF