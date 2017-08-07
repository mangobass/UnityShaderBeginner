//=============================================================================
/// Author : Peng Jiawei
/// FileName : EditorWindowTest.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using UnityEditor;

namespace SelfFunction
{
	public class EditorWindowTest : EditorWindow
	{
		public int ClickNum { get; set; }

		private void Awake()
		{

		}

		private void OnGUI()
		{
			GUILayout.TextField("Test editor window.", GUILayout.Width(200), GUILayout.Height(30));
			if (GUILayout.Button("Btn", GUILayout.Width(100), GUILayout.Height(40)))
			{
				//GUILayout.TextField(string.Format("Btn clicked num: {0}", ++ClickNum), GUILayout.Width(200), GUILayout.Height(30));
				Debug.LogFormat("Btn clicked num: {0}", ++ClickNum);
			}
		}
	}
}

// EOF