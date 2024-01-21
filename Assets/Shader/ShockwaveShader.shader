Shader "Hidden/Custom/CorrectedShockwaveRing"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Center ("Center", Vector) = (0.5,0.5,0,0)
        _StartTime ("Start Time", Float) = 0.0
        _Speed ("Speed", Float) = 1.0
        _WaveWidth ("Wave Width", Float) = 0.1
        _WaveStrength ("Wave Strength", Float) = 0.1
        _MaxRadius ("Max Radius", Float) = 1.0
        _DistortionStrength ("Distortion Strength", Float) = 0.02
        _DistortionColor ("Distortion Color", Color) = (1,1,1,1)
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
            float _StartTime;
            float _Speed;
            float _WaveWidth;
            float _WaveStrength;
            float _MaxRadius;
            float _DistortionStrength;
            float4 _DistortionColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Ekranın en-boy oranını düzeltecek şekilde UV'yi ölçeklendir
                float aspectRatio = _ScreenParams.y / _ScreenParams.x;
                float2 scaledUV = float2(i.uv.x, i.uv.y * aspectRatio);

                // Merkez noktasını da aynı şekilde ölçeklendir
                float2 scaledCenter = float2(_Center.x, _Center.y * aspectRatio);

                // UV koordinatlarından merkeze olan mesafeyi hesapla
                float2 uv = scaledUV - scaledCenter;
                float dist = length(uv);

                // Geçen süre ve dalganın genişlemesi
                //float time = _Time - _StartTime;
                float currentRadius = _StartTime * _Speed;

                // Halka dalga efektini oluştur
                float wave = smoothstep(currentRadius - _WaveWidth, currentRadius, dist) - smoothstep(currentRadius, currentRadius + _WaveWidth, dist);
                wave *= _WaveStrength;

                // UV koordinatlarını ayarla
                float2 newUV = i.uv + (wave * normalize(uv) * _DistortionStrength);

                // Texture'ı yeni UV koordinatlarıyla örnekleyin
                fixed4 col = tex2D(_MainTex, newUV);

                // Dalga geçerken hafif bir renk değişikliği ekle
                if (dist <= currentRadius + _WaveWidth && dist >= currentRadius - _WaveWidth)
                {
                    col += _DistortionColor * wave * .5;
                }

                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
