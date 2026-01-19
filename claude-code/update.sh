#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_MANAGER_DIR="$(dirname "$SCRIPT_DIR")"
PACKAGE_NIX="$SCRIPT_DIR/package.nix"

DOWNGRADE_PATCH=false
if [[ "${1:-}" == "--downgrade-patch" || "${1:-}" == "-p" ]]; then
    DOWNGRADE_PATCH=true
fi

# Get current version from package.nix
current_version=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_NIX")
echo "Current version: $current_version"

if [[ "$DOWNGRADE_PATCH" == true ]]; then
    # Decrement patch version
    IFS='.' read -r major minor patch <<< "$current_version"
    if [[ "$patch" -le 0 ]]; then
        echo "Cannot downgrade patch version below 0"
        exit 1
    fi
    version="$major.$minor.$((patch - 1))"
    echo "Downgrading to: $version"
else
    # Get latest version from npm
    echo "Fetching latest version from npm..."
    version=$(npm view @anthropic-ai/claude-code version)
    echo "Latest version: $version"

    if [[ "$version" == "$current_version" ]]; then
        echo "Already at latest version, nothing to do."
        exit 0
    fi
fi

# Update version in package.nix
echo "Updating version in package.nix..."
sed -i "s/version = \"[^\"]*\"/version = \"$version\"/" "$PACKAGE_NIX"

# Generate new package-lock.json
echo "Generating package-lock.json for version $version..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
npm pack "@anthropic-ai/claude-code@$version"
tar -xzf *.tgz
cd package
npm install --package-lock-only --legacy-peer-deps --ignore-scripts
cp package-lock.json "$SCRIPT_DIR/package-lock.json"
cd "$SCRIPT_DIR"
rm -rf "$TEMP_DIR"
echo "package-lock.json generated successfully"

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
