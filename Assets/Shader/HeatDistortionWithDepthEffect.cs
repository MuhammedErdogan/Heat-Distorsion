using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class HeatDistortionWithDepthEffect : MonoBehaviour
{
    public Material heatDistortionMaterial;
    public float distortion = 0.1f;
    public float speed = 1f;
    private Camera camera;

    void Start()
    {
        camera = GetComponent<Camera>();
        camera.depthTextureMode = DepthTextureMode.Depth;
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (heatDistortionMaterial != null)
        {
            heatDistortionMaterial.SetFloat("_Distortion", distortion);
            heatDistortionMaterial.SetFloat("_Strength", speed);
            Graphics.Blit(src, dest, heatDistortionMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}