Shader "MyShader/VertexLightTest"
{
	Properties {
		m_Color ("Main Color", COLOR) = (1,1,1,1)
	}

	SubShader {
		Pass {
			Material {
				//Diffuse (1,1,1,1)
				//Ambient (1,1,1,1)
				Diffuse [m_Color]
				Ambient [m_Color]
			}
			Lighting On
			//Color (1,1,1,1)
			//Color [m_Color]
		}
	}
}