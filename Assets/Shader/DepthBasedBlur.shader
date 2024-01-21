Shader "Custom/SimpleBloomShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // Pass for horizontal bloom
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragH

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 fragH (v2f i) : SV_Target
            {
                float3 color = 0.0;
                float offsets[9] = {-4.0, -3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 4.0};
                float weights[9] = {0.01621622, 0.05405405, 0.12162162, 0.19459459, .5, 0.019459459, 0.012162162, 0.25405405, 0.001621622};

                for (int j = 0; j < 9; ++j)
                {
                    color += tex2D(_MainTex, i.uv + float2(offsets[j] * _MainTex_ST.x, 0.0)).rgb * weights[j];
                }

                return float4(color, 1.0);
            }
            ENDCG
        }

        // Pass for vertical bloom
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragV

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 fragV (v2f i) : SV_Target
            {
                float3 color = 0.0;
                float offsets[9] = {-4.0, -3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 4.0};
                float weights[9] = {0.01621622, 0.05405405, 0.12162162, 0.19459459, 0.22702703, 0.19459459, 0.12162162, 0.05405405, 0.01621622};

                for (int j = 0; j < 9; ++j)
                {
                    color += tex2D(_MainTex, i.uv + float2(0.0, offsets[j] * _MainTex_ST.y)).rgb * weights[j];
                }

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
