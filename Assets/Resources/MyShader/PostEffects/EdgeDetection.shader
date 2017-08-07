//=============================================================================
// Desc: 使用Sobel卷积核对图像进行边缘检测
// Gx:[-1][-2][-1]  Gy:[-1][0][1]
//    [ 0][ 0][ 0]     [-2][0][2]
//    [ 1][ 2][ 1]     [-1][0][1]
//=============================================================================

Shader "MyShader/PostEffect/Edge Detection" {
	properties {
		_MainTex("Base (RGB)", 2D) = "white" {}
		_EdgeOnly("Edge Only", Range(0.0, 1.0)) = 0.0
		_EdgeColor("Edge Color", Color) = (0,0,0,1)
		_BackgroundColor("Background Color", Color) = (1,1,1,1)
	}
	SubShader{
		Pass {
			ZWrite Off Cull Off ZTest Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragSobel
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			// 对应的纹理每个纹素的大小
			float4 _MainTex_TexelSize;
			fixed _EdgeOnly;
			fixed4 _EdgeColor;
			fixed4 _BackgroundColor;

			struct a2f {
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				half2 uv[9] : TEXCOORD0;
			};

			fixed Luminance(fixed4 color)
			{
				return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
			}

			half Sobel(v2f i)
			{
				// Sobel的边缘检测算子（卷积核）
				const half Gx[9] = {-1, -2, -1,
									 0,  0,  0,
									 1,  2,  1};
				const half Gy[9] = {-1,  0,  1,
									-2,  0,  2,
									-1,  0,  1};

				half texColor;
				half edgeX = 0;
				half edgeY = 0;
				for (int idx = 0; idx < 9; ++idx)
				{
					texColor = Luminance(tex2D(_MainTex, i.uv[idx]));
					edgeX += texColor * Gx[idx];
					edgeY += texColor * Gy[idx];
				}

				half edge = 1 - abs(edgeX) - abs(edgeY);
				// abs(edgeX) + abs(edgeY)的值越大，越可能是个边缘点。
				// 因此edge越小，表面该位置越可能是一个边缘点。
				return edge;
			}

			v2f vert(a2f v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				half2 uv = v.texcoord;

				o.uv[0] = uv +_MainTex_TexelSize.xy*half2(-1, -1);
				o.uv[1] = uv +_MainTex_TexelSize.xy*half2( 0, -1);
				o.uv[2] = uv +_MainTex_TexelSize.xy*half2( 1, -1);
				o.uv[3] = uv +_MainTex_TexelSize.xy*half2(-1,  0);
				o.uv[4] = uv +_MainTex_TexelSize.xy*half2( 0,  0);
				o.uv[5] = uv +_MainTex_TexelSize.xy*half2( 1,  0);
				o.uv[6] = uv +_MainTex_TexelSize.xy*half2(-1,  1);
				o.uv[7] = uv +_MainTex_TexelSize.xy*half2( 0,  1);
				o.uv[8] = uv +_MainTex_TexelSize.xy*half2( 1,  1);
				return o;
			}

			fixed4 fragSobel(v2f i) : SV_Target
			{
				half edge = Sobel(i);
				fixed4 withEdgeColor = lerp(_EdgeColor, tex2D(_MainTex, i.uv[4]), edge);
				fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);
				return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
			}
			ENDCG
		}
	}
	Fallback Off
}