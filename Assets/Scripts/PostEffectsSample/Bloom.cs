//=============================================================================
// Dest: Gaussian Blur
//=============================================================================
using UnityEngine;
using System.Collections;
using ShaderScript.PostEffect;
using UnityEngine.Networking;

namespace Sample.PostEffect
{
	public class Bloom : PostEffectBase
	{
		public Shader BloomShader;
		private Material m_BloomMaterial;

		public Material UsedMaterial
		{
			get
			{
				m_BloomMaterial = CheckShaderAndCreateMaterial(BloomShader, m_BloomMaterial);
				return m_BloomMaterial;
			}
		}

		[Range(0, 4), Header("控制模糊的迭代次数")]
		public int m_Iterators = 3;
		[Range(0.2f, 3.0f), Header("控制模糊程度")]
		public float m_BlurSpread = 0.6f;
		[Range(1, 8), Header("控制采样多少：越大采样越少")]
		public int m_DownSample = 2;
		[Range(0.0f, 4.0f), Header("提取较亮区域时使用的阈值")]
		public float m_LuminanceThreshold = 0.6f;

		private void OnRenderImage(RenderTexture src, RenderTexture dest)
		{
			if (UsedMaterial != null)
			{
				UsedMaterial.SetFloat("_LuminanceThreshold", m_LuminanceThreshold);

				int rtW = src.width/m_DownSample;
				int rtH = src.height/m_DownSample;

				RenderTexture buff0 = RenderTexture.GetTemporary(rtW, rtH, 0);
				buff0.filterMode = FilterMode.Bilinear;
				Graphics.Blit(src, buff0, UsedMaterial, 0);

				for (int idx = 0; idx < m_Iterators; ++idx)
				{
					UsedMaterial.SetFloat("_BlurSize", 1.0f + idx * m_BlurSpread);
					RenderTexture buff1 = RenderTexture.GetTemporary(rtW, rtH, 0);

					Graphics.Blit(buff0, buff1, UsedMaterial, 1);

					RenderTexture.ReleaseTemporary(buff0);
					buff0 = buff1;
					buff1 = RenderTexture.GetTemporary(rtW, rtH, 0);

					Graphics.Blit(buff0, buff1, UsedMaterial, 2);
					RenderTexture.ReleaseTemporary(buff0);
					buff0 = buff1;
				}

				UsedMaterial.SetTexture("_Bloom", buff0);
				Graphics.Blit(src, dest, UsedMaterial, 3);
				RenderTexture.ReleaseTemporary(buff0);
			}
			else
			{
				Graphics.Blit(src, dest);
			}
		}
	}
}

//EOF