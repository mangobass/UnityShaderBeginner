Shader "MyShader/Standard Light Shader" {
	Properties {
		m_Diffuse("Diffuse", Color) = (1,1,1,1)
		m_Specular("Specular", Color) = (1,1,1,1)
		m_Gloss("Gloss", Range(8.0, 256)) = 20
	}

	SubShader{
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="Opaque"
        }
		Pass {
			Tags {
				"LightMode"="ForwardBase"
				//"LightMode"="ForwardAdd"
            }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
            #include "AutoLight.cginc"

			struct VertexOutput {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				// For lighting using. 
				float3 wPos : TEXCOORD1;
				float3 wNormalDir : TEXCOORD2;
				float3 wTangentDir : TEXCOORD3;
				float3 wBitangentDir : TEXCOORD4;
			};

			fixed4 m_Diffuse;
			fixed4 m_Specular;
			float m_Gloss;

			// Directional Light in game scene
            float4 _LightColor0;

            // ??? What ???
            float4 _TimeEditor;

			VertexOutput vert(appdata_tan v) {
				VertexOutput outData = (VertexOutput)0;
				outData.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				outData.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				outData.wNormalDir = normalize(UnityObjectToWorldNormal(v.normal));
				//outData.wNormalDir = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				outData.wTangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 1))).xyz;
				//outData.wTangentDir = normalize(mul(unity_ObjectToWorld, v.tangent)).xyz;
				outData.wBitangentDir = normalize(cross(outData.wNormalDir, outData.wTangentDir)*v.tangent.w);
				return outData;
			}

			float4 frag(VertexOutput IN) : COLOR {
				// 计算平行光对物体的影响--PS:没有点光源的情况下
				float3 wLightingDir = normalize(_WorldSpaceLightPos0.xyz);
				float NDotI = saturate(dot(IN.wNormalDir, wLightingDir));
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz-IN.wPos);

				// Diffuse:（通常用Texture来代替diffuse的颜色）
				//float3 diffColor = _LightColor0.rgb * m_Diffuse.rgb*NDotI;
				// Half Lambert 光照模型
				float3 diffColor = _LightColor0.rgb * m_Diffuse.rgb*(0.5*NDotI+0.5);

				// Specular: (Phong模型计算高光反射)
				// reflect(): 入射方向要求是由光源指向交点处，需对世界光方向取反
				//fixed3 reflectDir = normalize(reflect(-wLightingDir, IN.wNormalDir));
				//fixed3 specular = _LightColor0.rgb*m_Specular.rgb*pow(saturate(dot(reflectDir, viewDir)), m_Gloss);

				// Specular: (Blinn-Phong模型计算高光反射)
				// 仅适用于平行光的场合
				fixed3 halfDir = normalize(wLightingDir+viewDir);
				fixed3 BPSpecular = _LightColor0*m_Specular*pow(max(0, dot(IN.wNormalDir, halfDir)), m_Gloss);

				// Emissive:


                // 获得Lighting中设置的AMBIENT光源
                float3 ambientLightColor = UNITY_LIGHTMODEL_AMBIENT.xyz;

                return float4(diffColor + ambientLightColor + specular, 1);
                return float4(diffColor + ambientLightColor + BPSpecular, 1);
				//return float4(lightEffColor*m_LightEffectDelta + m_MainColor.rgb*(1-m_LightEffectDelta), 1);
			}

			ENDCG
		}

	}
}