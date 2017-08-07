//=============================================================================
// Desc: 使用5x5的高斯核对图像进行高斯模糊
//=============================================================================

Shader "MyShader/PostEffect/Gaussian Blur" {
	Properties {
		_MainTex("Base (RGB)", 2D) = "white"{}
		// _BlurSize越大，模糊程度越高
		_BlurSize("Blur Size", Float) = 1.0
	}
	SubShader {
		// CGPROGRAM内共用的代码
		CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		float _BlurSize;

		struct v2f {
			float4 pos : SV_POSITION;
			half2 uv[5] : TEXCOORD0;
		};

		v2f vertBlurVertical(appdata_img v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

			half2 uv = v.texcoord;
			o.uv[0] = uv;
			o.uv[1] = uv + float2(0.0, _MainTex_TexelSize.y*1.0)*_BlurSize;
			o.uv[2] = uv - float2(0.0, _MainTex_TexelSize.y*1.0)*_BlurSize;
			o.uv[3] = uv + float2(0.0, _MainTex_TexelSize.y*2.0)*_BlurSize;
			o.uv[4] = uv - float2(0.0, _MainTex_TexelSize.y*2.0)*_BlurSize;

			return o;
		}

		v2f vertBlurHorizontal(appdata_img v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			half2 uv = v.texcoord;
			o.uv[0] = uv;
			o.uv[1] = uv + float2(_MainTex_TexelSize.x*1.0, 0.0)*_BlurSize;
			o.uv[2] = uv - float2(_MainTex_TexelSize.x*1.0, 0.0)*_BlurSize;
			o.uv[3] = uv + float2(_MainTex_TexelSize.x*2.0, 0.0)*_BlurSize;
			o.uv[4] = uv - float2(_MainTex_TexelSize.x*2.0, 0.0)*_BlurSize;
			return o;
		}

		fixed4 fragBlur(v2f i) : SV_Target
		{
			// Vertical:   Horizontal:
			// weight[2]   weight[2]weight[1]weight[0]weight[1]weight[2]
			// weight[1]
			// weight[0]
			// weight[1]
			// weight[2]
			float weight[3] = {0.4026, 0.2442, 0.0545};
			fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb * weight[0];

			for (int idx = 1; idx < 3; ++idx)
			{
				sum += tex2D(_MainTex, i.uv[2*idx-1]).rgb*weight[idx];
				sum += tex2D(_MainTex, i.uv[2*idx]).rgb*weight[idx];
			}

			return fixed4(sum, 1.0);
		}
		ENDCG

		ZTest Off Cull Off ZWrite Off
		Pass {
			// 为Pass定义名字，可以在其他Shader中直接通过它们的名字来使用该Pass
			NAME "GAUSSIAN_BLUR_HORIZONTAL"
			CGPROGRAM
			#pragma vertex vertBlurHorizontal
			#pragma fragment fragBlur
			ENDCG
		}
		Pass {
			NAME "GAUSSIAN_BLUR_VERTICAL"
			CGPROGRAM
			#pragma vertex vertBlurVertical
			#pragma fragment fragBlur
			ENDCG
		}
	}
	FallBack Off
}
