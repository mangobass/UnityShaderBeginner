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
			GUILayout.Label("Test editor window.");
			//GUILayout.TextField("Test editor window.", GUILayout.Width(200), GUILayout.Height(30));
			if (GUILayout.Button("Click", GUILayout.Width(100), GUILayout.Height(40)))
			{
				Debug.LogFormat("Btn clicked num: {0}", ++ClickNum);
			}
		}
	}
}

// EOF