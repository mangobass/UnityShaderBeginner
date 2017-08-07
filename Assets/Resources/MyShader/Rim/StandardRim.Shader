// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

/* 边缘发光
思路：用视方向和法线方向点乘，模型越边缘的地方，它的法线和视方向越接近90度。
点乘越接近0，那么用 1-减去上面点乘的结果，来作为颜色分量，来反映边缘颜色强弱。
*/

Shader "MyShader/Rim/Standard Rim" {
	Properties {
		m_MainTexture("MainTexture", 2D) = "black"{}
		m_RimColor("RimColor", Color) = (1,0,1,1)
		m_RimPower("RimPower", range(1,10)) = 2
	}

	SubShader{
		Pass {
			Name "Rim Pass"

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct VertexOutput {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 NDotV : COLOR;
			};

			sampler2D m_MainTexture;
			float4 m_RimColor;
			float m_RimPower;

			VertexOutput vert(appdata_base v) {
				VertexOutput outData;
				outData.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				outData.uv = v.texcoord;
				// 根据世界位置计算世界下的视方向
				float3 view = WorldSpaceViewDir(v.vertex);
				// 视方向的转换: 世界坐标系->模型坐标系
                view = mul(unity_WorldToObject,view);
                // 法线与视方向的点积越接近0，说明这点越靠近边缘
                outData.NDotV.x = saturate(dot(v.normal,normalize(view)));
				return outData;
			}

			fixed4 frag(VertexOutput IN) : COLOR {
				fixed4 color = tex2D(m_MainTexture, IN.uv);
				// 在原来的颜色上叠加rim色（越边缘越深）
				color.rgb += pow((1-IN.NDotV.x) ,m_RimPower) * m_RimColor.rgb;
				return color;
			}

			ENDCG
		}
	}
}