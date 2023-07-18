Shader "JvLib/See Through - Unlit"
{
    Properties
    {
        [NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _Position("Position", Vector) = (0.5, 0.5, 0, 0)
        _Size("Size", Float) = 1
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _Opacity("Opacity", Float) = 0
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Albedo_TexelSize;
        float4 _Color;
        float2 _Position;
        float _Smoothness;
        float _Opacity;
        float _Size;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_f354036d2c154321a96c938e6afe46af_Out_0_Vector4 = _Color;
            UnityTexture2D _Property_5fdedc782ab74c8f8d0c2ec38ca73542_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Albedo);
            float4 _SampleTexture2D_1ccaa3bb92c7412fb41cee14962f4190_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5fdedc782ab74c8f8d0c2ec38ca73542_Out_0_Texture2D.tex, _Property_5fdedc782ab74c8f8d0c2ec38ca73542_Out_0_Texture2D.samplerstate, _Property_5fdedc782ab74c8f8d0c2ec38ca73542_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_1ccaa3bb92c7412fb41cee14962f4190_R_4_Float = _SampleTexture2D_1ccaa3bb92c7412fb41cee14962f4190_RGBA_0_Vector4.r;
            float _SampleTexture2D_1ccaa3bb92c7412fb41cee14962f4190_G_5_Float = _SampleTexture2D_1ccaa3bb92c7412fb41cee14962f4190_RGBA_0_Vector4.g;
            float _SampleTexture2D_1ccaa3bb92c7412fb41cee14962f4190_B_6_Float = _SampleTexture2D_1ccaa3bb92c7412fb41cee14962f4190_RGBA_0_Vector4.b;
            float _SampleTexture2D_1ccaa3bb92c7412fb41cee14962f4190_A_7_Float = _SampleTexture2D_1ccaa3bb92c7412fb41cee14962f4190_RGBA_0_Vector4.a;
            float4 _Multiply_34a06abdbcfa4feea1e6d941ae8c0a9e_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_f354036d2c154321a96c938e6afe46af_Out_0_Vector4, _SampleTexture2D_1ccaa3bb92c7412fb41cee14962f4190_RGBA_0_Vector4, _Multiply_34a06abdbcfa4feea1e6d941ae8c0a9e_Out_2_Vector4);
            float _Property_1a2bd30e4a0d438e82732ec8658d07c9_Out_0_Float = _Opacity;
            float _GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 10, _GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float);
            float _Property_966b169e58a641b6a8cdddd4bb7a8e00_Out_0_Float = _Smoothness;
            float4 _ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float2 _Property_4f162d85f7634b56be1624378c003fee_Out_0_Vector2 = _Position;
            float2 _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2;
            Unity_Remap_float2(_Property_4f162d85f7634b56be1624378c003fee_Out_0_Vector2, float2 (0, 1), float2 (0.5, -1.5), _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2);
            float2 _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2;
            Unity_Add_float2((_ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4.xy), _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2, _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2);
            float2 _TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2;
            Unity_TilingAndOffset_float((_ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4.xy), float2 (1, 1), _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2, _TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2);
            float2 _Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2;
            Unity_Multiply_float2_float2(_TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2, float2(2, 2), _Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2);
            float2 _Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2, float2(1, 1), _Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2);
            float _Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float);
            float _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float = _Size;
            float _Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float;
            Unity_Multiply_float_float(_Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float, _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float, _Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float);
            float2 _Vector2_2131ae71dc86492891eb253c057926d9_Out_0_Vector2 = float2(_Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float, _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float);
            float2 _Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2;
            Unity_Divide_float2(_Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2, _Vector2_2131ae71dc86492891eb253c057926d9_Out_0_Vector2, _Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2);
            float _Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float;
            Unity_Length_float2(_Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2, _Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float);
            float _OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float;
            Unity_OneMinus_float(_Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float, _OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float);
            float _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float;
            Unity_Saturate_float(_OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float, _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float);
            float _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float;
            Unity_Smoothstep_float(0, _Property_966b169e58a641b6a8cdddd4bb7a8e00_Out_0_Float, _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float);
            float _Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float, _Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float);
            float _Add_71b6858400004607a815b7575fa827b5_Out_2_Float;
            Unity_Add_float(_Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float, _Add_71b6858400004607a815b7575fa827b5_Out_2_Float);
            float _Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float;
            Unity_Multiply_float_float(_Property_1a2bd30e4a0d438e82732ec8658d07c9_Out_0_Float, _Add_71b6858400004607a815b7575fa827b5_Out_2_Float, _Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float);
            float _Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float;
            Unity_Clamp_float(_Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float, 0, 1, _Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float);
            float _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float;
            Unity_OneMinus_float(_Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float, _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float);
            surface.BaseColor = (_Multiply_34a06abdbcfa4feea1e6d941ae8c0a9e_Out_2_Vector4.xyz);
            surface.Alpha = _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Albedo_TexelSize;
        float4 _Color;
        float2 _Position;
        float _Smoothness;
        float _Opacity;
        float _Size;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_1a2bd30e4a0d438e82732ec8658d07c9_Out_0_Float = _Opacity;
            float _GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 10, _GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float);
            float _Property_966b169e58a641b6a8cdddd4bb7a8e00_Out_0_Float = _Smoothness;
            float4 _ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float2 _Property_4f162d85f7634b56be1624378c003fee_Out_0_Vector2 = _Position;
            float2 _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2;
            Unity_Remap_float2(_Property_4f162d85f7634b56be1624378c003fee_Out_0_Vector2, float2 (0, 1), float2 (0.5, -1.5), _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2);
            float2 _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2;
            Unity_Add_float2((_ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4.xy), _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2, _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2);
            float2 _TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2;
            Unity_TilingAndOffset_float((_ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4.xy), float2 (1, 1), _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2, _TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2);
            float2 _Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2;
            Unity_Multiply_float2_float2(_TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2, float2(2, 2), _Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2);
            float2 _Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2, float2(1, 1), _Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2);
            float _Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float);
            float _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float = _Size;
            float _Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float;
            Unity_Multiply_float_float(_Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float, _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float, _Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float);
            float2 _Vector2_2131ae71dc86492891eb253c057926d9_Out_0_Vector2 = float2(_Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float, _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float);
            float2 _Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2;
            Unity_Divide_float2(_Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2, _Vector2_2131ae71dc86492891eb253c057926d9_Out_0_Vector2, _Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2);
            float _Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float;
            Unity_Length_float2(_Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2, _Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float);
            float _OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float;
            Unity_OneMinus_float(_Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float, _OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float);
            float _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float;
            Unity_Saturate_float(_OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float, _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float);
            float _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float;
            Unity_Smoothstep_float(0, _Property_966b169e58a641b6a8cdddd4bb7a8e00_Out_0_Float, _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float);
            float _Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float, _Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float);
            float _Add_71b6858400004607a815b7575fa827b5_Out_2_Float;
            Unity_Add_float(_Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float, _Add_71b6858400004607a815b7575fa827b5_Out_2_Float);
            float _Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float;
            Unity_Multiply_float_float(_Property_1a2bd30e4a0d438e82732ec8658d07c9_Out_0_Float, _Add_71b6858400004607a815b7575fa827b5_Out_2_Float, _Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float);
            float _Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float;
            Unity_Clamp_float(_Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float, 0, 1, _Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float);
            float _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float;
            Unity_OneMinus_float(_Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float, _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float);
            surface.Alpha = _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Albedo_TexelSize;
        float4 _Color;
        float2 _Position;
        float _Smoothness;
        float _Opacity;
        float _Size;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_1a2bd30e4a0d438e82732ec8658d07c9_Out_0_Float = _Opacity;
            float _GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 10, _GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float);
            float _Property_966b169e58a641b6a8cdddd4bb7a8e00_Out_0_Float = _Smoothness;
            float4 _ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float2 _Property_4f162d85f7634b56be1624378c003fee_Out_0_Vector2 = _Position;
            float2 _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2;
            Unity_Remap_float2(_Property_4f162d85f7634b56be1624378c003fee_Out_0_Vector2, float2 (0, 1), float2 (0.5, -1.5), _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2);
            float2 _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2;
            Unity_Add_float2((_ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4.xy), _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2, _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2);
            float2 _TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2;
            Unity_TilingAndOffset_float((_ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4.xy), float2 (1, 1), _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2, _TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2);
            float2 _Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2;
            Unity_Multiply_float2_float2(_TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2, float2(2, 2), _Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2);
            float2 _Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2, float2(1, 1), _Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2);
            float _Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float);
            float _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float = _Size;
            float _Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float;
            Unity_Multiply_float_float(_Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float, _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float, _Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float);
            float2 _Vector2_2131ae71dc86492891eb253c057926d9_Out_0_Vector2 = float2(_Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float, _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float);
            float2 _Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2;
            Unity_Divide_float2(_Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2, _Vector2_2131ae71dc86492891eb253c057926d9_Out_0_Vector2, _Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2);
            float _Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float;
            Unity_Length_float2(_Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2, _Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float);
            float _OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float;
            Unity_OneMinus_float(_Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float, _OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float);
            float _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float;
            Unity_Saturate_float(_OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float, _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float);
            float _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float;
            Unity_Smoothstep_float(0, _Property_966b169e58a641b6a8cdddd4bb7a8e00_Out_0_Float, _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float);
            float _Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float, _Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float);
            float _Add_71b6858400004607a815b7575fa827b5_Out_2_Float;
            Unity_Add_float(_Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float, _Add_71b6858400004607a815b7575fa827b5_Out_2_Float);
            float _Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float;
            Unity_Multiply_float_float(_Property_1a2bd30e4a0d438e82732ec8658d07c9_Out_0_Float, _Add_71b6858400004607a815b7575fa827b5_Out_2_Float, _Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float);
            float _Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float;
            Unity_Clamp_float(_Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float, 0, 1, _Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float);
            float _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float;
            Unity_OneMinus_float(_Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float, _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float);
            surface.Alpha = _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Albedo_TexelSize;
        float4 _Color;
        float2 _Position;
        float _Smoothness;
        float _Opacity;
        float _Size;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_1a2bd30e4a0d438e82732ec8658d07c9_Out_0_Float = _Opacity;
            float _GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 10, _GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float);
            float _Property_966b169e58a641b6a8cdddd4bb7a8e00_Out_0_Float = _Smoothness;
            float4 _ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float2 _Property_4f162d85f7634b56be1624378c003fee_Out_0_Vector2 = _Position;
            float2 _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2;
            Unity_Remap_float2(_Property_4f162d85f7634b56be1624378c003fee_Out_0_Vector2, float2 (0, 1), float2 (0.5, -1.5), _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2);
            float2 _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2;
            Unity_Add_float2((_ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4.xy), _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2, _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2);
            float2 _TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2;
            Unity_TilingAndOffset_float((_ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4.xy), float2 (1, 1), _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2, _TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2);
            float2 _Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2;
            Unity_Multiply_float2_float2(_TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2, float2(2, 2), _Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2);
            float2 _Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2, float2(1, 1), _Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2);
            float _Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float);
            float _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float = _Size;
            float _Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float;
            Unity_Multiply_float_float(_Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float, _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float, _Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float);
            float2 _Vector2_2131ae71dc86492891eb253c057926d9_Out_0_Vector2 = float2(_Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float, _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float);
            float2 _Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2;
            Unity_Divide_float2(_Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2, _Vector2_2131ae71dc86492891eb253c057926d9_Out_0_Vector2, _Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2);
            float _Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float;
            Unity_Length_float2(_Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2, _Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float);
            float _OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float;
            Unity_OneMinus_float(_Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float, _OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float);
            float _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float;
            Unity_Saturate_float(_OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float, _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float);
            float _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float;
            Unity_Smoothstep_float(0, _Property_966b169e58a641b6a8cdddd4bb7a8e00_Out_0_Float, _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float);
            float _Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float, _Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float);
            float _Add_71b6858400004607a815b7575fa827b5_Out_2_Float;
            Unity_Add_float(_Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float, _Add_71b6858400004607a815b7575fa827b5_Out_2_Float);
            float _Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float;
            Unity_Multiply_float_float(_Property_1a2bd30e4a0d438e82732ec8658d07c9_Out_0_Float, _Add_71b6858400004607a815b7575fa827b5_Out_2_Float, _Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float);
            float _Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float;
            Unity_Clamp_float(_Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float, 0, 1, _Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float);
            float _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float;
            Unity_OneMinus_float(_Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float, _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float);
            surface.Alpha = _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Albedo_TexelSize;
        float4 _Color;
        float2 _Position;
        float _Smoothness;
        float _Opacity;
        float _Size;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_1a2bd30e4a0d438e82732ec8658d07c9_Out_0_Float = _Opacity;
            float _GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, 10, _GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float);
            float _Property_966b169e58a641b6a8cdddd4bb7a8e00_Out_0_Float = _Smoothness;
            float4 _ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float2 _Property_4f162d85f7634b56be1624378c003fee_Out_0_Vector2 = _Position;
            float2 _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2;
            Unity_Remap_float2(_Property_4f162d85f7634b56be1624378c003fee_Out_0_Vector2, float2 (0, 1), float2 (0.5, -1.5), _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2);
            float2 _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2;
            Unity_Add_float2((_ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4.xy), _Remap_1ee2898a97b84cc4b55572f6cfa9eb3d_Out_3_Vector2, _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2);
            float2 _TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2;
            Unity_TilingAndOffset_float((_ScreenPosition_8701a11b70a8430b8b216b7c81c7ae59_Out_0_Vector4.xy), float2 (1, 1), _Add_5259f78d551f434ba7945acda272d238_Out_2_Vector2, _TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2);
            float2 _Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2;
            Unity_Multiply_float2_float2(_TilingAndOffset_3d709765831d4de18a35fe9013353b99_Out_3_Vector2, float2(2, 2), _Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2);
            float2 _Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_997d510431154e71bc1e39cd632efa66_Out_2_Vector2, float2(1, 1), _Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2);
            float _Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float);
            float _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float = _Size;
            float _Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float;
            Unity_Multiply_float_float(_Divide_6c1ea82e62eb4eeb9a89af6993a9c6e7_Out_2_Float, _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float, _Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float);
            float2 _Vector2_2131ae71dc86492891eb253c057926d9_Out_0_Vector2 = float2(_Multiply_ea2c7933adc0415bb4dde2e987338514_Out_2_Float, _Property_da790f0cc02a422f8495bf26db22dab7_Out_0_Float);
            float2 _Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2;
            Unity_Divide_float2(_Subtract_984cfdaec5364fbb96e4c417c6189ab2_Out_2_Vector2, _Vector2_2131ae71dc86492891eb253c057926d9_Out_0_Vector2, _Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2);
            float _Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float;
            Unity_Length_float2(_Divide_8bc204b5f8ca4e36804dcad77d49e65b_Out_2_Vector2, _Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float);
            float _OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float;
            Unity_OneMinus_float(_Length_291e93663ef14dbaad5e3f15edcb52ca_Out_1_Float, _OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float);
            float _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float;
            Unity_Saturate_float(_OneMinus_2e00d06346d84455aa820dee8a43fb4f_Out_1_Float, _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float);
            float _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float;
            Unity_Smoothstep_float(0, _Property_966b169e58a641b6a8cdddd4bb7a8e00_Out_0_Float, _Saturate_83e7b1a6a3ee4295822b31fbf764ba0b_Out_1_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float);
            float _Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_7ef1a5d9bf904195898339cd82b51dda_Out_2_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float, _Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float);
            float _Add_71b6858400004607a815b7575fa827b5_Out_2_Float;
            Unity_Add_float(_Multiply_a17be74ccf634764a78606f36834a516_Out_2_Float, _Smoothstep_1d432277db0f4a2eaecf095f439a757c_Out_3_Float, _Add_71b6858400004607a815b7575fa827b5_Out_2_Float);
            float _Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float;
            Unity_Multiply_float_float(_Property_1a2bd30e4a0d438e82732ec8658d07c9_Out_0_Float, _Add_71b6858400004607a815b7575fa827b5_Out_2_Float, _Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float);
            float _Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float;
            Unity_Clamp_float(_Multiply_7333c9560a474480a292bce913169b7f_Out_2_Float, 0, 1, _Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float);
            float _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float;
            Unity_OneMinus_float(_Clamp_aa2e6f35f7124972b0400c31eaab4d2e_Out_3_Float, _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float);
            surface.Alpha = _OneMinus_834cd50fc9a34ebc9f3c80ce022f0814_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}