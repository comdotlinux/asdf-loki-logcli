#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for loki-logcli.
GH_REPO="https://github.com/grafana/loki"

fail() {
  echo -e "asdf-loki-logcli: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if loki-logcli is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | grep -v "helm-loki" | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # TODO: Adapt this. By default we simply list the tag names from GitHub releases.
  # Change this function if loki-logcli has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url download_path
  version="$1"
  filename="$2"
  download_path="$3"

  # TODO: Adapt the release URL convention for loki-logcli
  url="$GH_REPO/releases/download/v${version}/${filename}"

  echo "* Downloading loki-logcli release $version..."
  curl "${curl_opts[@]}" -o "${download_path}/$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"
  # Added Platform detection
  local platform=$(uname | tr '[:upper:]' '[:lower:]')

  # Added architecture detection
  local architecture=""
  case $(uname -m) in
    i386) architecture="386" ;;
    i686) architecture="386" ;;
    x86_64) architecture="amd64" ;;
    armv*) architecture="arm" ;;
    aarch64) architecture="arm64" ;;
  esac
  if [ "x${architecture}" = "x" ] ; then
    architecture="$(uname -m)" ;
  fi

  if [ "$install_type" != "version" ]; then
    fail "asdf-loki-logcli supports release installs only"
  fi

  # Adapted this to proper extension and adapt extracting strategy.
  local release_filename="logcli-${platform}-${architecture}.zip"
  local release_file="$install_path/${release_filename}"
  (
    mkdir -p "$install_path/bin"
    download_release "$version" "$release_filename" "$install_path"
    unzip "$release_file" && mv -v logcli-${platform}-${architecture} "$install_path/bin/logcli" && chmod a+x "$install_path/bin/logcli" || fail "Could not extract $release_file"
    rm "$release_file"

    # Assert loki-logcli executable exists.
    local tool_cmd
    tool_cmd="logcli"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "loki-logcli $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing loki-logcli $version."
  )
}
