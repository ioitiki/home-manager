{ ... }:

let
  # Rules not needed - thumb button handled by Hyprland submap
  rulesFile = ''
    %YAML 1.3
    ---
  '';

  configFile = ''
    - 1.1.16
    - _NAME: MX Master 4
      _absent: [hi-res-scroll, lowres-scroll-mode, onboard_profiles, report_rate, report_rate_extended, pointer_speed, dpi_extended, speed-change, backlight,
        backlight_level, backlight_duration_hands_out, backlight_duration_hands_in, backlight_duration_powered, backlight-timed, led_control, led_zone_, rgb_control,
        rgb_zone_, brightness_control, per-key-lighting, fn-swap, persistent-remappable-keys, disable-keyboard-keys, crown-smooth, divert-crown, divert-gkeys,
        m-key-leds, mr-key-led, multiplatform, gesture2-gestures, gesture2-divert, gesture2-params, sidetone, equalizer, adc_power_management]
      _battery: 4100
      _modelId: B04200000000
      _sensitive: {dpi: true, hires-scroll-mode: ignore, hires-smooth-invert: ignore, hires-smooth-resolution: ignore, scroll-ratchet: false, thumb-scroll-invert: true}
      _serial: 6AD31F5F
      _unitId: 6AD31F5F
      _wpid: B042
      change-host: null
      divert-keys: {82: 0, 83: 0, 86: 0, 195: 0, 196: 0, 416: 0}
      dpi: 1300
      hires-scroll-mode: false
      hires-smooth-invert: false
      hires-smooth-resolution: false
      reprogrammable-keys: {82: 82, 83: 83, 86: 86, 195: 195, 196: 196, 416: 416}
      scroll-ratchet: 2
      smart-shift: 12
      thumb-scroll-invert: true
      thumb-scroll-mode: false
  '';
in
{
  xdg.configFile."solaar/rules.yaml".text = rulesFile;
  xdg.configFile."solaar/config.yaml".text = configFile;
}
