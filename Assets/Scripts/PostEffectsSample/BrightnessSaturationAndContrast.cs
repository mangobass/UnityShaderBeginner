//=============================================================================
// Author : 
//=============================================================================
using UnityEngine;
using System.Collections;
using ShaderScript.PostEffect;

namespace Sample.PostEffect
{
	public class BrightnessSaturationAndContrast : PostEffectBase
	{
		public Shader BriSatConShader;
		private Material m_BriSatConMaterial;

		public Material UsedMaterial
		{
			get
			{
				m_BriSatConMaterial = CheckShaderAndCreateMaterial(BriSatConShader, m_BriSatConMaterial);
				return m_BriSatConMaterial;				
			}
		}

		[Range(0.0f, 3.0f)]
		public float m_Brightness = 1.0f;
		[Range(0.0f, 3.0f)]
		public float m_Saturation = 1.0f;
		[Range(0.0f, 3.0f)]
		public float m_Contrast = 1.0f;

		void OnRenderImage(RenderTexture src, RenderTexture dest)
		{
			if (UsedMaterial != null)
			{
				UsedMaterial.SetFloat("_Brightness", m_Brightness);
				UsedMaterial.SetFloat("_Saturation", m_Saturation);
				UsedMaterial.SetFloat("_Contrast", m_Contrast);
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