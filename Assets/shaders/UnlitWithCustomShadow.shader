Shader "Custom/UnlitWithCustomShadow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ShadowColor ("Shadow Color", Color) = (0, 0, 0, 1)
        _ShadowOpacity ("Shadow Opacity", Range(0, 1)) = 0.8
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM
        #pragma surface surf UnlitCustomShadow addshadow

        sampler2D _MainTex;
        float4 _ShadowColor;
        float _ShadowOpacity;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        // Custom lighting function for shadow manipulation
        inline half4 LightingUnlitCustomShadow(SurfaceOutput s, half3 lightDir, half atten)
        {
            half3 shadowColor = lerp(s.Albedo, _ShadowColor.rgb, _ShadowOpacity);
            half3 finalColor = lerp(s.Albedo, shadowColor, 1.0 - atten);
            return half4(finalColor, s.Alpha);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
