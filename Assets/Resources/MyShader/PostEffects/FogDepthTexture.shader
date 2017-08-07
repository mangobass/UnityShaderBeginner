Shader "MyShader/PostEffect/Fog DepthTexture" {
	Properties {
		_MainTex("Base (RGB)", 2D) = "white" {}
		_FogDensity("Fog Density", Float) = 1.0
		_FogColor("Fog Color", Color) = (1,1,1,1)
		_FogStart("Fog Start", Float) = 0.0
		_FogEnd("Fog End", Float) = 1.0
	}

	SubShader {
		CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		sampler2D _CameraDepthTexture;
		float _FogDensity;
		float4 _FogColor;
		float _FogStart;
		float _FogEnd;

		// 一次存放的方向：左下，右下，右上，左上
		float4x4 _FrustumCornersRay;

		struct v2f {
			float4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
			half2 uv_depth : TEXCOORD1;
			// 插值后的像素向量
			float4 interPloatedRay : TEXCOORD2;
		};

		v2f vert(appdata_img v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.uv = v.texcoord;
			o.uv_depth = v.texcoord;

			#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)
				o.uv_depth.y = 1 - o.uv_depth.y;
			#endif

			int index = 0;
			if (v.texcoord.x < 0.5 && v.texcoord.y < 0.5)
			{
				index = 0;
			}
			else if (v.texcoord.x > 0.5 && v.texcoord.y < 0.5)
			{
				index = 1;
			}
			else if (v.texcoord.x > 0.5 && v.texcoord.y > 0.5)
			{
				index = 2;
			}
			else
			{
				index = 3;
			}
			#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)
				index = 3-index;
			#endif

			o.interPloatedRay = _FrustumCornersRay[index];
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			float linearDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth));
			float3 worldPos = _WorldSpaceCameraPos + linearDepth*i.interPloatedRay.xyz;

			float fogDensity = saturate(_FogDensity * (_FogEnd - worldPos.y) / (_FogEnd - _FogStart));
			fixed4 color = tex2D(_MainTex, i.uv);
			color.rgb = lerp(color.rgb, _FogColor, fogDensity);
			return color;
		}
		ENDCG

		Pass {
			ZTest Always Cull Off ZWrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	}
	Fallback Off
}