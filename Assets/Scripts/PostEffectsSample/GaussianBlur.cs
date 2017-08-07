//=============================================================================
// Dest: Gaussian Blur
//=============================================================================
using UnityEngine;
using System.Collections;
using ShaderScript.PostEffect;

namespace Sample.PostEffect
{
	public class GaussianBlur : PostEffectBase
	{
		public Shader GaussianBlurShader;
		private Material m_GaussianBlurMaterial;

		public Material UsedMaterial
		{
			get
			{
				m_GaussianBlurMaterial = CheckShaderAndCreateMaterial(GaussianBlurShader, m_GaussianBlurMaterial);
				return m_GaussianBlurMaterial;
			}
		}

		[Range(0, 4), Header("控制模糊的迭代次数")]
		public int m_Iterations = 3;
		[Range(0.2f, 3.0f), Header("控制模糊程度")]
		public float m_BlurSpread = 0.6f;
		[Range(1, 8), Header("控制采样多少：越大采样越少")]
		public int m_DownSample = 2;

#if false
		// Normal gaussian blur process.
		private void OnRenderImage(RenderTexture src, RenderTexture dest)
		{
			if (UsedMaterial != null)
			{
				int rtW = src.width;
				int rtH = src.height;
				RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);

				Graphics.Blit(src, buffer, UsedMaterial, 0);
				Graphics.Blit(buffer, dest, UsedMaterial, 1);

				RenderTexture.ReleaseTemporary(buffer);
			}
			else
			{
				Graphics.Blit(src, dest);
			}
		}
#else
		// With scaling the render texture and increasing blur.
		private void OnRenderImage(RenderTexture src, RenderTexture dest)
		{
			if (UsedMaterial != null)
			{
				int rtW = src.width / m_DownSample;
				int rtH = src.height / m_DownSample;

				RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
				buffer0.filterMode = FilterMode.Bilinear;
				Graphics.Blit(src, buffer0);

				// 模糊的迭代次数
				for (int idx = 0; idx < m_Iterations; ++idx)
				{
					UsedMaterial.SetFloat("_BlurSize", 1.0f+idx*m_BlurSpread);
					RenderTexture buffer1 = RenderTexture.GetTemporary(rtW,rtH,0);
					// Pass 0: Vertical
					Graphics.Blit(buffer0, buffer1, UsedMaterial, 0);
					RenderTexture.ReleaseTemporary(buffer0);
					buffer0 = buffer1;
					buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
					// Pass 1: Horizontal
					Graphics.Blit(buffer0, buffer1, UsedMaterial, 1);
					RenderTexture.ReleaseTemporary(buffer0);
					buffer0 = buffer1;
				}

				Graphics.Blit(buffer0, dest);
				RenderTexture.ReleaseTemporary(buffer0);
			}
			else
			{
				Graphics.Blit(src, dest);
			}
		}
#endif
	}
}

// EOF