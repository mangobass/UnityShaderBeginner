//=============================================================================
// 没有描绘的Graphic类
//=============================================================================

using UnityEngine.UI;
using game.common;
using UnityEngine;

public class NoDrawGraphic : Graphic
{
	#region Parameters Definition
	#endregion Parameters Definition

	private void Awake()
	{
		UIEventListener.Get(gameObject).onClick = OnClick;
	}

	public override void SetVerticesDirty()
	{
	}

	public override void SetMaterialDirty()
	{
	}

	protected override void OnPopulateMesh(VertexHelper vh)
	{
		vh.Clear();
	}

	private void OnClick(GameObject obj)
	{
		Debug.Log("=== Click no draw graphic gameobject. ===");
	}
}

// EOF