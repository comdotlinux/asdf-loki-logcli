#!/usr/bin/env bash
# set -x

export workspace=$(dirname $0)
export checks_src=/tmp/checks

if [[ "x$1" != "x-keep" ]]; then
  mkdir "$checks_src" || exit 1
  trap "rm -rf $checks_src" EXIT
  pushd /tmp
fi

if [[ ! -f "${checks_src}/shellcheck" ]]; then
  echo "Downloading shell check"
  export scversion="stable"
  wget -qO- "https://storage.googleapis.com/shellcheck/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJv
  mv shellcheck-stable/shellcheck "${checks_src}/"
  rm shellcheck-stable -rf
  chmod u+x "${checks_src}/shellcheck"
fi

if [[ ! -f "${checks_src}/shfmt" ]]; then
  echo "Downloading shfmt"
  curl -LOC- https://github.com/patrickvane/shfmt/releases/download/master/shfmt_linux_amd64
  mv shfmt_linux_amd64 "${checks_src}/shfmt"
  chmod u+x "${checks_src}/shfmt"
fi

pushd "$workspace" || exit 1

echo "Running Shellcheck"
${checks_src}/shellcheck -x $workspace/bin/install -P lib/
${checks_src}/shellcheck -x $workspace/bin/list-all -P lib/

echo "Running shfmt"
${checks_src}/shfmt -d -i 2 -ci $workspace
