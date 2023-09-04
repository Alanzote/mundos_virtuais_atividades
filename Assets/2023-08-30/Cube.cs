using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

/**
 * Script para Realizar o Desafio.
 */
[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class Cube : MonoBehaviour
{
    // Referência de nossos components.
    private MeshFilter _meshFilter;
    private MeshRenderer _meshRenderer;
    
    // Velocidade de rotação.
    [SerializeField, Min(0)] private float rotationSpeed;

    // Tamanho do Cubo.
    [SerializeField, Min(0)] private float cubeSize;
    
    // Cores das Faces do Cubo.
    [SerializeField] private Color[] cubeColors =
    {
        Color.red,
        Color.cyan,
        Color.blue,
        Color.yellow,
        Color.magenta,
        Color.cyan
    };
    
    // Todas as direções das faces de um cubo.
    private static readonly Vector3[] AllCubeDirections =
    {
        Vector3.forward,
        Vector3.back,
        Vector3.left,
        Vector3.right,
        Vector3.up,
        Vector3.down
    };
    
    // On Awake.
    private void Awake()
    {
        // Preencher componentes.
        _meshFilter = GetComponent<MeshFilter>();
        _meshRenderer = GetComponent<MeshRenderer>();
    }
    
    // Cria uma face para nós dado uma direção, tamanho e o offset.
    private Tuple<Vector3[], int[]> CreateFace(Vector3 dir, float size, float offset)
    {
        // Precisamos ter certeza que a direção está normalizada.
        dir.Normalize();
        
        // E calculamos um vetor esquerda para o nosso plano.
        var right = 
            Vector3.Cross(Mathf.Abs(dir.y) < 1 ? Vector3.up : Vector3.forward, dir).normalized;

        // Com o vetor esquerda, calculamos um novo vetor cima com a direção.
        var up = Vector3.Cross(dir, right).normalized;

        // Calculamos o offset do centro.
        var centerOffset = dir.normalized * offset;

        // Criamos o nosso plano.
        return Tuple.Create(
            new []
            {
                // Top-left.
                centerOffset + 0.5f * size * (-right + up),
                
                // Top-right.
                centerOffset + 0.5f * size * (right + up),
                
                // Bottom-left.
                centerOffset + 0.5f * size * (right - up),
                
                // Bottom-right.
                centerOffset + 0.5f * size * (-right - up)
            },
            new []
            {
                // Ligmos os pontos a favor do relógio.
                2, 1, 0,
                3, 2, 0
            }
        );
    }

    // On Start.
    private void Start()
    {
        // Não executar se o tamanho do cubo é inválido.
        if (cubeSize <= 0)
            return;
        
        // Criar o mesh.
        Mesh cubeMesh = new Mesh();

        // Variáveis necessárias para o nosso cubo.
        var offset = cubeSize * 0.5f;
        var vertices = new List<Vector3>();
        var triangles = new List<int>();
        var colors = new List<Color>();

        // Para cada direção...
        for (var d = 0; d < AllCubeDirections.Length; d++)
        {
            // Criamos a face.
            var dirPlane = CreateFace(AllCubeDirections[d], cubeSize, offset);
            
            // Adicionamos os vértices, triângulos e cores.
            vertices.AddRange(dirPlane.Item1);
            triangles.AddRange(dirPlane.Item2.Select(x => d * 4 + x));
            colors.AddRange(Enumerable.Repeat(cubeColors[d], 4));
        }

        // Preparamos as variáveis.
        cubeMesh.vertices = vertices.ToArray();
        cubeMesh.triangles = triangles.ToArray();
        cubeMesh.colors = colors.ToArray();
        
        // Trocar o Mesh.
        _meshFilter.mesh = cubeMesh;
    }

    // Chamado a cada Frame.
    void Update()
    {
        // Buscar Entrada dos Eixos.
        float X = Convert.ToSingle(Input.GetKey(KeyCode.D)) - Convert.ToSingle(Input.GetKey(KeyCode.A));
        float Y = Convert.ToSingle(Input.GetKey(KeyCode.S)) - Convert.ToSingle(Input.GetKey(KeyCode.W));
        
        // Rotacionar o objecto.
        transform.Rotate(X * Time.deltaTime * rotationSpeed, Y * Time.deltaTime * rotationSpeed, 0);
    }
}
