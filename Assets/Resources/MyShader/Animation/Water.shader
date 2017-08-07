//=============================================================================
// Desc: 2D水的波浪效果
//=============================================================================

Shader "MyShader/Animation/Water" {
	properties {
		_MainTex("Main Tex", 2D) = "white" {}
		_Color("Color Tint", Color) = (1,1,1,1)
		_Magnitude("Magnitude", Float) = 1
		_Frequency("Frequenct", Float) = 1
		_InvWaveLength("Distortion Inverse Wave Length", Float) = 10
		_Speed("Speed", Float) = 0.5
	}

	SubShader{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" "DisableBatching"="True" }
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
			float _Magnitude;
			float _Frequency;
			float _InvWaveLength;
			float _Speed;

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
				float4 offset;
				offset.yzw = float3(0.0, 0.0, 0.0);
				offset.x = sin(_Frequency*_Time.y+v.vertex.x*_InvWaveLength+v.vertex.y*_InvWaveLength + v.vertex.z*_InvWaveLength)*_Magnitude;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex+offset);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv += float2(0, _Time.y*_Speed);
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