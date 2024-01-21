Shader "Hidden/Custom/MultiShockwaveRing"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Center ("Center", Vector) = (0.5,0.5,0,0)
        _StartTime1 ("Start Time 1", Float) = 0.0
        _Speed1 ("Speed 1", Float) = 1.0
        _StartTime2 ("Start Time 2", Float) = 0.5
        _Speed2 ("Speed 2", Float) = 1.0
        _StartTime3 ("Start Time 3", Float) = 1.0
        _Speed3 ("Speed 3", Float) = 1.0
        _WaveWidth ("Wave Width", Float) = 0.1
        _WaveStrength ("Wave Strength", Float) = 0.1
        _MaxRadius ("Max Radius", Float) = 1.0
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float2 _Center;
            float _StartTime1, _StartTime2, _StartTime3;
            float _Speed1, _Speed2, _Speed3;
            float _WaveWidth, _WaveStrength, _MaxRadius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float ComputeWave(float2 uv, float startTime, float speed)
            {
                float dist = length(uv - _Center);
                float time = startTime;
                float currentRadius = time * speed;

                float wave = smoothstep(currentRadius - _WaveWidth, currentRadius, dist) - smoothstep(currentRadius, currentRadius + _WaveWidth, dist);
                wave *= _WaveStrength;

                return wave;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Hesaplamaları yap
                float wave1 = ComputeWave(i.uv, _StartTime1, _Speed1);
                float wave2 = ComputeWave(i.uv, _StartTime2, _Speed2);
                float wave3 = ComputeWave(i.uv, _StartTime3, _Speed3);

                // Toplam dalgayı hesapla ve UV'yi ayarla
                float totalWave = wave1 + wave2 + wave3;
                float2 newUV = i.uv + (totalWave * normalize(i.uv - _Center));

                // Texture'ı yeni UV koordinatlarıyla örnekleyin
                fixed4 col = tex2D(_MainTex, newUV);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
