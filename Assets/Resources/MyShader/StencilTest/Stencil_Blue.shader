Shader "MyShader/Stencil Test/Blue"
{
	SubShader {
		Tags {
			"RenderType"="Opaque"
			//"Queue"="Geometry+2"
			"Queue"="Transparent+2"
		}

		Pass {
			Stencil {
				Ref 1
				Comp Equal
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct VertexInput {
				float4 vertex : POSITION;
			};

			struct VertexOutput {
				float4 pos : SV_POSITION;
			};

			VertexOutput vert(VertexInput v)
			{
				VertexOutput output;
				output.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				return output;
			}

			float4 frag(VertexOutput In) : SV_Target
			{
				return float4(0,0,1,1);
			}
			ENDCG
		}
	}
}