Shader "2D/Custom/SpriteShockwaveEffect"
{
    Properties
    { 
        _MainTex("Texture", 2D) = "white" {}
        _SubTex ("Texture", 2D) = "white" {}
        _WaveCenter("Wave Center", Vector) = (0.5, 0.5, 0, 0)
        _WaveRadius("Wave Radius", Float) = 0.5
        _WaveIntensity("Wave Intensity", Float) = 0.1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _SubTex;
            float2 _WaveCenter;
            float _WaveRadius;
            float _WaveIntensity;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                // Dalga efekti hesaplamaları
                float dist = distance(i.uv, _WaveCenter);
                float wave = (sin(dist - _Time.y * _WaveRadius) + 1) * 0.5 * _WaveIntensity;

                // Renk ve dalga efektinin uygulanması
                float4 color = tex2D(_SubTex, i.uv + wave);
                return color;
            }
            ENDCG
        }
    }
}
