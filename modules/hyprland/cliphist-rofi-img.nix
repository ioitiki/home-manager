{ pkgs }:

pkgs.writeShellScriptBin "cliphist-rofi-img" ''
  tmp_dir="/tmp/cliphist"
  rm -rf "$tmp_dir"

  if [ -z "$1" ]; then
      mkdir -p "$tmp_dir"

      ${pkgs.cliphist}/bin/cliphist list | while IFS= read -r line; do
          item_id=$(echo "$line" | ${pkgs.gawk}/bin/awk '{print $1}')

          # Decode the item to check if it's an image
          decoded=$(echo "$line" | ${pkgs.cliphist}/bin/cliphist decode)

          # Check if it's binary data (image)
          if file - <<< "$decoded" 2>/dev/null | grep -q image; then
              # Extract image and create thumbnail
              img_path="$tmp_dir/$item_id.png"
              echo "$line" | ${pkgs.cliphist}/bin/cliphist decode > "$img_path"
              echo -en "$item_id\x00icon\x1f$img_path\n"
          else
              # Text item - show preview
              preview=$(echo "$decoded" | head -c 100 | tr '\n' ' ')
              echo "$item_id	$preview"
          fi
      done
  else
      ${pkgs.cliphist}/bin/cliphist decode <<<"$1" | ${pkgs.wl-clipboard}/bin/wl-copy
  fi
''
