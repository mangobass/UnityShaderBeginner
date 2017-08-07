//=============================================================================
// Desc: 基础折射shader
//=============================================================================
Shader "MyShader/Refraction/Refraction Shader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_RefractColor("Refraction Color", Color) = (1,1,1,1)
		_RefractAmount("Refraction Amount", Range(0, 1)) = 1
		_RefractRadio("Refraction Radio", Range(0.1, 1)) = 0.5
		_Cubemap("Refraction Cubemap", Cube) = "_Skybox"{}
	}
	SubShader {
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque"}
		Pass {
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			float4 _Color;
			float4 _RefractColor;
			float _RefractAmount;
			float _RefractRadio;
			samplerCUBE _Cubemap;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldPos : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float3 worldViewDir : TEXCOORD2;
				float3 worldRefr : TEXCOORD3;
				SHADOW_COORDS(4)
			};

			v2f vert(a2v v)
			{
				v2f o;

				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
				// refract: 计算折射方向
				// Param1: 入射光线的方向(需要归一化) 
				// Param2: 表面法线(需要归一化)
				// Param3: 入射光线和折射光线所在介质的比值
				o.worldRefr = refract(-normalize(o.worldViewDir), normalize(o.worldNormal), _RefractRadio);
				TRANSFER_SHADOW(o);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = UnityWorldSpaceLightDir(i.worldPos);
				fixed3 worldViewDir = normalize(i.worldViewDir);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;
				fixed3 diffuse = _LightColor0.rgb * _Color * max(0, dot(worldNormal, worldLightDir));

				// 通过折射方向对cubemap进行采样
				fixed3 refraction = texCUBE(_Cubemap, i.worldRefr).rgb * _RefractColor.rgb;
				
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
				fixed3 color = ambient + lerp(diffuse, refraction, _RefractAmount) * atten;

				return fixed4(color, 1.0);
			}

			ENDCG
		}
	}
}
