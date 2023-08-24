Shader "Unlit/Intensity"
{
    Properties
    {
        // We have to receive an input texture for this.
        _MainTex ("Main Texture", 2D) = "white" {}
        _Multiplier ("Multiplier", Range(0, 10)) = 1
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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // Our Texture input.
            sampler2D _MainTex;
            float _Multiplier;

            // For our vertex shader, we just use the default.
            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // For our fragment shader, let's do our conversation.
            fixed4 frag (v2f input) : SV_Target
            {
                // Fetch the texture color.
                fixed4 result = tex2D(_MainTex, input.uv);

                // Multiply each channel.
                result.r *= _Multiplier;
                result.g *= _Multiplier;
                result.b *= _Multiplier;

                // Return the color itself.
                return result;
            }

            ENDCG
        }
    }
}