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

            // For our fragment shader, let's do our threshold.
            fixed4 frag (v2f input) : SV_Target
            {
                // This will be our result color, originally sampled from the texture.
                fixed4 result = tex2D(_MainTex, input.uv);

                // Calculate the range of the threshold.
                static const fixed _ThresholdRange = _Threshold / 255.f;

                // If any of our colors go through the threshold, it is white.
                if (result.r >= _ThresholdRange ||
                    result.g >= _ThresholdRange ||
                    result.b >= _ThresholdRange)
                        result.r = result.g = result.b = 1;
                else // Otherwise, its black.
                    result.r = result.g = result.b = 0;
                
                // Return the result.
                return result;
            }

            ENDCG
        }
    }
}