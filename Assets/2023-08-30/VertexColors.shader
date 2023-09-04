Shader "Unlit/Vertex_Colors"
{
    Properties
    {
        // We don't have to receive anything as we will just sample vertex colors.
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            // For our vertex shader, we just use the default.
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                return o;
            }

            // For our fragment shader, let's do our visualization.
            fixed4 frag (v2f input) : SV_Target
            {
                // Return the vertex color.
                return input.color;
            }
            
            ENDCG
        }
    }
}