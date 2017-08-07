//=============================================================================
/// Author : Peng Jiawei
/// FileName : proceduralTextureGen.cs
//=============================================================================
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[ExecuteInEditMode]
public class proceduralTextureGen : MonoBehaviour
{
	public Material m_Material = null;
	#region Material properties
	[SerializeField, SetProperty("TextureWidth")]
	private int m_TextureWidth = 512;
	public int TextureWidth {
		get {return m_TextureWidth;}
		set {
			m_TextureWidth = value;
			UpdateMaterial();
		}
	}

	[SerializeField, SetProperty("BackgroundColor")]
	private Color m_BackgroundColor = Color.white;
	public Color BackgroundColor {
		get { return m_BackgroundColor; }
		set {
			m_BackgroundColor = value;
			UpdateMaterial();
		}
	}

	[SerializeField, SetProperty("CircleColor")]
	private Color m_CircleColor = Color.yellow;
	public Color CircleColor {
		get { return m_CircleColor; }
		set {
			m_CircleColor = value;
			UpdateMaterial();
		}
	}

	[SerializeField, SetProperty("BlurFactor")]
	private float m_BlurFactor = 2.0f;
	public float BlurFactor {
		get { return m_BlurFactor; }
		set {
			m_BlurFactor = value;
			UpdateMaterial();
		}
	}
	#endregion Material properties
	private Texture2D m_GeneratedTexture = null;

	private void Start()
	{
		if (m_Material == null)
		{
			Renderer renderer = gameObject.GetComponent<Renderer>();
			if (renderer == null)
			{
				Debug.LogWarning("=== Cannot find a renderer. ===");
				return;
			}

			m_Material = renderer.sharedMaterial;
		}

		UpdateMaterial();
	}

	private void UpdateMaterial()
	{
		if (m_Material != null)
		{
			m_GeneratedTexture = GenerateProceduralTexture();
			m_Material.SetTexture("_MainTex", m_GeneratedTexture);
		}
	}

	private Color MixColor(Color color0, Color color1, float mixFactor)
	{
		Color mixColor = Color.white;
		mixColor.r = Mathf.Lerp(color0.r, color1.r, mixFactor);
		mixColor.g = Mathf.Lerp(color0.g, color1.g, mixFactor);
		mixColor.b = Mathf.Lerp(color0.b, color1.b, mixFactor);
		mixColor.a = Mathf.Lerp(color0.a, color1.a, mixFactor);
		return mixColor;
	}

	private Texture2D GenerateProceduralTexture()
	{
		Texture2D proceduralTexture = new Texture2D(TextureWidth, TextureWidth);

		float circleInterval = TextureWidth/4.0f;
		float radius = TextureWidth/10.0f;
		float edgeBlur = 1.0f / BlurFactor;

		for (int w = 0; w < TextureWidth; ++w)
		{
			for (int h = 0; h < TextureWidth; ++h)
			{
				Color pixel = BackgroundColor;
				// Draw 9 circles
				for (int i = 0; i < 3; ++i)
				{
					for (int j = 0; j < 3; ++j)
					{
						Vector2 circleCenter = new Vector2(circleInterval*(i+1), circleInterval*(j+1));
						float dist = Vector2.Distance(new Vector2(w,h), circleCenter)-radius;

						Color color = MixColor(CircleColor, new Color(pixel.r,pixel.g,pixel.b, 0.0f), Mathf.SmoothStep(0.0f, 1.0f, dist*edgeBlur));
						pixel = MixColor(pixel, color, color.a);
					}
				}
				proceduralTexture.SetPixel(w,h,pixel);
			}
		}
		proceduralTexture.Apply();
		return proceduralTexture;
	}
}

// EOF