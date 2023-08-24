Shader "Unlit/ColorPallete"
{
    Properties
    {
        // We have to receive an input texture for this.
        _MainTex ("Main Texture", 2D) = "white" {}
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

            // For our vertex shader, we just use the default.
            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // Our Colors.
            static const fixed4 Colors[5] = {
                fixed4(35 / 255.f, 110 / 255.f, 150 / 255.f, 1.f),
                fixed4(21 / 255.f, 178 / 255.f, 211 / 255.f, 1.f),
                fixed4(255 / 255.f, 215 / 255.f, 0 / 255.f, 1.f),
                fixed4(243 / 255.f, 135 / 255.f, 47 / 255.f, 1.f),
                fixed4(255 / 255.f, 89 / 255.f, 143 / 255.f, 1.f)
            };

            // For our fragment shader, let's convert our color.
            fixed4 frag (v2f input) : SV_Target
            {
                // This will our result color, originally sampled from the texture.
                const fixed4 result = tex2D(_MainTex, input.uv);

                // The Color ID to Use and latest distance.
                int ColorID = 0;
                fixed Distance = distance(result, Colors[0]);

                // For each other color...
                for (int i = 1; i < 5; i++)
                {
                    // Calculate a new distance.
                    const fixed NewDist = distance(result, Colors[i]);

                    // If less...
                    if (NewDist < Distance)
                    {
                        // Update color ID and Distance.
                        ColorID = i;
                        Distance = NewDist;
                    }
                }
                
                // Return the result.
                return Colors[ColorID];
            }
            
            ENDCG
        }
    }
}