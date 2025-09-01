{ lib, ... }:
with lib;
let
  defaultApps = {
    browser = [ "vivaldi-stable.desktop" ];
  };

  mimeMap = {
    browser = [
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
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


