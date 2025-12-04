{ ... }:

let
  rulesFile = ''
    %YAML 1.3
    ---
    - Rule:
      - Key: [Mouse Gesture Button, pressed]
      - KeyPress: [Super_L]
  '';
in
{
  xdg.configFile."solaar/rules.yaml".text = rulesFile;
}
