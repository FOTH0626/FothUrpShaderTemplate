Shader "Foth/Aglina"
{
    Properties
    {
        [Header(Main Maps)]
        _Color ("Color", Color)=(1,1,1,1)
        [NoScaleOffset] _MainTex ("Texture",2D)="white"{}
        [NoScaleOffset] _OtherDataTex ("Other Data Tex",2D) = "white"{}
        [NoScaleOffset] _OtherDataTex2 ("Other Data Tex 2",2D) = "white"{}
        [NoScaleOffset] _OtherDataTex3 ("Other Data Tex 3",2D)= "white"{}










        [Header(Option)]
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull (Default back)",Float)=2
        [Enum(Off,0,On,1)] _ZWrite ("ZWrite (Default On)",Float)=1
        [Enum(UnityEngine.Rendering.BlendMode)]_SrcBlendMode ("Src blend mode (Default One)",Float)=1
        [Enum(UnityEngine.Rendering.BlendMode)]_DstBlendMode ("Dst blend mode (Default Zero)",Float)=0
        [Enum(UnityEngine.Rendering.BlendOp)]_BlendOp ("Blend operation (Default Add)",Float)=0
        _StencilRef ("Stencil reference",Int)=0
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp ("Stencil compare function",Int)=0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilPassOp ("Stencil pass operation",Int)=0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilFailOp ("Stencil fail operation",Int)=0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilZFailOp ("Stencil Z fail operation",Int)=0
      
        [Header(SRP Default)]
        [Toggle(_SRP_DEFAULT_PASS)]_SRPDefaultPass ("SRP Default Pass",Int)=0
        [Enum(UnityEngine.Rendering.BlendMode)]_SRPSrcBlendMode ("SRP src blend mode (Default One)",Float)=1
        [Enum(UnityEngine.Rendering.BlendMode)]_SRPDstBlendMode ("SRP dst blend mode (Default Zero)",Float)=0
        [Enum(UnityEngine.Rendering.BlendOp)]_SRPBlendOp ("SRP blend operation (Default Add)",Float) =0
        
        _SRPStencilRef ("SRP stencil reference",Int)=0
        [Enum(UnityEngine.Rendering.CompareFunction)]_SRPStencilComp ("SRP stencil compare function",Int)=0
        [Enum(UnityEngine.Rendering.StencilOp)]_SRPStencilPassOp ("SRP stencil pass operation",Int)=0
        [Enum(UnityEngine.Rendering.StencilOp)]_SRPStencilFailOp ("SRP stencil fail operation",Int)=0
        [Enum(UnityEngine.Rendering.StencilOp)]_SRPStencilZFailOp ("SRP stencil Z fail operation",Int)=0
    }
    

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
        }
        
        HLSLINCLUDE

        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

        CBUFFER_START(UnityPerMaterial)

        CBUFFER_END
        

        struct UniversalAttributes
        {
            float4 positionOS   : POSITION;
            float4 tangentOS    : TANGENT;
            float3 normalOS     : NORMAL;
            float2 texcoord     : TEXCOORD0;
        };

        struct UniversalVaryings
        {
            float2 uv                       :TEXCOORD0;
            float4 positionWSAndFogFactor   :TEXCOORD1;
            float3 normalWS                 :TEXCOORD2;
            float4 tangentWS                :TEXCOORD3;
            float3 viewDirectionWS          :TEXCOORD4;
            float4 positionCS               :SV_POSITION;
        };

        UniversalVaryings MainVS(UniversalAttributes input)
        {
            VertexPositionInputs positionInputs =  GetVertexPositionInputs(input.positionOS.xyz);
            VertexNormalInputs normalInputs = GetVertexNormalInputs(input.normalOS,input.tangentOS);

            UniversalVaryings output;
            output.positionCS =  positionInputs.positionCS;
            output.positionWSAndFogFactor = float4(positionInputs.positionWS,ComputeFogFactor(positionInputs.positionCS.z));
            output.normalWS =  normalInputs.normalWS;
            output.tangentWS.xyz =  normalInputs.tangentWS;
            output.tangentWS.w =  input.tangentOS.w * GetOddNegativeScale();
            output.viewDirectionWS = unity_OrthoParams.w == 0 ? GetCameraPositionWS() -positionInputs.positionWS : GetWorldToViewMatrix()[2].xyz;
            output.uv = input.texcoord;
            return output;
        }

        float4 MainFS (UniversalVaryings input) : SV_Target
        {
            return float4(0,0,1,1);
        } 
        
        ENDHLSL

        Pass
        {
            HLSLPROGRAM

            #pragma  vertex MainVS
            #pragma  fragment MainFS
            
            ENDHLSL
        }
    }
}
