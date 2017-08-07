//=============================================================================
// Desc: 适用于场景静止，摄像机快速移动的情况
//=============================================================================

Shader "MyShader/PostEffect/Motion Blur DepthTexture" {
	Properties {
		_MainTex("Base (RGB)", 2D) = "white" {}
		_BlurSize("Blur Size", Float) = 1.0
	}

	SubShader {
		CGINCLUDE
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		float _BlurSize;
		sampler2D _CameraDepthTexture;
		float4x4 _CurrentViewProjInvMatrix;
		float4x4 _PreViewProjMatrix;

		struct v2f {
			float4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
			half2 depthUv : TEXCOORD1;
		};

		v2f vert(appdata_img v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.uv = v.texcoord;
			o.depthUv = v.texcoord;

			#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)
				o.depthUv.y = 1-o.depthUv.y;
			#endif
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.depthUv);
			// Create view pos in NDC coordinate: -1~1
			float4 viewPosNDC = float4(i.uv.x*2-1, i.uv.y*2-1, d*2-1, 1);
			// View pos in world coordinate. Transform by the view-projection inverse.
			float4 viewPosWorld = mul(_CurrentViewProjInvMatrix, viewPosNDC);
			// Divide by w to get the world position. 
			float4 worldPos = viewPosWorld / viewPosWorld.w;

			float4 currentPos = viewPosNDC;
			float4 prePos = mul(_PreViewProjMatrix, worldPos);
			prePos /= prePos.w;

			float2 velocity = (currentPos.xy - prePos.xy) / 2.0;

			float2 uv = i.uv;
			float4 color = tex2D(_MainTex, uv);
			// 控制运动的速度
			uv += velocity*_BlurSize;
			for (int idx = 1; idx < 3; ++idx, uv += velocity*_BlurSize)
			{
				float4 currentColor = tex2D(_MainTex, uv);
				color += currentColor;
			}
			color /= 3;
			return fixed4(color.rgb, 1.0);
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