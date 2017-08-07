//=============================================================================
// Desc: 背景滚动
//=============================================================================

Shader "MyShader/Animation/ScrollingBg" {
	Properties {
		_MainTex("Main Texture (RGB)", 2D) = "white"{}
		_DetailTex("2nd Texture (RGB)", 2D) = "white"{}
		_MainScrollSpeed("Main Scroll Speed", Float) = 1.0
		_DetailScrollSpeed("2nd Scroll Speed", Float) = 1.0
		_Multiplier("Layer Multiplier", Float) = 1.0
		_TexMixFactor("Texture Mix Factor", Range(0, 1.0)) = 0.5
	}

	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
		Pass {
			Tags { "LightMode"="ForwardBase" }
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _DetailTex;
			float4 _DetailTex_ST;
			float _MainScrollSpeed;
			float _DetailScrollSpeed;
			float _Multiplier;
			float _TexMixFactor;

			struct a2v
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				// 截取小数部分加到uv上
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex) + frac(_Time.y * float2(_MainScrollSpeed, 0.0));
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _DetailTex) + frac(_Time.y * float2(_DetailScrollSpeed, 0.0));
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 mainColor = tex2D(_MainTex, i.uv.xy);
				fixed4 detailColor = tex2D(_DetailTex, i.uv.zw);

				fixed4 finalColor = lerp(mainColor, detailColor, detailColor.a);
				finalColor.rgb *= _Multiplier;
				//fixed4 finalColor = lerp(mainColor, detailColor, _TexMixFactor);
				//finalColor.rgb *= _Multiplier;

				return finalColor;
			}

			ENDCG
		}
	}
	FallBack "VertexLit"
}
