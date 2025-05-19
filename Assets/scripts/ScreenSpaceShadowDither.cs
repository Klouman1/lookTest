using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class ScreenSpaceShadowDither : MonoBehaviour
{
    public Material ditherMaterial;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (ditherMaterial != null)
        {
            Graphics.Blit(src, dest, ditherMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
