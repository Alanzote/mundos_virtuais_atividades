Shader "Unlit/CMYK_to_RGB"
{
    Properties
    {
        // We'll be converting the CMYK format to RGB so it uses a color.
        // Let's define the parameters separately so we can follow the code.
        _Cyan ("Cyan", Range(0, 1)) = 0
        _Magenta ("Magenta", Range(0, 1)) = 0
        _Yellow ("Yellow", Range(0, 1)) = 0
        _Key ("Key (Black)", Range(0, 1)) = 1
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            // Let's define again our input colors.
            float _Cyan;
            float _Magenta;
            float _Yellow;
            float _Key;
            
            // For our vertex shader, we just use the default.
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
            
            // For our fragment shader, let do our conversion.
            fixed4 frag (v2f i) : SV_Target
            {
                // This will be our result color
                fixed4 result;

                // Let's calculate the black channel.
                float KeyChannel = 1 - _Key;
                
                // Convert the RGB.
                result.r = (1 - _Cyan) * KeyChannel;
                result.g = (1 - _Magenta) * KeyChannel;
                result.b = (1 - _Yellow) * KeyChannel;

                // Our Alpha is always 1.
                result.a = 1;

                // Return the color itself.
                return result;
            }
            ENDCG
        }
    }
}
