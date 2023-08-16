using UnityEngine;

/**
 * Script para Aplicar o efeito de Pixelização em tela.
 */
public class Pixelate : MonoBehaviour
{
    // Referencia do material de pixelização.
    [SerializeField] private Material pixelateMaterial;

    // Quando formos renderizar a imagem final...
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // Realizar um blit no gráfico com o material.
        Graphics.Blit(source, destination, pixelateMaterial);
    }
}
