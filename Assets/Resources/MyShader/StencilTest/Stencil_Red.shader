// With alpha
Shader "MyShader/Stencil Test/Red"
{
	SubShader {
		Tags {
			//"RenderType"="Opaque"
			//"Queue"="Geometry"
			"RenderType"="Transparent"
			"Queue"="Transparent"
		}

		Pass {
			Name "Red Stencil Pass"
			//Lighting Off

			Stencil {
				Ref 2

				// Comp parameters:
				// Greater 	Only render pixels whose reference value is greater than the value in the buffer.
				// GEqual 	Only render pixels whose reference value is greater than or equal to the value in the buffer.
				// Less 	Only render pixels whose reference value is less than the value in the buffer.
				// LEqual 	Only render pixels whose reference value is less than or equal to the value in the buffer.
				// Equal 	Only render pixels whose reference value equals the value in the buffer.
				// NotEqual Only render pixels whose reference value differs from the value in the buffer.
				// Always 	Make the stencil test always pass.
				// Never 	Make the stencil test always fail.
				Comp Always

				// Pass parameters:
				// Keep 	Keep the current contents of the buffer.
				// Zero 	Write 0 into the buffer.
				// Replace 	Write the reference value into the buffer.
				// IncrSat 	Increment the current value in the buffer. If the value is 255 already, it stays at 255.
				// DecrSat 	Decrement the current value in the buffer. If the value is 0 already, it stays at 0.
				// Invert 	Negate all the bits.
				// IncrWrap Increment the current value in the buffer. If the value is 255 already, it becomes 0.
				// DecrWrap Decrement the current value in the buffer. If the value is 0 already, it becomes 255.
				Pass Replace
			}

			// 最基本的透明处理
			Blend SrcAlpha OneMinusSrcAlpha

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
				return float4(1,0,0,0.5);
			}
			ENDCG
		}
	}
}