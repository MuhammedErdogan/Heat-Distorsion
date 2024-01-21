using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

[Serializable, VolumeComponentMenuForRenderPipeline("Custom/CustomEffectComponent", typeof(UniversalRenderPipeline))]
public class CustomEffectComponent : VolumeComponent, IPostProcessComponent
{
    // For example, an intensity parameter that goes from 0 to 1
    public ClampedFloatParameter intensity = new ClampedFloatParameter(value: 0, min: 0, max: 1, overrideState: true);
    public ClampedFloatParameter farClip = new ClampedFloatParameter(value: 7, min: 1, max: 10, overrideState: true);
    public ClampedFloatParameter nearClip = new ClampedFloatParameter(value: 2, min: 1, max: 10, overrideState: true);
    public ClampedFloatParameter heightStep = new ClampedFloatParameter(value: 1, min: -1, max: 1, overrideState: true);
    public ClampedFloatParameter heightOffset = new ClampedFloatParameter(value: -1, min: -5, max: 2, overrideState: true);
    public ClampedFloatParameter dustSpeed = new ClampedFloatParameter(value: 0.05f, min: -1, max: 1, overrideState: true);
    public ClampedFloatParameter heatDistortSpeed = new ClampedFloatParameter(value: 0.05f, min: -1, max: 1, overrideState: true);
    // A color that is constant even when the weight changes
    //public NoInterpColorParameter overlayColor = new NoInterpColorParameter(Color.cyan);
    
    // Other 'Parameter' variables you might have
    
    // Tells when our effect should be rendered
    public bool IsActive() => intensity.value > 0;
   
    // I have no idea what this does yet but I'll update the post once I find an usage
    public bool IsTileCompatible() => true;
}