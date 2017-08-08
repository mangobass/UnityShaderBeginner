//=============================================================================
/// Author : Peng Jiawei
/// FileName : Dissolve.cs
//=============================================================================
using UnityEngine;
using System.Collections;

public class Dissolve : MonoBehaviour
{
	private Material m_DissolveMaterial = null;
	private float m_BurnAmount = 0.0f;

	private void Awake()
	{
		m_DissolveMaterial = GetComponent<MeshRenderer>().material;
	}

	private void Update()
	{
		if (m_DissolveMaterial == null) return;
		if (m_BurnAmount >= 1.0f) return;
		m_BurnAmount += Time.fixedDeltaTime / 60.0f;
		if (m_BurnAmount >= 1.0f) m_BurnAmount = 1.0f;
		m_DissolveMaterial.SetFloat("_BurnAmount", m_BurnAmount);
	}
}

// EOF