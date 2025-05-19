Shader "Custom/ScreenSpaceDitherWithCustomShadow"
{
    Properties
    {
        _MainTex ("Render Texture", 2D) = "white" {}
        _DitherColor ("Dither Color", Color) = (0, 0, 0, 1)
        _DitherOpacity ("Dither Opacity", Range(0, 1)) = 0.5
        _DitherX ("Dither X Resolution", Float) = 100
        _DitherY ("Dither Y Resolution", Float) = 100
    }

    SubShader
    {
        Tags { "Queue" = "Overlay" }
        Pass
        {
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _DitherColor;
            float _DitherOpacity;
            float _DitherX;
            float _DitherY;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float shadowIntensity = col.r;

                float2 screenUV = i.pos.xy / i.pos.w;
                screenUV = screenUV * 0.5 + 0.5;

                float2 pixelCoord = floor(screenUV * float2(_DitherX, _DitherY));
                float checker = fmod(pixelCoord.x + pixelCoord.y, 2.0);

                if (shadowIntensity < 0.5)
                {
                    if (checker < 1.0)
                    {
                        col.rgb = lerp(col.rgb, _DitherColor.rgb, _DitherOpacity);
                    }
                }

                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
