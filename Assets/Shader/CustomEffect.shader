Shader "Hidden/Custom/CustomEffect"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _EdgeColor ("Edge Color", Color) = (1,0,0,1)
        _EdgeThreshold ("Edge Threshold", float) = 0.1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline"
        }

        Pass
        {
            HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"

            #pragma vertex vert
            #pragma fragment frag

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            float4 _EdgeColor;
            float _EdgeThreshold;

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            Varyings vert(Attributes input)
            {
                Varyings output = (Varyings)0;
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.vertex = vertexInput.positionCS;
                output.uv = input.uv;

                return output;
            }

            float4 frag(Varyings i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                // Renk örneklemeleri
                float4 centerColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);
                float4 rightColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv + float2(_EdgeThreshold, 0));
                float4 leftColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv - float2(_EdgeThreshold, 0));
                float4 upColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv + float2(0, _EdgeThreshold));
                float4 downColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv - float2(0, _EdgeThreshold));

                // Renk farklarını hesapla
                float diffRight = length(rightColor - centerColor);
                float diffLeft = length(leftColor - centerColor);
                float diffUp = length(upColor - centerColor);
                float diffDown = length(downColor - centerColor);

                // Kenar algılama
                float edgeStrength = max(max(diffRight, diffLeft), max(diffUp, diffDown));
                bool isEdge = edgeStrength > _EdgeThreshold;

                if (isEdge)
                {
                    return isEdge; // Kenarları belirginleştir
                }
                else
                {
                    return centerColor; // Normal renkleri koru
                }
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
