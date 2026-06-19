#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
)"

usage() {
  cat >&2 <<'EOF'
Usage:
  ./generate-gitconfig.sh single [NAME EMAIL]
  ./generate-gitconfig.sh multi [DEFAULT_IDENTITY PERSONAL_NAME PERSONAL_EMAIL WORK_NAME WORK_EMAIL]

Examples:
  ./generate-gitconfig.sh single
  ./generate-gitconfig.sh single "Jane Doe" "jane@example.com"
  ./generate-gitconfig.sh multi
  ./generate-gitconfig.sh multi work "Jane Doe" "jane@example.com" "Jane Doe" "jane@work.com"
EOF
  exit 1
}

render_template() {
  local template="$1"
  local output="$2"
  local name="${3:-}"
  local email="${4:-}"
  local default_identity="${5:-}"

  sed \
    -e "s/{{NAME}}/${name//\//\\/}/g" \
    -e "s/{{EMAIL}}/${email//\//\\/}/g" \
    -e "s/{{DEFAULT_IDENTITY}}/${default_identity//\//\\/}/g" \
    "${template}" > "${output}"
}

prompt_identity() {
  local label="$1"
  local name_var="$2"
  local email_var="$3"
  local name
  local email

  echo "Enter ${label} Git identity:"
  read -r -p "Name: " name
  read -r -p "Email: " email

  printf -v "${name_var}" '%s' "${name}"
  printf -v "${email_var}" '%s' "${email}"
}

prompt_default_identity() {
  local default_identity

  while true; do
    read -r -p "Default Git identity on this machine (personal/work): " default_identity
    case "${default_identity}" in
      personal|work)
        printf -v "$1" '%s' "${default_identity}"
        return 0
        ;;
      *)
        echo "Please enter 'personal' or 'work'."
        ;;
    esac
  done
}

mkdir -p "${SCRIPT_DIR}/git"

[[ $# -ge 1 ]] || usage

mode="$1"
shift

case "${mode}" in
  single)
    if [[ $# -eq 2 ]]; then
      name="$1"
      email="$2"
    elif [[ $# -eq 0 ]]; then
      prompt_identity "personal" name email
    else
      usage
    fi

    cp "${SCRIPT_DIR}/gitconfig-base" "${SCRIPT_DIR}/git/.gitconfig-base"

    render_template \
      "${SCRIPT_DIR}/gitconfig.tmpl" \
      "${SCRIPT_DIR}/git/.gitconfig" \
      "${name}" \
      "${email}"

    render_template \
      "${SCRIPT_DIR}/gitconfig-personal.tmpl" \
      "${SCRIPT_DIR}/git/.gitconfig-personal" \
      "${name}" \
      "${email}"

    echo "Generated git/.gitconfig, git/.gitconfig-base, and git/.gitconfig-personal"
    ;;

  multi)
    if [[ $# -eq 5 ]]; then
      default_identity="$1"
      personal_name="$2"
      personal_email="$3"
      work_name="$4"
      work_email="$5"
    elif [[ $# -eq 4 ]]; then
      default_identity="work"
      personal_name="$1"
      personal_email="$2"
      work_name="$3"
      work_email="$4"
    elif [[ $# -eq 0 ]]; then
      prompt_default_identity default_identity
      prompt_identity "personal" personal_name personal_email
      prompt_identity "work" work_name work_email
    else
      usage
    fi

    case "${default_identity}" in
      personal|work) ;;
      *) usage ;;
    esac

    cp "${SCRIPT_DIR}/gitconfig-base" "${SCRIPT_DIR}/git/.gitconfig-base"

    render_template \
      "${SCRIPT_DIR}/gitconfig-multi.tmpl" \
      "${SCRIPT_DIR}/git/.gitconfig" \
      "" \
      "" \
      "${default_identity}"

    render_template \
      "${SCRIPT_DIR}/gitconfig-personal.tmpl" \
      "${SCRIPT_DIR}/git/.gitconfig-personal" \
      "${personal_name}" \
      "${personal_email}"

    render_template \
      "${SCRIPT_DIR}/gitconfig-work.tmpl" \
      "${SCRIPT_DIR}/git/.gitconfig-work" \
      "${work_name}" \
      "${work_email}"

    echo "Generated git/.gitconfig, git/.gitconfig-base, git/.gitconfig-personal, and git/.gitconfig-work"
    ;;

  *)
    usage
    ;;
esac
