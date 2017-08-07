//=============================================================================
/// Create by セルシウス
/// Set text content simply.
//=============================================================================
using UnityEngine;
using UnityEngine.UI;

public class LocalizedText : MonoBehaviour
{
	/// <summary>
	/// Text content ID.
	/// </summary>
	[SerializeField] public string m_TextID = "";

	private void Awake()
	{
		Text textObj = gameObject.GetComponent<Text>();

		// return if text content ID is null or empty.
		if (string.IsNullOrEmpty(m_TextID)) return;

		// return if Text object is null.
		if (textObj != null)
		{
			textObj.text = "Display text by TextId.";
		}
	}
}

// EOF