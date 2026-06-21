#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/init-project.sh <target-dir> [preset] [project-name]
  FORCE=1 scripts/init-project.sh <target-dir> [preset] [project-name]

Examples:
  scripts/init-project.sh ../my-saas saas_admin "My SaaS"
  scripts/init-project.sh ../wechat-shop wechat_business "WeChat Shop"

Presets are documented in templates/project-start/STACK_PRESETS.yml.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || $# -lt 1 ]]; then
  usage
  exit 0
fi

target_dir="$1"
preset="${2:-custom}"
project_name="${3:-$(basename "$target_dir")}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

if ! awk -v preset="$preset" '$0 == preset ":" { found = 1 } END { exit found ? 0 : 1 }' "$repo_root/templates/project-start/STACK_PRESETS.yml"; then
  echo "Warning: preset '$preset' was not found in templates/project-start/STACK_PRESETS.yml. Continuing as custom." >&2
fi

if [[ -e "$target_dir" && ! -d "$target_dir" ]]; then
  echo "Target exists and is not a directory: $target_dir" >&2
  exit 1
fi

if [[ -d "$target_dir" ]] \
  && [[ -n "$(find "$target_dir" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]] \
  && [[ "${FORCE:-0}" != "1" ]]; then
  echo "Target directory is not empty: $target_dir" >&2
  echo "Use FORCE=1 to initialize into an existing directory." >&2
  exit 1
fi

mkdir -p "$target_dir"
target_dir="$(cd "$target_dir" && pwd)"

if command -v git >/dev/null 2>&1 && [[ ! -d "$target_dir/.git" ]]; then
  git -C "$target_dir" init -q
fi

mkdir -p \
  "$target_dir/docs/00-intake/raw" \
  "$target_dir/docs/01-prd" \
  "$target_dir/docs/02-design" \
  "$target_dir/docs/03-architecture/adr" \
  "$target_dir/docs/04-qa" \
  "$target_dir/docs/05-change-requests" \
  "$target_dir/docs/99-retro" \
  "$target_dir/scripts"

mkdir -p "$target_dir/.skills"
for skill in \
  coding-guidelines \
  project-commander \
  fullstack-planning \
  go-backend \
  python-backend \
  web-admin-dashboard \
  web-frontend \
  wechat-miniprogram \
  qa-testing
do
  if [[ -d "$repo_root/$skill" ]]; then
    rm -rf "$target_dir/.skills/$skill"
    cp -R "$repo_root/$skill" "$target_dir/.skills/$skill"
  fi
done

rm -rf "$target_dir/.commander"
cp -R "$repo_root/templates/.commander" "$target_dir/.commander"
cp "$repo_root/templates/WORKFLOW.md" "$target_dir/WORKFLOW.md"

export PROJECT_NAME="$project_name"
export PROJECT_DESCRIPTION="待补充"
find "$target_dir/.commander/system-prompts" -type f -name '*.md' -print0 \
  | xargs -0 perl -0pi -e 's/\{\{PROJECT_NAME\}\}/$ENV{PROJECT_NAME}/g; s/\{\{PROJECT_DESCRIPTION\}\}/$ENV{PROJECT_DESCRIPTION}/g'

cp "$repo_root/templates/project-start/PROJECT_INTAKE_PACKET.md" "$target_dir/docs/00-intake/intake-packet.md"
cp "$repo_root/templates/project-start/QUALITY_GATES.md" "$target_dir/docs/QUALITY_GATES.md"
cp "$repo_root/templates/project-start/START_COMMANDER_PROMPTS.md" "$target_dir/docs/START_COMMANDER_PROMPTS.md"
cp "$repo_root/templates/project-start/STACK_PRESETS.yml" "$target_dir/docs/03-architecture/stack-presets.yml"

cp "$repo_root/templates/project-start/docs-template/00-intake/source-links.md" "$target_dir/docs/00-intake/source-links.md"
cp "$repo_root/templates/project-start/docs-template/00-intake/decision-log.md" "$target_dir/docs/00-intake/decision-log.md"
cp "$repo_root/templates/project-start/docs-template/01-prd/traceability-matrix.md" "$target_dir/docs/01-prd/traceability-matrix.md"
cp "$repo_root/templates/project-start/docs-template/02-design/design-decision.md" "$target_dir/docs/02-design/design-decision.md"
cp "$repo_root/templates/project-start/docs-template/03-architecture/adr/0001-tech-stack.md" "$target_dir/docs/03-architecture/adr/0001-tech-stack.md"
cp "$repo_root/templates/project-start/docs-template/04-qa/demo-script.md" "$target_dir/docs/04-qa/demo-script.md"
cp "$repo_root/templates/project-start/docs-template/99-retro/process-retro.md" "$target_dir/docs/99-retro/process-retro.md"

cp "$repo_root/templates/project-start/contract-bundle/"* "$target_dir/.commander/contracts/"

if [[ ! -f "$target_dir/.gitignore" ]]; then
  cp "$repo_root/templates/project-start/project.gitignore" "$target_dir/.gitignore"
fi

cat > "$target_dir/docs/00-intake/project-kickoff.md" <<EOF
# Project Kickoff

- Project: $project_name
- Preset: $preset
- Created: $(date '+%Y-%m-%d %H:%M:%S')

## Next Human Actions

1. Put customer documents into docs/00-intake/raw/.
2. Fill docs/00-intake/intake-packet.md.
3. Add reference links to docs/00-intake/source-links.md.
4. Send the Stage A prompt from docs/START_COMMANDER_PROMPTS.md to Commander.
EOF

cat <<EOF
Project initialized:
  $target_dir

Preset:
  $preset

Next:
  1. Add raw customer docs to docs/00-intake/raw/
  2. Fill docs/00-intake/intake-packet.md
  3. Send Stage A from docs/START_COMMANDER_PROMPTS.md
EOF
