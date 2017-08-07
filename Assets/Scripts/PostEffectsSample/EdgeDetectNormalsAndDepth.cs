//=============================================================================
/// Author : Peng Jiawei
/// FileName : EdgeDetectNormalsAndDepth.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using ShaderScript.PostEffect;

public class EdgeDetectNormalsAndDepth : PostEffectBase
{
	public Shader EdgeDetectShader;
	private Material m_EdgeDetectMaterial;

	public Material UsedMaterial
	{
		get
		{
			m_EdgeDetectMaterial = CheckShaderAndCreateMaterial(EdgeDetectShader, m_EdgeDetectMaterial);
			return m_EdgeDetectMaterial;
		}
	}

	[Range(0.0f, 1.0f)]
	public float m_EdgeOnly = 1.0f;
	public Color m_EdgeColor = Color.black;
	public Color m_BackgroundColor = Color.white;
	/// <summary>
	/// 对深度和法线纹理的采样距离
	/// 越大描边越宽
	/// </summary>
	public float m_SampleDistance = 1.0f;

	public float m_SensitivityDepth = 1.0f;
	public float m_SensitivityNormals = 1.0f;

	private Camera m_Camera = null;

	private void Awake()
	{
		m_Camera = GetComponent<Camera>();
	}

	private void OnEnable()
	{
		if (m_Camera == null) return;
		m_Camera.depthTextureMode |= DepthTextureMode.DepthNormals;
	}

	/// <summary>
	/// 不透明的物体渲染后立刻执行OnRenderImage
	/// </summary>
	/// <param name="src"></param>
	/// <param name="dest"></param>
	[ImageEffectOpaque]
	private void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		if (UsedMaterial != null)
		{
			UsedMaterial.SetFloat("_EdgeOnly", m_EdgeOnly);
			UsedMaterial.SetColor("_EdgeColor", m_EdgeColor);
			UsedMaterial.SetColor("_BackgroundColor", m_BackgroundColor);
			UsedMaterial.SetFloat("_SampleDistance", m_SampleDistance);
			UsedMaterial.SetVector("_Sensitivity", new Vector4(m_SensitivityNormals, m_SensitivityDepth, 0.0f, 0.0f));

			Graphics.Blit(src, dest, UsedMaterial);
		}
		else
		{
			Graphics.Blit(src, dest);
		}
	}
}

// EOF