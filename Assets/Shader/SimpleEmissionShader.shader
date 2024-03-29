Shader "Hidden/Custom/SimpleEmission"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _EmissionColor ("Emission Color", Color) = (1,1,1,1)
        _EmissionStrength ("Emission Strength", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

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
            float4 _EmissionColor;
            float _EmissionStrength;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Albedo rengini örnekleyin
                fixed4 albedo = tex2D(_MainTex, i.uv);

                // Emission rengini ve yoğunluğunu ekle
                fixed4 emissive = albedo + _EmissionColor * _EmissionStrength;

                return emissive;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
