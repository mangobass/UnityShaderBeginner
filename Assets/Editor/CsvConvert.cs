//=============================================================================
/// Author : Peng Jiawei
/// FileName : CsvConvert.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using System.IO;
using UnityEditor;

public class CsvConvert : MonoBehaviour
{
	public static string[] m_FilesList;

	public static void ReadFile()
	{
		for (int idx = 0; idx < m_FilesList.Length; ++idx)
		{
			FileStream fs = new FileStream(m_FilesList[idx], FileMode.Open);
			StreamReader sr = new StreamReader(fs);
			string currentLine = sr.ReadLine();
			while (currentLine != null)
			{
				Debug.Log("=== " + currentLine + " ===");
				currentLine = sr.ReadLine();
			}
		}

	}

	[MenuItem("MyTools/CsvConvert")]
	public static void ConvertCsvFile()
	{
		m_FilesList = Directory.GetFiles(Application.streamingAssetsPath + "/Files", "*.csv");
		ReadFile();
	}
}

// EOF