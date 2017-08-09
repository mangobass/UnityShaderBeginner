Shader "MyShader/Noise/WaterWave" {
	Properties {
		_Color("Main Color", Color) = (0, 0.15, 0.115, 1)
		_MainTex("Base (RGB)", 2D) = "white"{}
		_WaveMap("Wave Map", 2D) = "bump"{}
		_Cubemap("Environment Cubemap", Cube) = "_Skybox"{}
		_WaveXSpeed("Wave Horizontal Speed", Range(-0.1, 0.1)) = 0.01
		_WaveYSpeed("Wave Vertical Speed", Range(-0.1, 0.1)) = 0.01
		_Distortion("Distortion", Range(0, 100)) = 10
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Opaque" }
		// 抓取屏幕图像的pass
		// GrabPass{}：直接使用_GrabTexture来访问屏幕图像。
		//             每次使用都会抓取图像，消耗大，优点：可以获取不一样的截图
		// GrabPass{ "_RefractionTex" } 只在第一次使用时抓图，消耗小，缺点：图一样。
		GrabPass{ "_RefractionTex" }

		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _WaveMap;
			float4 _WaveMap_ST;
			samplerCUBE _Cubemap;
			float _WaveXSpeed;
			float _WaveYSpeed;
			float _Distortion;
			sampler2D _RefractionTex;
			float4 _RefractionTex_TexelSize;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 TtoW0 : TEXCOORD1;
				float4 TtoW1 : TEXCOORD2;
				float4 TtoW2 : TEXCOORD3;
				float4 scrPos : TEXCOORD4;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _WaveMap);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

				// Calculate Tangent to World matrix.
				o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
				// 对应被抓取的屏幕图像的采样坐标（UnityCG.cginc）
				o.scrPos = ComputeGrabScreenPos(o.pos);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				float2 speed = _Time.y*float2(_WaveXSpeed, _WaveYSpeed);

				fixed3 bump1 = UnpackNormal(tex2D(_WaveMap, i.uv.zw+speed)).rgb;
				fixed3 bump2 = UnpackNormal(tex2D(_WaveMap, i.uv.zw-speed)).rgb;
				fixed3 bump = normalize(bump1 + bump2);

				// Compute the offset in tangent space.
				float2 offset = bump.xy*_Distortion*_RefractionTex_TexelSize.xy;
				// 模拟深度越大，折射程度越大的效果
				i.scrPos.xy += offset*i.scrPos.z;
				//i.scrPos.xy += offset;
				// 用偏移后的坐标对折射texture进行采样
				fixed3 refrColor = tex2D(_RefractionTex, i.scrPos.xy/i.scrPos.w).rgb;

				bump = normalize(half3(dot(i.TtoW0.xyz, bump), dot(i.TtoW1.xyz, bump), dot(i.TtoW2.xyz, bump)));
				fixed3 reflDir = reflect(-worldViewDir, bump);
				fixed4 texColor = tex2D(_MainTex, i.uv.xy+speed);
				fixed3 reflColor = texCUBE(_Cubemap, reflDir).rgb*texColor.rgb*_Color.rgb;

				// pow(1-max(0, v点n), 4)
				fixed fresnel = pow(1-saturate(dot(worldViewDir,bump)), 4);
				fixed3 finalColor = lerp(refrColor, reflColor, fresnel);

				return fixed4(finalColor, 1.0);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
