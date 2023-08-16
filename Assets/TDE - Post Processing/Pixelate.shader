// Definimos a Shader...
Shader "PostProcess/Pixelate"
{
    Properties
    {
        // Temos a textura de entrada direto do Unity.
        _MainTex ("Base (RGB)", 2D) = "white" {}
        
        // E a resolução final que vamos utilizar.
        _Resolution ("Resolution", float) = 100
    }
    
    // Monta um Shader...
    SubShader
    {
        // Com apenas um passo.
        Pass
        {
            // Inicia o programa.
            CGPROGRAM

            #include "UnityCG.cginc"

            // Define as funções de vértice e fragment.
            #pragma vertex vert_img
            #pragma fragment frag

            // Nossos parâmetros.
            uniform sampler2D _MainTex;
            float _Resolution;

            // Função fragment.
            fixed4 frag(v2f_img i) : COLOR {
                // Calculamos a posição do UV para a textura final.
                // Com base na resolução, multiplicamos o nosso UV
                // mas arrendondado.
                // Aí dividimos pela resolução.
                return tex2D(_MainTex, round(i.uv * _Resolution) / _Resolution);
            }

            // Finaliza o programa.
            ENDCG
        }
    }
}