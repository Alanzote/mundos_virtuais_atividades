Shader "Unlit/Threshold"
{
    Properties
    {
        // We have to receive an input texture for this.
        _MainTex ("Main Texture", 2D) = "white" {}
        _Threshold ("Threshold", Range(0, 255)) = 200
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

            // Our Input.
            sampler2D _MainTex;
            fixed _Threshold;

            // For our vertex shader, we just use the default.
            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // Converts to Black and White our image.
            inline fixed ToBlackAndWhite(fixed4 Input)
            {
                // For demonstration purposes, we will use the Type C.
                return Input.r * 0.3f + Input.g * 0.59f + Input.b * 0.11f;
            }

            // For our fragment shader, let's do our threshold.
            fixed4 frag (v2f input) : SV_Target
            {
                // This will be our result color, originally sampled from the texture.
                fixed4 result = tex2D(_MainTex, input.uv);

                // Calculate the range of the threshold.
                static const fixed _ThresholdRange = _Threshold / 255.f;

                // Convert the color to Black and White for sampling.
                const fixed BW = ToBlackAndWhite(result);
                
                // Check for threshold, if pass, pixel is white.
                if (BW >= _ThresholdRange)
                    result.r = result.g = result.b = 1;
                else // Otherwise, pixel is black.
                    result.r = result.g = result.b = 0;
                
                // Return the result.
                return result;
            }

            ENDCG
        }
    }
}