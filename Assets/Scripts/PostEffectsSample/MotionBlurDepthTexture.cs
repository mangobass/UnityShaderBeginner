//=============================================================================
/// Desc : 速度映射图来实现MotionBlur
/// Author : Peng Jiawei
/// FileName : MotionBlurDepthTexture.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using ShaderScript.PostEffect;
using UnityEngine.Networking;

namespace Sample.PostEffect
{
	public class MotionBlurDepthTexture : PostEffectBase
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

		[Range(0.0f, 1f), Header("混合图像时的模糊参数")]
		public float m_BlurSize = 0.5f;

		private Camera m_MyCamera = null;

		public Camera MyCamera
		{
			get
			{
				if (m_MyCamera == null) m_MyCamera = GetComponent<Camera>();
				return m_MyCamera;
			}
		}

		/// <summary>
		/// 上一帧的摄像机视角*投影矩阵
		/// </summary>
		private Matrix4x4 m_PreViewProjMatrix;

		private void OnEnable()
		{
			// 设置摄像机的深度纹理渲染状态
			MyCamera.depthTextureMode |= DepthTextureMode.Depth;
		}

		private void OnRenderImage(RenderTexture src, RenderTexture dest)
		{
			if (UsedMaterial != null)
			{
				UsedMaterial.SetFloat("_BlurSize", m_BlurSize);

				UsedMaterial.SetMatrix("_PreViewProjMatrix", m_PreViewProjMatrix);
				Matrix4x4 currentViewProjMatrix = MyCamera.projectionMatrix*MyCamera.worldToCameraMatrix;
				Matrix4x4 currentViewProjInvMatrix = currentViewProjMatrix.inverse;
				UsedMaterial.SetMatrix("_CurrentViewProjInvMatrix", currentViewProjInvMatrix);
				m_PreViewProjMatrix = currentViewProjMatrix;

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