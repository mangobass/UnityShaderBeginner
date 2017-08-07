//=============================================================================
/// Author : 
/// FileName : AnimationTest.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using UnityEditor;


public class AnimationTest : MonoBehaviour
{
	private Animation m_TestAnim = null;
    public void Awake()
    {
	    AnimationClip clip = AssetDatabase.LoadAssetAtPath<AnimationClip>("Assets/Animation/UI/list_down_animation.anim");
	    if (clip != null)
	    {
			Animation[] objArray = gameObject.GetComponentsInChildren<Animation>();
		    for (int i = 0; i < objArray.Length; ++i)
		    {
			    if (objArray[i].name.Equals("Panel_animation"))
			    {
					m_TestAnim = objArray[i];

					m_TestAnim.AddClip(clip, "listAnim");
					m_TestAnim.clip = clip;
					break;
			    }
		    }
	    }
    }
}

// EOF