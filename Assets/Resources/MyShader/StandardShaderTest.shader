Shader "MyShader/standardTest" {
	Properties {
		m_MainTexture("MainTexture", 2D) = "white"{}
		m_SubTexture("MainTexture", 2D) = "red"{}
		m_Color("MainColor", Color) = (0.4, 0.54, 0.8, 0.7)

		//m_Normal("Normal", 2D) = "bump"{}
		//m_Specular("Specular", 2D) = "black"{}
	}

	SubShader {
		Tags {
			"Queue"="Transparent"
			"RenderType"="Transparent"
			"IgnoreProjector"="True"
		} // End Tags
		LOD 200

		Pass {
			// Cull Param: Front Back Off. Default is Cull Back
			//Cull Off

//			Stencil {
//				// 设置参照值为2
//				Ref 2
//				Comp always
//				Pass replace
//			}
			
			ZWrite Off

			// AlphaTest Param: Greater GEqual Less LEqual Equal
			//                  NotEqual Always Never
			//AlphaTest Less 0.5

			// Blend Param: One Zero SrcColor SrcAlpha DstColor DstAlpha
			//              OneMinusSrcColor OneMinusSrcAlpha
			//              OneMinusDstColor OneMinusDstAlpha
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
            #include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			//#pragma multi_compile_fwdbase

			uniform sampler2D m_MainTexture;
			// m_MainTexture_ST是给TRANSFORM_TEX宏使用的
			//uniform fixed4 m_MainTexture_ST;
			uniform sampler2D m_SubTexture;
			fixed4 m_Color;


			struct VertexInput {
				fixed4 vertex : POSITION;
				fixed2 uv : TEXCOORD0;
			};

			struct VertexOutput {
				fixed4 pos : SV_POSITION;
				fixed2 uv : TEXCOORD0;
			};

			VertexOutput vert(VertexInput v) {
				VertexOutput output;
				//output.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				output.pos = UnityObjectToClipPos(v.vertex);
				output.uv = v.uv;
				return output;
			}

			fixed4 frag(VertexOutput i) : COLOR {
				//fixed4 mainColor = tex2D(m_MainTexture, TRANSFORM_TEX(i.uv, m_MainTexture));
				fixed4 mainColor = tex2D(m_MainTexture, i.uv);
				return fixed4(mainColor.rgb, 0.5);
				//return m_Color;
			}

			ENDCG
		} // End Pass


	} // End SubShader

    FallBack "Diffuse"
}
