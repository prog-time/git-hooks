#!/bin/bash
# ------------------------------------------------------------------------------
# Scans the entire repository history for secrets using gitleaks detect.
# Runs gitleaks detect --redact --exit-code 1 on the full git history.
# Exits 0 with a warning if gitleaks is not installed (optional hook).
# Exits 1 if any secrets are detected; exits 0 on clean scan.
# ------------------------------------------------------------------------------

if ! command -v gitleaks > /dev/null 2>&1; then
  echo "WARNING: gitleaks is not installed. Skipping secret detection."
  echo "Install it with: https://github.com/gitleaks/gitleaks#installing"
  exit 0
fi

OUTPUT=$(gitleaks detect --redact --exit-code 1 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  echo "ERROR: gitleaks detected secrets in repository history!"
  echo "$OUTPUT"
  exit 1
fi

echo "gitleaks: no secrets detected in repository history."
exit 0
