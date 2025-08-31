# openai-chat.nix
{ pkgs, config, ... }:

let
   # Create the shell script in the Nix store
   openaiChatScript = pkgs.writeShellScriptBin "openai-chat" ''
      org.chromium.Chromium "https://chat.openai.com"
   '';

in
{
   home.file.".local/bin/openai-chat.sh" = {
      text = ''
         #!${pkgs.bash}/bin/bash
         ln -sf ${openaiChatScript}/bin/openai-chat ~/.local/bin/openai-chat.sh
      '';
      executable = true;
   };

   home.file.".local/share/applications/openai-chat.desktop".text = ''
      [Desktop Entry]
      Name=Chat OpenAI
      Exec=${config.home.homeDirectory}/.local/bin/openai-chat.sh
      Path=${config.home.homeDirectory}/.local/bin
      Type=Application
      Terminal=false
   '';
}
