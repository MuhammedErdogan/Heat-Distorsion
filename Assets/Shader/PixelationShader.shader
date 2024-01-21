Shader "Hidden/Custom/Pixelation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PixelSize ("Pixel Size", Float) = 8.0
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
            float _PixelSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Piksel boyutuna göre UV koordinatlarını ayarla
                float2 pixelUV = i.uv * _ScreenParams.xy / _PixelSize;
                pixelUV = floor(pixelUV) * _PixelSize / _ScreenParams.xy;

                // Piksel bloğunun rengini örnekleyip döndür
                fixed4 col = tex2D(_MainTex, pixelUV);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
