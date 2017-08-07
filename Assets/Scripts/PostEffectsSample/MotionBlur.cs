//=============================================================================
/// Author : Peng Jiawei
/// FileName : MotionBlur.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using ShaderScript.PostEffect;

namespace Sample.PostEffect
{
	public class MotionBlur : PostEffectBase
	{
		public Shader MotionBlurShader;
		private Material m_MotionBlurMaterial = null;

		public Material UsedMaterial
		{
			get
			{
				m_MotionBlurMaterial = CheckShaderAndCreateMaterial(MotionBlurShader, m_MotionBlurMaterial);
				return m_MotionBlurMaterial;
			}
		}

		[Range(0.0f, 0.9f), Header("混合图像时的模糊参数")]
		public float m_BlurAmount = 0.5f;

		private RenderTexture m_AccumulationTexture;

		private void OnDisable()
		{
			DestroyImmediate(m_AccumulationTexture);
		}

		private void OnRenderImage(RenderTexture src, RenderTexture dest)
		{
			if (UsedMaterial != null)
			{
				if (m_AccumulationTexture == null || m_AccumulationTexture.width != src.width ||
				    m_AccumulationTexture.height != src.height)
				{
					DestroyImmediate(m_AccumulationTexture);
					m_AccumulationTexture = new RenderTexture(src.width, src.height, 0);
					m_AccumulationTexture.hideFlags = HideFlags.HideAndDontSave;
					Graphics.Blit(src, m_AccumulationTexture);
				}

				// 
				m_AccumulationTexture.MarkRestoreExpected();
				UsedMaterial.SetFloat("_BlurAmount", 1.0f-m_BlurAmount);
				Graphics.Blit(src, m_AccumulationTexture, UsedMaterial);
				Graphics.Blit(m_AccumulationTexture, dest);
			}
			else
			{
				Graphics.Blit(src, dest);
			}
		}
	}

}

// EOF