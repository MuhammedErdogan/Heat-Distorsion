using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UI;
using UnityEngine.Rendering.Universal; // Bu kütüphane Universal Render Pipeline özelliklerine erişim sağlar

public class CustomEffectUIController : MonoBehaviour
{
    [SerializeField] public Volume path;
    private CustomEffectComponent customEffect;

    [SerializeField] public Slider intensitySlider;
    [SerializeField] public Slider farClipSlider;
    [SerializeField] public Slider nearClipSlider;
    [SerializeField] public Slider heightStepSlider;
    [SerializeField] public Slider heightOffsetSlider;
    [SerializeField] public Slider dustSpeedSlider;
    [SerializeField] public Slider heatDistortSpeedSlider;

    void Start()
    {
        // Sliderların başlangıç değerlerini ayarla

        if (path.profile.TryGet(out customEffect))
        {
            intensitySlider.value = customEffect.intensity.value;
            farClipSlider.value = customEffect.farClip.value;
            nearClipSlider.value = customEffect.nearClip.value;
            heightStepSlider.value = customEffect.heightStep.value;
            heightOffsetSlider.value = customEffect.heightOffset.value;
            dustSpeedSlider.value = customEffect.dustSpeed.value;
            heatDistortSpeedSlider.value = customEffect.heatDistortSpeed.value;

            // Sliderların değer değişikliği olaylarına metodları bağla
            intensitySlider.onValueChanged.AddListener(newValue => customEffect.intensity.value = newValue);
            farClipSlider.onValueChanged.AddListener(newValue => customEffect.farClip.value = newValue);
            nearClipSlider.onValueChanged.AddListener(newValue => customEffect.nearClip.value = newValue);
            heightStepSlider.onValueChanged.AddListener(newValue => customEffect.heightStep.value = newValue);
            heightOffsetSlider.onValueChanged.AddListener(newValue => customEffect.heightOffset.value = newValue);
            dustSpeedSlider.onValueChanged.AddListener(newValue => customEffect.dustSpeed.value = newValue);
            heatDistortSpeedSlider.onValueChanged.AddListener(newValue => customEffect.heatDistortSpeed.value = newValue);
        }
    }
}