//=============================================================================
/// Author : Peng Jiawei
/// FileName : EditorWindowTest.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine.WSA;
using Application = UnityEngine.Application;

namespace SelfFunction
{
	public class EditorWindowTest : EditorWindow
	{
		public int ClickNum { get; set; }
		private string m_TestEditText = "Input:";
		private string m_TestEditTextArea = "Input:";

		private bool m_IsInitialized = false;
		private string[] m_FilesList;

		private void Awake()
		{
			m_IsInitialized = true;
		}

		private void OnGUI()
		{
			if (m_IsInitialized)
			{
				TestEditorPanelInfo();
			}
		}


		private void TestEditorPanelInfo()
		{
			EditorGUIUtility.labelWidth = 130;
			GUILayout.Label("Text field:", EditorStyles.wordWrappedLabel);
			//GUILayout.TextField("Test editor window.", GUILayout.Width(200), GUILayout.Height(30));

			// 10: 限制了输入字数
			m_TestEditText = GUILayout.TextField(m_TestEditText, 10);

			GUILayout.BeginHorizontal();
			// 将下面的组件靠右显示
			GUILayout.FlexibleSpace();
			if (GUILayout.Button("Ok", GUILayout.Width(50), GUILayout.Height(25)))
			{
				Debug.Log("=== Edit text to: " + m_TestEditText + " ===");
			}
			GUILayout.EndHorizontal();

			EditorGUILayout.Space();
			GUILayout.Label("Text area:", EditorStyles.wordWrappedLabel);
			m_TestEditTextArea = GUILayout.TextArea(m_TestEditTextArea, 256);
			GUILayout.BeginHorizontal();
			// 将下面的组件靠右显示
			GUILayout.FlexibleSpace();
			if (GUILayout.Button("Ok", GUILayout.Width(50), GUILayout.Height(25)))
			{
				Debug.Log("=== Edit text atea to: " + m_TestEditTextArea + " ===");
			}
			GUILayout.EndHorizontal();


			// 将Finish按钮置于右下角
			GUILayout.BeginVertical();
			GUILayout.FlexibleSpace();
			GUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			if (GUILayout.Button("Finish", GUILayout.Width(100), GUILayout.Height(30)))
			{
				CloseWindow();
			}
			GUILayout.EndHorizontal();
			GUILayout.EndVertical();
		}

		/// <summary>
		/// 点击Finsih按钮的回调
		/// </summary>
		private void CloseWindow()
		{
			Close();
		}
	}
}

// EOF