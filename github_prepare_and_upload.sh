#!/usr/bin/env bash

###############################################################################
# COMPLETE GITHUB PREPARATION AND UPLOAD WORKFLOW
###############################################################################
#
# Repository:
#   https://github.com/joaoordine/Sia-Genomic-Survey-on-Skin-Microbes
#
# This script performs the complete publication workflow in a controlled order:
#
#   1. Audit the 113-GiB research directory.
#   2. Prepare the local Git repository.
#   3. Apply .gitignore and exclude files that GitHub cannot accept.
#   4. Stage the publishable notebooks, scripts, tables, figures and metadata.
#   5. Display Git status and a summary of the staged changes.
#   6. Pause and ask whether the staged snapshot should be uploaded.
#   7. Exit without committing when the answer is no.
#   8. Commit and push to GitHub when the answer is yes.
#
# Nothing is force-pushed. Existing remote history is preserved.
#
# Usage:
#
#   ./github_prepare_and_upload.sh
#
# Custom commit message:
#
#   ./github_prepare_and_upload.sh \
#     --message "Initial release of SIA genomic survey analyses"
#
# Non-interactive execution, for example after reviewing with a previous run:
#
#   ./github_prepare_and_upload.sh --yes \
#     --message "Update genomic survey analyses"
#
###############################################################################

# Stop on errors, undefined variables and failed pipeline commands.
set -Eeuo pipefail

# Resolve the project directory from the location of this script. The workflow
# therefore works even if it is invoked from somewhere else.
readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly PUBLISH_SCRIPT="${SCRIPT_DIR}/publish_to_github.sh"
readonly REPOSITORY_PAGE="https://github.com/joaoordine/Sia-Genomic-Survey-on-Skin-Microbes"

# Default values can be replaced with command-line options below.
commit_message="Publish SIA genomic survey analyses"
automatic_yes="false"

usage() {
  cat <<'EOF'
Usage:
  ./github_prepare_and_upload.sh [options]

Options:
  -m, --message TEXT   Git commit message
  -y, --yes            Upload without the interactive confirmation
  -h, --help           Display this help

Without --yes, the script pauses after displaying the staged changes. Answering
anything other than "yes" exits without committing or uploading.
EOF
}

die() {
  printf '\nERROR: %s\n' "$*" >&2
  exit 1
}

# Read the optional commit message and non-interactive confirmation flag.
while (($#)); do
  case "$1" in
    -m|--message)
      shift
      (($#)) || die "A commit message must follow --message."
      commit_message="$1"
      ;;
    -y|--yes)
      automatic_yes="true"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $1. Run with --help for usage."
      ;;
  esac
  shift
done

cd "$SCRIPT_DIR"

# The detailed Git and file-safety operations are maintained in one underlying
# script so audit, preparation and upload always use identical rules.
[[ -f "$PUBLISH_SCRIPT" ]] ||
  die "Required publishing engine not found: ${PUBLISH_SCRIPT}"

[[ -x "$PUBLISH_SCRIPT" ]] ||
  die "Run: chmod +x '${PUBLISH_SCRIPT}'"

###############################################################################
# STEP 1 — READ-ONLY AUDIT
###############################################################################

printf '\n============================================================\n'
printf 'STEP 1/4 — AUDIT THE PROJECT\n'
printf '============================================================\n\n'

# Reports source size, file count and files above the GitHub size threshold.
# This command does not initialise Git or change project files.
"$PUBLISH_SCRIPT" --check

###############################################################################
# STEP 2 — PREPARE AND STAGE
###############################################################################

printf '\n============================================================\n'
printf 'STEP 2/4 — PREPARE THE REPOSITORY AND STAGE FILES\n'
printf '============================================================\n\n'

# This step:
#   - initialises Git if required;
#   - verifies the exact GitHub origin;
#   - preserves an existing remote main branch;
#   - generates GITHUB_EXCLUDED_LARGE_FILES.tsv;
#   - searches for likely credential files;
#   - applies .gitignore;
#   - stages publishable files;
#   - refuses files >=99 MiB or an excessively large staged snapshot.
#
# It does not commit or push.
"$PUBLISH_SCRIPT" --prepare

###############################################################################
# STEP 3 — REVIEW GIT STATUS
###############################################################################

printf '\n============================================================\n'
printf 'STEP 3/4 — REVIEW THE STAGED SNAPSHOT\n'
printf '============================================================\n\n'

printf '%s\n\n' 'Git status:'
git status --short --branch

printf '\n%s\n\n' 'Summary of staged changes:'
git diff --cached --stat

staged_files="$(git diff --cached --name-only | wc -l)"

printf '\nFiles staged for publication: %s\n' "$staged_files"
printf 'Commit message: %s\n' "$commit_message"
printf 'Destination: %s\n' "$REPOSITORY_PAGE"

if ((staged_files == 0)); then
  printf '\nThere are no new staged changes to publish.\n'
  printf 'The script will still check whether a previously existing commit needs pushing.\n'
fi

###############################################################################
# CONFIRMATION — UPLOAD OR EXIT SAFELY
###############################################################################

if [[ "$automatic_yes" != "true" ]]; then
  printf '\nPlease review the status and summary above.\n'
  printf 'Type "yes" to commit and upload, or press Enter/type "no" to exit: '
  read -r confirmation

  if [[ "${confirmation,,}" != "yes" ]]; then
    printf '\nUpload cancelled. No commit was created and nothing was pushed.\n'
    printf 'The reviewed files remain staged locally.\n'
    printf 'You may inspect them with:\n'
    printf '  git status\n'
    printf '  git diff --cached --stat\n'
    printf '\nRun this script again whenever you are ready.\n'
    exit 0
  fi
fi

###############################################################################
# STEP 4 — COMMIT AND UPLOAD
###############################################################################

printf '\n============================================================\n'
printf 'STEP 4/4 — COMMIT AND UPLOAD TO GITHUB\n'
printf '============================================================\n\n'

# The publishing engine re-runs its safeguards before committing. It then:
#   - creates the commit when staged changes exist;
#   - rebases on a remote main branch when one exists;
#   - pushes main without force;
#   - establishes origin/main as the upstream branch.
"$PUBLISH_SCRIPT" --push --message "$commit_message"

printf '\n============================================================\n'
printf 'UPLOAD WORKFLOW COMPLETED\n'
printf '============================================================\n\n'
printf 'Repository: %s\n' "$REPOSITORY_PAGE"
