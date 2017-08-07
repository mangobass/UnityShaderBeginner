//=============================================================================
/// Author : Peng Jiawei
/// FileName : EditorPanelTest.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using UnityEditor;

namespace SelfFunction
{
	public class EditorPanelTest : EditorWindow
	{

		[MenuItem("MyTools/TestPanel")]
		public static void TestPanel()
		{
			EditorWindowTest window = (EditorWindowTest)GetWindow(typeof(EditorWindowTest), false, "编辑窗口测试");
			window.Show();
		}

	}
}

// EOF