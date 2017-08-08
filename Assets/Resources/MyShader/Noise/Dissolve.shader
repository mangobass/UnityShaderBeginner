Shader "MyShader/Noise/Dissolve" {
	properties {
		// 控制消融程度 0：物体正常 1：物体完全消融
		_BurnAmount("Burn Amount", Range(0.0, 1.0)) = 0.0
		// 控制模拟烧焦效果时的线宽，值越大，火焰边缘蔓延范围越广
		_LineWidth("Burn Line Width", Range(0.0, 0.2)) = 0.1
		_MainTex("Base (RGB)", 2D) = "white" {}
		_BumpMap("Normal Map", 2D) = "bump" {}
		_BurnFirstColor("Burn 1st Color", Color) = (1,0,0,1)
		_BurnSecondColor("Burn 2nd Color", Color) = (1,0,0,1)
		// 噪声纹理
		_BurnMap("Burn Map", 2D) = "white" {}
	}
	SubShader {
		Pass {
			Tags { "LightMode"="ForwardBase" }
			Cull Off

			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			float _BurnAmount;
			float _LineWidth;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float4 _BurnFirstColor;
			float4 _BurnSecondColor;
			sampler2D _BurnMap;
			float4 _BurnMap_ST;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uvMainTex : TEXCOORD0;
				float2 uvBumpMap : TEXCOORD1;
				float2 uvBurnMap : TEXCOORD2;
				float3 lightDir : TEXCOORD3;
				float3 worldPos : TEXCOORD4;
				SHADOW_COORDS(5)
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uvMainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uvBumpMap = TRANSFORM_TEX(v.texcoord, _BumpMap);
				o.uvBurnMap = TRANSFORM_TEX(v.texcoord, _BurnMap);

				TANGENT_SPACE_ROTATION;
				o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex));
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 burn = tex2D(_BurnMap, i.uvBurnMap).rgb;
				// 小于0剔除
				clip(burn.r - _BurnAmount);

				float3 tangentLightDir = normalize(i.lightDir);
				float3 tangentNormal = UnpackNormal(tex2D(_BumpMap, i.uvBumpMap));
				fixed3 albedo = tex2D(_MainTex, i.uvMainTex).rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				fixed3 diffuse = _LightColor0.rgb*albedo*max(0, dot(tangentNormal, tangentLightDir));

				fixed t = 1 - smoothstep(0.0, _LineWidth, burn.r-_BurnAmount);
				fixed3 burnColor = lerp(_BurnFirstColor, _BurnSecondColor, t);
				burnColor = pow(burnColor, 5);

				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
				fixed3 finalColor = lerp(ambient+diffuse*atten, burnColor, t*step(0.0001, _BurnAmount));

				return fixed4(finalColor, 1.0);
			}
			ENDCG
		}

		Pass {
			Tags { "LightMode"="ShadowCaster" }
			CGPROGRAM
			#pragma multi_compile_shadowcaster
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			sampler2D _BurnMap;
			float4 _BurnMap_ST;
			float _BurnAmount;

			struct v2f {
				V2F_SHADOW_CASTER;
				float2 uvBurnMap : TEXCOORD1;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				o.uvBurnMap = TRANSFORM_TEX(v.texcoord, _BurnMap);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 burn = tex2D(_BurnMap, i.uvBurnMap).rgb;
				// 小于0剔除
				clip(burn.r - _BurnAmount);
			
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
	}
	Fallback Off
}