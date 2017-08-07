Shader "MyShader/Stencil Test/Green"
{
	SubShader {
		Tags {
			"RenderType"="Opaque"
			//"Queue"="Geometry+1"
			"Queue"="Transparent+1"
		}

		Pass {
			Stencil {
				Ref 2
				Comp Equal
                Pass Keep 
                ZFail DecrWrap
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
				return float4(0,1,0,1);
			}
			ENDCG
		}
	}
}