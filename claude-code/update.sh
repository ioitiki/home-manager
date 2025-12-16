#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_MANAGER_DIR="$(dirname "$SCRIPT_DIR")"
PACKAGE_NIX="$SCRIPT_DIR/package.nix"

# Get latest version from npm
echo "Fetching latest version from npm..."
version=$(npm view @anthropic-ai/claude-code version)
echo "Latest version: $version"

# Get current version from package.nix
current_version=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_NIX")
echo "Current version: $current_version"

if [[ "$version" == "$current_version" ]]; then
    echo "Already at latest version, nothing to do."
    exit 0
fi

# Update version in package.nix
echo "Updating version in package.nix..."
sed -i "s/version = \"[^\"]*\"/version = \"$version\"/" "$PACKAGE_NIX"

# Clear both hashes
echo "Clearing hashes..."
sed -i 's/hash = "sha256-[^"]*"/hash = ""/' "$PACKAGE_NIX"
sed -i 's/npmDepsHash = "sha256-[^"]*"/npmDepsHash = ""/' "$PACKAGE_NIX"

# First build attempt - get src hash
echo "Building to get src hash..."
src_hash=$(home-manager switch --flake "$HOME_MANAGER_DIR#andy" 2>&1 | grep -oP 'got:\s+\Ksha256-[A-Za-z0-9+/=]+' | head -1) || true

if [[ -n "$src_hash" ]]; then
    echo "Got src hash: $src_hash"
    sed -i "s|hash = \"\"|hash = \"$src_hash\"|" "$PACKAGE_NIX"
else
    echo "Failed to get src hash"
    exit 1
fi

# Second build attempt - get npmDepsHash
echo "Building to get npmDepsHash..."
npm_hash=$(home-manager switch --flake "$HOME_MANAGER_DIR#andy" 2>&1 | grep -oP 'got:\s+\Ksha256-[A-Za-z0-9+/=]+' | head -1) || true

if [[ -n "$npm_hash" ]]; then
    echo "Got npm deps hash: $npm_hash"
    sed -i "s|npmDepsHash = \"\"|npmDepsHash = \"$npm_hash\"|" "$PACKAGE_NIX"
else
    echo "Failed to get npm deps hash"
    exit 1
fi

# Final build
echo "Running final build..."
home-manager switch --flake "$HOME_MANAGER_DIR#andy"

echo "Update complete! claude-code updated to version $version"
