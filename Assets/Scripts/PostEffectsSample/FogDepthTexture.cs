//=============================================================================
/// Author : Peng Jiawei
/// FileName : FogDepthTexture.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using ShaderScript.PostEffect;

namespace Sample.PostEffect
{
	public class FogDepthTexture : PostEffectBase
	{
		public Shader FogShader;
		private Material m_FogMaterial;

		public Material UsedMaterial
		{
			get
			{
				m_FogMaterial = CheckShaderAndCreateMaterial(FogShader, m_FogMaterial);
				return m_FogMaterial;
			}
		}

		public Camera MyCamera { set; get; }
		private Transform CameraTrans { set; get; }

		[Range(0.0f, 3.0f), Header("浓度值")]
		public float m_FogDensity = 1.0f;
		public Color m_FogColor = Color.white;

		[Header("起始高度")]
		public float m_FogStart = 0.0f;
		[Header("结束高度")]
		public float m_FogEnd = 2.0f;

		private void Awake()
		{
			MyCamera = GetComponent<Camera>();
			CameraTrans = MyCamera.transform;
		}

		private void OnEnable()
		{
			MyCamera.depthTextureMode |= DepthTextureMode.Depth;
		}

		private void OnRenderImage(RenderTexture src, RenderTexture dest)
		{
			if (UsedMaterial != null)
			{
				Matrix4x4 frustumCorners = Matrix4x4.identity;

				float fov = MyCamera.fieldOfView;
				float near = MyCamera.nearClipPlane;
				float far = MyCamera.farClipPlane;
				float aspect = MyCamera.aspect;

				float halfHeight = near*Mathf.Tan(fov*0.5f*Mathf.Deg2Rad);
				Vector3 toRight = CameraTrans.right*halfHeight*aspect;
				Vector3 toTop = CameraTrans.up*halfHeight;

				Vector3 topLeft = CameraTrans.forward*near + toTop - toRight;
				float scale = topLeft.magnitude/near;
				topLeft.Normalize();
				topLeft *= scale;

				Vector3 topRight = CameraTrans.forward * near + toTop + toRight;
				topRight.Normalize();
				topRight *= scale;

				Vector3 buttomLeft = CameraTrans.forward * near - toTop - toRight;
				buttomLeft.Normalize();
				buttomLeft *= scale;

				Vector3 buttomRight = CameraTrans.forward * near - toTop + toRight;
				buttomRight.Normalize();
				buttomRight *= scale;

				// 存放顺序会影响shader的代码
				frustumCorners.SetRow(0, buttomLeft);
				frustumCorners.SetRow(1, buttomRight);
				frustumCorners.SetRow(2, topRight);
				frustumCorners.SetRow(3, topLeft);

				UsedMaterial.SetMatrix("_FrustumCornersRay", frustumCorners);
				//UsedMaterial.SetMatrix("_ViewProjInvMatrix", (MyCamera.projectionMatrix*MyCamera.worldToCameraMatrix).inverse);

				UsedMaterial.SetFloat("_FogDensity", m_FogDensity);
				UsedMaterial.SetColor("_FogColor", m_FogColor);
				UsedMaterial.SetFloat("_FogStart", m_FogStart);
				UsedMaterial.SetFloat("_FogEnd", m_FogEnd);

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