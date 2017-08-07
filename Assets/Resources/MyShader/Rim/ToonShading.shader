Shader "MyShader/Rim/Toon Shading" {
	Properties {
		_Color("Color Tint", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white" {}
		// 漫反射色调的渐变纹理
		_Ramp("Ramp Texture", 2D) = "white" {}
		_Outline("Outline", Range(0, 1)) = 0.1
		_OutlineColor("Outline Color", Color) = (0,0,0,1)
		_Specular("Specular", Color) = (1,1,1,1)
		// 高光反射的阈值
		_SpecularScale("Specular Scale", Range(0, 0.1)) = 0.01
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry" }

		Pass {
			NAME "MYOUTLINE"
			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float _Outline;
			float4 _OutlineColor;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
			};

			v2f vert(a2v v)
			{
				v2f o;
				float4 pos = mul(UNITY_MATRIX_MV, v.vertex);
				float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				// 设置法线的z分量
				normal.z = -0.5;
				pos = pos + float4(normalize(normal), 0) * _Outline;
				o.pos = mul(UNITY_MATRIX_P, pos);

				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				return float4(_OutlineColor.rgb, 1.0);
			}
			ENDCG
		}

		Pass {
			Tags { "LightMode"="ForwardBase" }
			Cull Back

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			#include "Lighting.cginc"
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			//#include "UnityShaderVariables.cginc"

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _Ramp;
			float4 _Ramp_ST;
			float4 _Specular;
			float _SpecularScale;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				SHADOW_COORDS(3)
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 worldHalfDir = normalize(worldLightDir+worldViewDir);

				fixed4 color = tex2D(_MainTex, i.uv);
				fixed3 albedo = color.rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

				fixed diff = dot(worldNormal, worldLightDir);
				diff = (diff*0.5 + 0.5) * atten;
				fixed3 diffuse = _LightColor0.rgb * albedo * tex2D(_Ramp, float2(diff, diff)).rgb;

				fixed spec = dot(worldNormal, worldHalfDir);
				// 对高光区域的边界进行抗锯齿处理
				fixed w = fwidth(spec)*2.0;
				// step(p1,p2): p2 > p1 ? 1 : 0
				fixed3 specular = _Specular.rgb * lerp(0 , 1,
					smoothstep(-w, w, spec+_SpecularScale-1)) * step(0.0001, _SpecularScale);

				return fixed4(ambient+diffuse+specular, 1.0);
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
