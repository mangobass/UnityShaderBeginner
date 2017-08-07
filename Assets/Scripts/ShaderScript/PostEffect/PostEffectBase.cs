//=============================================================================
// Desc: 屏幕后处理脚本系统
//=============================================================================

using UnityEngine;

namespace ShaderScript.PostEffect
{
	[ExecuteInEditMode]
	[RequireComponent(typeof(Camera))]
	public class PostEffectBase : MonoBehaviour
	{
		protected void Start()
		{
			CheckResources();
		}

		protected void CheckResources()
		{
			if (!CheckSupport()) NotSupported();
		}

		protected bool CheckSupport()
		{
			if (!SystemInfo.supportsImageEffects
				|| !SystemInfo.supportsRenderTextures)
			{
				Debug.LogWarning("=== This platform does not support image effects or rengder textures. ===");
				return false;
			}

			return true;
		}

		protected void NotSupported()
		{
			enabled = false;
		}

		// Called when need to create the material used by this effect.
		protected Material CheckShaderAndCreateMaterial(Shader shader, Material material)
		{
			if (shader == null) return null;
			if (shader.isSupported && material && material.shader == shader) return material;
			if (!shader.isSupported)
			{
				return null;
			}
			else
			{
				material = new Material(shader);
				if (material)
				{
					material.hideFlags = HideFlags.DontSave;
					return material;
				}
				else
				{
					return null;
				}
			}
		}
	}
}
 // EOF