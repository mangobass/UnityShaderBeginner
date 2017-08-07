Shader "MyShader/Standard Light Shader" {
	Properties {
		m_MainTexture("MainTexture", 2D) = "black"{}
		m_NormalTexture("NormalTexture", 2D) = "bump"{}
		m_MainColor("MainColor", Color) = (0.5,0.5,0.5,1)
		m_WaveAmplitude("WaveAmplitude", range(1, 10)) = 1
		m_LightEffectDelta("Lighting Delta", range(0,1)) =0.5
		m_Diffuse("Diffuse", Color) = (1,1,1,1)

	}

	SubShader{
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="Opaque"
       }
		Pass {
			Name "UV ANIM"
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

			sampler2D m_MainTexture;
			// xy:tiling.xy   zw:offset.xy
			float4 m_MainTexture_ST;

			sampler2D m_NormalTexture;
			float4 m_NormalTexture_ST;

			float4 m_MainColor;
			float m_WaveAmplitude;
			float m_LightEffectDelta;
			float4 m_Diffuse;

			// Directional Light in game scene
            float4 _LightColor0;

            // ??? What ???
            float4 _TimeEditor;

			VertexOutput vert(appdata_tan v) {
				VertexOutput outData = (VertexOutput)0;
				outData.uv = v.texcoord;
				float4 time = _Time + _TimeEditor;

				float2 newUV = (v.texcoord.xy*2.0-1.0)+float2(1, -1)*time.x;
               	float4 waveTex = tex2Dlod(m_MainTexture, float4(TRANSFORM_TEX(newUV, m_MainTexture), 0.0, 0.0));
				float3 combineRes = m_WaveAmplitude * float3(0,1,0)*dot(waveTex.rgb,float3(0.3,0.4,0.5));
				v.vertex.rgb += combineRes;
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
				m_MainTexture_ST.x += sin(10*_Time);
#if defined (UV_ANIMATION)
				// uv Animation.
				float newU = IN.uv.x - 0.5*_Time;
				float2 newUV = float2(newU, IN.uv.y);
#else
				float2 newUV = IN.uv;
#endif

				float3 normalTex = UnpackNormal(tex2D(m_NormalTexture, TRANSFORM_TEX(newUV, m_NormalTexture)));
				
				// 计算平行光对物体的影响--PS:没有点光源的情况下
				float3 dLightingDir = normalize(_WorldSpaceLightPos0.xyz);
				float dotNum = saturate(dot(IN.wNormalDir, dLightingDir));

				// Gloss(光泽, 色泽; 虚饰, 假像):
                float gloss = 0.5;
                float specPow = exp2( gloss * 10.0+1.0);

				// Specular: （Blinn-Phong模型）

				

				// Diffuse:
				//float3 diffColor = _LightColor0.rgb * m_Diffuse.rgb*dotNum;
				float3 diffColor = _LightColor0.rgb * m_Diffuse.rgb*(0.5*dotNum+0.5);
				// Emissive:


                // 获得Lighting中设置的AMBIENT光源
                float3 ambientLightColor = UNITY_LIGHTMODEL_AMBIENT.xyz;

                return float4(diffColor + ambientLightColor, 1);
				//return float4(lightEffColor*m_LightEffectDelta + m_MainColor.rgb*(1-m_LightEffectDelta), 1);
			}

			ENDCG
		}

	}
}