//=============================================================================
// Desc: BillBoard效果
//=============================================================================

Shader "MyShader/Animation/BillBoard" {
	Properties {
		_MainTex("Main Tex", 2D)="white"{}
		_Color("Color Tint", Color)=(1,1,1,1)
		// 用来调整是固定法线还是固定向上方向
		_VerticalBillBoarding("Vertical Restraints", Range(0,1)) = 1
	}

	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" "IngoreProjector"="True" "DisableBatching"="True" }
		Pass {
			Tags { "LightMode"="ForwardBase" }
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			float _VerticalBillBoarding;

			struct a2v {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f o;

				float3 center = float3(0,0,0);
				float3 viewer = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1));

				float3 normalDir = viewer - center;
				normalDir.y *= _VerticalBillBoarding;
				normalDir = normalize(normalDir);

				float3 upDir = abs(normalDir.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
				float3 rightDir = normalize(cross(upDir, normalDir));
				upDir = normalize(cross(normalDir, rightDir));

				float3 centerOffset = v.vertex.xyz-center;
				float3 localPos = center + rightDir * centerOffset.x + upDir * centerOffset.y + normalDir * centerOffset.z;
				o.pos = mul(UNITY_MATRIX_MVP, float4(localPos, 1));
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 color = tex2D(_MainTex, i.uv);
				color.rgb *= _Color.rgb;
				return color;
			}
			ENDCG
		}
	}
	Fallback "Transparent/VertexLit"
}

