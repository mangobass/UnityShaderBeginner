//=============================================================================
// Desc: 简单的纹理贴图读取
//=============================================================================
Shader "MyShader/Beginning/Single Texture"
{
	Properties {
		_Color("Color Tint", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white"{}
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}

	SubShader {
		Pass {
			Tags {"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0; // 归一化后
				float3 worldPos : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				
				// Also can use TRANSFORM_TEX(v.texcoord, _MainTex) to calculate uv.
				o.uv = v.texcoord.xy*_MainTex_ST.xy + _MainTex_ST.zw;

				//o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				
				fixed3 albedo = tex2D(_MainTex, i.uv) * _Color.rgb;
				fixed3 diffuse = _LightColor0.rgb*albedo*max(0, dot(i.worldNormal, worldLightDir));
			
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;

				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 worldHalfDir = normalize(worldLightDir + worldViewDir);
				fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0, dot(i.worldNormal, worldHalfDir)), _Gloss);
				
				return fixed4(diffuse + ambient + specular, 1.0);
			}

			ENDCG
		}
	}
	Fallback "Specular"
}