Shader "Unlit/CMYK_to_RGB"
{
    Properties
    {
        // We'll be converting the HSV format to RGB so it uses a color.
        // Let's define the parameters separately so we can follow the code.
        _Hue ("Hue", Range(0, 1)) = 0
        _Saturation ("Saturation", Range(0, 1)) = 0
        _Value ("Value", Range(0, 1)) = 0
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
            float _Hue;
            float _Saturation;
            float _Value;
            
            // For our vertex shader, we just use the default.
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
            
            // For our fragment shader, let do our conversion.
            fixed4 frag (v2f input) : SV_Target
            {
                // This will be our result color
                fixed4 result;

                // Grab some results for calculation.
                float i = floor(_Hue * 6);
                float f = _Hue * 6 - i;
                float p = _Value * (1 - _Saturation);
                float q = _Value * (1 - f * _Saturation);
                float t = _Value * (1 - (1 - f) * _Saturation);
                
                // Convert the RGB.
                switch (i % 6) {
                    case 0: result.r = _Value, result.g = t, result.b = p; break;
                    case 1: result.r = q, result.g = _Value, result.b = p; break;
                    case 2: result.r = p, result.g = _Value, result.b = t; break;
                    case 3: result.r = p, result.g = q, result.b = _Value; break;
                    case 4: result.r = t, result.g = p, result.b = _Value; break;
                    case 5: result.r = _Value, result.g = p, result.b = q; break;
                }

                // Our Alpha is always 1.
                result.a = 1;

                // Return the color itself.
                return result;
            }
            ENDCG
        }
    }
}
