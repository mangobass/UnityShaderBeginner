//=============================================================================
// Desc: Empriacial菲涅尔反射shader
//=============================================================================
Shader "MyShader/Reflection/Fresnel Reflection(empriacial)" {
	properties {
		_Color ("Color Tint", Color) = (1,1,1,1)
		_FresnelScale("Fresnel Scale", Range(0,1)) = 0.5
		_FresnelBias("Fresnel Bias", Range(0,1)) = 0.5
		_FresnelPower("Fresnel Power", Range(2,10)) = 5
		_Cubemap("Reflection Cubemap", Cube) = "_Skybox"{}
	}
	SubShader {
		Tags { "Queue" = "Geometry" "RenderType"="Opaque"}
		Pass {
			Tags { "LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			float4 _Color;
			fixed _FresnelScale;
			fixed _FresnelBias;
			fixed _FresnelPower;
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
				float3 worldRefl : TEXCOORD3;
				SHADOW_COORDS(4)
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
				o.worldRefl = reflect(-o.worldViewDir, o.worldNormal);
				TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target 
			{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldViewDir = normalize(i.worldViewDir);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 reflection = texCUBE(_Cubemap, i.worldRefl).rgb;

				fixed3 diffuse = _LightColor0.rgb * _Color * max(0, dot(worldNormal, worldLightDir));

				// 使用Empriacial菲涅尔近似等式(其中bias值趋向1为反射效果。)
				fixed fresnel = max(0, min(1, _FresnelBias + _FresnelScale*pow((1-dot(worldViewDir, worldNormal)), _FresnelPower)));

				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

				fixed3 color = ambient + lerp(diffuse, reflection, saturate(fresnel)) * atten;

				return fixed4(color, 1.0);
			}

			ENDCG
		}
	}
}