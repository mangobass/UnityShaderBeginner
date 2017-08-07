//=============================================================================
// Author : 
//=============================================================================
using UnityEngine;
using System.Collections;
using ShaderScript.PostEffect;

namespace Sample.PostEffect
{
	public class EdgeDetection : PostEffectBase
	{
		#region Parameters
		public Shader EdgeDetectionShader;
		private Material m_EdgeDetectionMaterial;

		public Material UsedMaterial
		{
			get
			{
				m_EdgeDetectionMaterial = CheckShaderAndCreateMaterial(EdgeDetectionShader, m_EdgeDetectionMaterial);
				return m_EdgeDetectionMaterial;
			}
		}

		[Range(0.0f, 1.0f)]
		public float m_EdgeOnly = 0.0f;
		public Color m_EdgeColor = Color.black;
		public Color m_BackgroudColor = Color.white;
		#endregion Parameters

		private void OnRenderImage(RenderTexture src, RenderTexture dest)
		{
			if (UsedMaterial != null)
			{
				UsedMaterial.SetFloat("_EdgeOnly", m_EdgeOnly);
				UsedMaterial.SetColor("_EdgeColor", m_EdgeColor);
				UsedMaterial.SetColor("_BackgroundColor", m_BackgroudColor);

				Graphics.Blit(src, dest, UsedMaterial);
			}
			else
			{
				Graphics.Blit(src, dest);
			}
		}
	}
}

// EOF