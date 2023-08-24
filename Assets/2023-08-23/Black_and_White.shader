Shader "Unlit/Black_and_White"
{
    Properties
    {
        // We have to receive an input texture for this.
        _MainTex ("Main Texture", 2D) = "white" {}
        [KeywordEnum(A, B, C)] _Type ("Type", Float) = 0
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
            #pragma shader_feature _TYPE_A _TYPE_B _TYPE_C

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
            int _Type;

            // For our vertex shader, we just use the default.
            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // For our fragment shader, let's do our conversion.
            fixed4 frag (v2f input) : SV_Target
            {
                // This will be our result color, sampled from the texture.
                fixed4 result = tex2D(_MainTex, input.uv);
                
                #ifdef _TYPE_A
                // Use only Red Channel.
                result.b = result.g = result.r;
                #elif _TYPE_B
                // Calculate mean value.
                const fixed mean = (result.r + result.g + result.b) / 3.f;

                // Set as result.
                result.r = result.g = result.b = mean;
                #elif _TYPE_C
                // Modify with type C.
                float calc = result.r * 0.3f + result.g * 0.59f + result.b * 0.11f;

                // Set as result.
                result.r = result.g = result.b = calc;
                #endif
                
                // Return the color itself.
                return result;
            }
                            
            ENDCG
        }
    }
}
