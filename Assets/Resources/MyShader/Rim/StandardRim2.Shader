// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

/* 边缘描边

1.描边（一）
思路：两次渲染，第一次渲染背面，剔除正面，把模型顶点沿法线方向扩伸一定距离
（用来表现描边的粗细）。第二次渲染，渲染正面，剔除背面

2.描边（二）
思路：两次渲染。第一次渲染背面，剔除正面。利用Offset指令，向离摄像机更近的方式偏移
第二次正常渲染物体（不剔除），（或者可以渲染正面，剔除背面）。

Offset：深度偏移
Offset Factor,Units
Factor参数表示 Z缩放的最大斜率的值。
Units参数表示可分辨的最小深度缓冲区的值。

我的理解：深度偏移，Unity是左手坐标系,Z的正方向是朝屏幕里面。
沿Z的负方向偏移就是离摄像机更近，
沿Z的正方向偏移就是离摄像机更远。

作用：可以强制使位于同一位置上的两个几合体中的一个几何体绘制在另一个的上层
比如：几何体A的Z值比几何体B更远，此时B是在A的上层。
但是，给A设置了Offset 往Z的负方向偏移，此时A比B更近了，A就在B上层了。
在深度测试（Z test）的时候，会去比较Z值，近的会绘制在远的上面。

所以上面的思路，要么第一次渲染背面，往Z的负方向偏移
要么第二次渲染的，往Z的正方向偏移，都是可以的。
*/
Shader "MyShader/Rim/Standard Rim2" {
	Properties {
		m_MainTexture("MainTexture", 2D) = "black"{}
		m_RimColor("RimColor", Color) = (0,0,1,1)
		m_RimPower("RimPower", range(1,10)) = 2
	}

	SubShader{
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="Opaque"
       }
		Pass {
			Name "Rim Pass"
			//Cull Front
			Tags {
				"LightMode"="ForwardBase"
            }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
            #include "AutoLight.cginc"

			struct VertexOutput {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				half4 dotN : COLOR;
			};

			sampler2D m_MainTexture;
			float4 m_RimColor;
			float m_RimPower;
			// Directional Light in game scene
            float4 _LightColor0;


			VertexOutput vert(appdata_tan v) {
				VertexOutput outData = (VertexOutput)0;
				outData.uv = v.texcoord;
				float4 vertex_view = mul(UNITY_MATRIX_MV, v.vertex);
				float3 normal_view = mul(UNITY_MATRIX_IT_MV, v.normal);
				vertex_view.xyz += normalize(normal_view)*0.05;
				outData.pos = mul(UNITY_MATRIX_P, vertex_view);

				float3 vertexWorldDir = WorldSpaceViewDir(v.vertex);
				//float3 vertexWorldDir = WorldSpaceViewDir(mul(UNITY_MATRIX_T_MV, vertex_view));
				float3 vertexDir = mul(unity_WorldToObject, vertexWorldDir);
				// saturate() 返回[0,1]的值，小于0返回0， 大于1返回1
				outData.dotN.x = saturate(dot(v.normal, normalize(vertexDir)));
				return outData;
			}

			float4 frag(VertexOutput IN) : COLOR {
				//float4 outColor = tex2D(m_MainTexture, IN.uv);
				//outColor += pow(m_RimColor*(1-IN.dotN.x), 2);
				//return outColor;
				//return m_RimColor*(1-IN.dotN.x);
				return m_RimColor;
			}

			ENDCG
		}

//		Pass {
//			Cull Back
//			CGPROGRAM
//			#pragma vertex vert
//			#pragma fragment frag
//			#include "UnityCG.cginc"
//
//			struct VertexOutput {
//				float4 pos : SV_POSITION;
//				float2 uv : TEXCOORD0;
//			};
//
//			sampler2D m_MainTexture;
//			float4 m_RimColor;
//			float m_RimPower;
//
//			VertexOutput vert(appdata_base v) {
//				VertexOutput outData = (VertexOutput)0;
//				outData.pos = mul(UNITY_MATRIX_MVP, v.vertex);
//				outData.uv = v.texcoord.xy;
//				return outData;
//			}
//
//			fixed4 frag(VertexOutput IN) : COLOR {
//				return tex2D(m_MainTexture, IN.uv);
//			}
//
//			ENDCG
//		}
	}
}