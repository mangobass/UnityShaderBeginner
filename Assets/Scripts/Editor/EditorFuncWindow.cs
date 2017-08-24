//=============================================================================
/// Author : Peng Jiawei
/// FileName : EditorFuncWindow.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using Common;
using UnityEditor;
using UnityEngine.UI;

namespace SelfEditorWindow

{
	public class EditorFuncWindow : MyEditorWindowBase
	{
		#region Parameters Definition
		protected static MyEditorWindowBase m_Instance = null;
		public static MyEditorWindowBase Instance
		{
			get { return m_Instance ?? new EditorFuncWindow(); }
		}

		private bool m_IsShowPrefabBtnClicked = false;
		private string[] m_PrefabPathArrays;

		Vector2 m_ScrollPos = new Vector2(0, 0);
		#endregion Parameters Definition

		private EditorFuncWindow()
		{
			m_Instance = this;
			EditorWindowType = E_EditorWindowType.ENUM_EDITOR_WINDOW_TYPE_1;
		}

		private void ClearPrefabInfos()
		{
			m_PrefabPathArrays = null;
		}

		private void ShowPrefabGUI()
		{
			GUILayout.Label("Prefabs path:");
			GUILayout.Space(5);
			m_ScrollPos = EditorGUILayout.BeginScrollView(m_ScrollPos);
			GUILayout.Label("000");
			GUILayout.Label("111", EditorStyles.wordWrappedLabel);
			GUILayout.Label("222", EditorStyles.wordWrappedLabel);
			GUILayout.Label("333", EditorStyles.wordWrappedLabel);
			GUILayout.Label("444", EditorStyles.wordWrappedLabel);
			GUILayout.Label("555", EditorStyles.wordWrappedLabel);
			EditorGUILayout.EndScrollView();


			GUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			GUILayout.BeginVertical();
			GUILayout.FlexibleSpace();
			if (GUILayout.Button("Back", ConstParams.GetCommonBtnWidth(), ConstParams.GetCommonBtnHeight()))
			{
				ClearShowPrefabResult();
			}
			GUILayout.EndVertical();
			GUILayout.EndHorizontal();
		}

		public override void OnEditorWindowGUI()
		{
			if (m_IsShowPrefabBtnClicked)
			{
				ShowPrefabGUI();
			}
			else
			{
				if (GUILayout.Button("Show Prefab", GUILayout.Width(120), ConstParams.GetCommonBtnHeight()))
				{
					ShowPrefab();
				}

				GUILayout.BeginHorizontal();
				GUILayout.FlexibleSpace();
				GUILayout.BeginVertical();
				GUILayout.FlexibleSpace();
				if (GUILayout.Button("Back", ConstParams.GetCommonBtnWidth(), ConstParams.GetCommonBtnHeight()))
				{
					ClickBackBtn();
				}
				GUILayout.EndVertical();
				GUILayout.EndHorizontal();
			}
		}

		private void ShowPrefab()
		{
			// 变量strArrays: Asset database数据
			string[] strArrays = AssetDatabase.FindAssets("t:prefab", new[] { "Assets/Prefabs/GUI" });

			m_PrefabPathArrays = new string[strArrays.Length];
			for (int i = 0; i < strArrays.Length; ++i)
			{
				m_PrefabPathArrays[i] = AssetDatabase.GUIDToAssetPath(strArrays[i]);
			}

			//GameObject[] objArrays = new GameObject[m_PrefabPathArrays.Length];
			foreach (string path in m_PrefabPathArrays)
			{
				Debug.Log("=== " + path + " ===");
				//GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
				//InitGameObject(obj);
				//objArrays[index++] = obj;
			}

			EditorApplication.SaveAssets();
			m_IsShowPrefabBtnClicked = true;
		}

		/// <summary>
		/// 初始化Text文本上的LocalizedText脚本
		/// </summary>
		/// <param name="obj">prefab对象</param>
		/// <returns></returns>
		public static bool InitGameObject(GameObject obj)
		{
			Text textObj = obj.GetComponent<Text>();
			if (textObj == null)
			{
				textObj = obj.AddComponent<Text>();
			}
			textObj.alignment = TextAnchor.MiddleCenter;

			LocalizedText scriptObj = textObj.GetComponent<LocalizedText>();
			if (scriptObj == null)
			{
				scriptObj = textObj.gameObject.AddComponent<LocalizedText>();
			}
			// 具体设置LocalizedText中所需的属性，下略

			string textId = "text";
			if (scriptObj.m_TextID != textId)
			{
				scriptObj.m_TextID = textId;
				EditorUtility.SetDirty(obj);
			}
			return true;
		}

		private void ClearShowPrefabResult()
		{
			m_IsShowPrefabBtnClicked = false;
			ClearPrefabInfos();
		}

		private void ClickBackBtn()
		{
			ClearShowPrefabResult();
			BackWindow();
		}
	}
}

// EOF