{ lib, ... }:
with lib;
let
  defaultApps = {
    browser = [ "vivaldi-stable.desktop" ];
    fileManager = [ "thunar.desktop" ];
    pdf = [ "org.pwmt.zathura.desktop" ];
  };

  mimeMap = {
    browser = [
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
    ];
    fileManager = [
      "inode/directory"
      "x-scheme-handler/file"
    ];
    pdf = [
      "application/pdf"
    ];
  };

  associations =
    with lists;
    listToAttrs (
      flatten (
        mapAttrsToList (
          key: map (type: attrsets.nameValuePair type defaultApps."${key}")
        ) mimeMap
      )
    );
in
{
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = associations;
  xdg.mimeApps.defaultApplications = associations;
}


