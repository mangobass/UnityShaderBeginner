//=============================================================================
/// Author : Peng Jiawei
/// FileName : EditorPanelTest.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using SelfEditorWindow;
using UnityEditor;

namespace SelfFunction
{
	public class EditorPanelTest : EditorWindow
	{
		[MenuItem("MyTools/TestPanel")]
		public static void TestPanel()
		{
			//EditorWindowTest window = (EditorWindowTest)GetWindow(typeof(EditorWindowTest), false, "编辑窗口测试");
			EditorWindowTest window = (EditorWindowTest)GetWindowWithRect(typeof(EditorWindowTest), new Rect(0, 0, 400, 500), true, "编辑窗口测试");
			window.Show();
		}

		[MenuItem("MyTools/EditorMainWindow")]
		public static void EditorMainWindow()
		{
			EditorMainWindow window = (EditorMainWindow)GetWindowWithRect(typeof(EditorMainWindow), new Rect(0, 0, 400, 500), true, "自定义编辑窗口");
			window.Show();
		}
	}
}

// EOF