// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

//=============================================================================
// Desc: 多光源的前向渲染
//       Blinn-Phong光照模型
//       本例假设没有自发光效果
//=============================================================================
Shader "MyShader/Lighting/Forward Rendering" {
	properties {
		_Diffuse("Diffuse", Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	SubShader {
		Pass {
			// Pass Base: 计算环境光和平行光 
			Tags { "LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#include "Lighting.cginc"

			float4 _Diffuse;
			float4 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 worldNormal = normalize(i.worldNormal);
				//fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 diffuse = _LightColor0.rgb * _Diffuse * max(0, dot(worldNormal, worldLightDir));

			 	fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				fixed attenuation = 1.0;
				return fixed4(ambient + (diffuse+specular) * attenuation , 1.0);
			}

			ENDCG
		}

		Pass {
			Tags { "LightMode" = "ForwardAdd" }
			// 不加Blend，这个Pass Additional的光照结果会覆盖Pass Bass的光照结果
			// 用Blend就是要两者相加
			Blend One One
			//Blend SrcAlpha One

			CGPROGRAM
			#pragma multi_compile_fwdadd
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			float4 _Diffuse;
			float4 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 worldNormal = normalize(i.worldNormal);
#ifdef USING_DIRECTIONAL_LIGHT
				//fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
#else
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz-i.worldPos.xyz);
#endif

				fixed3 diffuse = _LightColor0.rgb * _Diffuse * max(0, dot(worldNormal, worldLightDir));

			 	fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

#ifdef USING_DIRECTIONAL_LIGHT
				fixed atten = 1.0;
#else
				#ifdef POINT
					float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1.0)).xyz;
					// UNITY_ATTEN_CHANNEL是衰减值所在的纹理通道，
					// 可以在内置的HLSLSupport.cginc文件中查看。
					// 一般PC和主机平台的话UNITY_ATTEN_CHANNEL是r通道，移动平台的话是a通道
					fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				#endif
				#ifdef SPOT
					float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1.0)).xyz;
				    fixed atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				#endif
#endif

				return fixed4((diffuse+specular) * atten , 1.0);
			}

			ENDCG
		}
	}
	Fallback "Specular"
}