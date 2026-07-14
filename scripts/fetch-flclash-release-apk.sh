#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/fetch-flclash-release-apk.sh <version> [--force]

Examples:
  scripts/fetch-flclash-release-apk.sh 0.8.94
  scripts/fetch-flclash-release-apk.sh v0.8.94 --force

Downloads all FlClash Android APKs from GitHub Releases into fdroid/repo/.
Each APK is verified against the release SHA256SUMS before being saved.
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  usage >&2
  exit 2
fi

version="${1#v}"
force="${2:-}"

if [ -n "$force" ] && [ "$force" != "--force" ]; then
  usage >&2
  exit 2
fi

repo="EyKettle/FlClash"
tag="v${version}"
base_url="https://github.com/${repo}/releases/download/${tag}"
abis=("arm64-v8a" "armeabi-v7a" "x86_64")

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
target_dir="${repo_root}/fdroid/repo"
work_dir="$(mktemp -d)"

cleanup() {
  rm -rf "$work_dir"
}
trap cleanup EXIT

mkdir -p "$target_dir"

echo "Downloading SHA256SUMS"
checksums_url="${base_url}/SHA256SUMS"
curl --fail --location --retry 3 --output "${work_dir}/SHA256SUMS" "$checksums_url"

for abi in "${abis[@]}"; do
  asset="FlClash-${version}-android-${abi}.apk"
  apk_url="${base_url}/${asset}"
  target="${target_dir}/${asset}"

  if [ -e "$target" ] && [ "$force" != "--force" ]; then
    echo "Refusing to overwrite existing file: $target" >&2
    echo "Pass --force to replace it." >&2
    exit 1
  fi

  echo "Downloading ${asset}"
  curl --fail --location --retry 3 --output "${work_dir}/${asset}" "$apk_url"

  expected_sha="$(
    awk -v asset="$asset" '$0 ~ asset { print $1; exit }' "${work_dir}/SHA256SUMS"
  )"

  if [ -z "$expected_sha" ]; then
    echo "Could not find ${asset} in SHA256SUMS" >&2
    exit 1
  fi

  if command -v shasum >/dev/null 2>&1; then
    actual_sha="$(shasum -a 256 "${work_dir}/${asset}" | awk '{ print $1 }')"
  elif command -v sha256sum >/dev/null 2>&1; then
    actual_sha="$(sha256sum "${work_dir}/${asset}" | awk '{ print $1 }')"
  else
    echo "Neither shasum nor sha256sum is available" >&2
    exit 1
  fi

  if [ "$actual_sha" != "$expected_sha" ]; then
    echo "SHA256 mismatch for ${asset}" >&2
    echo "expected: ${expected_sha}" >&2
    echo "actual:   ${actual_sha}" >&2
    exit 1
  fi

  mv "${work_dir}/${asset}" "$target"
  echo "Saved: ${target}"
done

echo
echo "All APKs downloaded and verified in fdroid/repo/. Update the F-Droid index with:"
echo "  cd ${repo_root}/fdroid && fdroid update --pretty --delete-unknown --use-date-from-apk"
echo "Then publish:"
echo "  git push (workflow_dispatch) or fdroid deploy -v"
