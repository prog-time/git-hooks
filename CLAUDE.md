# CLAUDE.md

## Project Overview

A collection of reusable git hook scripts for automating code quality checks. Covers JavaScript/TypeScript, Python, PHP/Laravel, CSS, HTML, Markdown, YAML, Docker, shell scripts, and general-purpose checks (spelling, JSON, secret detection, shell formatting).

## Directory Structure

```
css/                        # CSS/SCSS/Less hooks
├── check_stylelint.sh      # Stylelint for staged files
└── check_stylelint_all.sh  # Stylelint for entire project

docker/                     # Docker-related hooks
└── check_hadolint.sh       # Dockerfile linter

git/                        # Git workflow hooks
├── check_branch_name.sh    # Branch naming convention validator
├── check_gitleaks.sh       # Secret detection in staged changes (optional)
├── check_gitleaks_all.sh   # Secret detection in full repository history
└── preparations/           # Commit message enhancers
    ├── add_task_id_in_commit.sh
    └── prepare-commit-description.sh

html/                       # HTML hooks
├── check_htmlhint.sh       # HTMLHint for staged files
└── check_htmlhint_all.sh   # HTMLHint for entire project

javascript/                 # JavaScript/TypeScript hooks
├── check_eslint_all.sh     # ESLint across the project
├── check_prettier.sh       # Prettier on staged files
├── check_prettier_all.sh   # Prettier on all TS files
├── check_tsc_all.sh        # TypeScript type checking
├── check_vitest.sh         # Vitest runner
├── check_vitest_all.sh     # Full Vitest suite
├── check_tests.sh          # Vitest for changed files
├── check_tests_all.sh      # Full Vitest suite (wrapper)
├── check_test_coverage.sh  # Vitest with coverage
└── check_tests_exist.sh    # Test file existence validator

markdown/                   # Markdown hooks
├── check_markdownlint.sh     # markdownlint for staged files
└── check_markdownlint_all.sh # markdownlint for entire project

php/                        # PHP/Laravel hooks
├── check_phpstan.sh        # PHPStan with progressive error reduction
├── find_test.sh            # Unit test coverage validator
├── start_test_in_docker.sh # Run PHPUnit tests in Docker
└── laravel/
    └── check_pint.sh       # Laravel Pint code style fixer

python/                     # Python hooks
├── check_flake8.sh         # Flake8 linting (local)
├── check_flake8_in_docker.sh # Flake8 (Docker)
├── check_mypy.sh           # Mypy type checking (local)
├── check_mypy_in_docker.sh # Mypy (Docker)
├── check_pytest.sh         # Pytest (local)
├── check_pytest_in_docker.sh # Pytest (Docker)
├── check_ruff.sh           # Ruff linter for staged files
├── check_ruff_all.sh       # Ruff linter for entire project
└── find_test.sh            # Service test existence validator

shell/                      # Shell script validation
├── check_shellcheck.sh     # ShellCheck via Docker
├── check_shfmt.sh          # shfmt formatting check for staged files
└── check_shfmt_all.sh      # shfmt formatting check for entire project

simple/                     # General-purpose hooks
├── check_codespell.sh      # Spelling check for staged files
├── check_codespell_all.sh  # Spelling check for entire project
├── check_json_validate.sh  # JSON syntax validation for staged files
└── check_json_validate_all.sh # JSON syntax validation for entire project

scripts/                    # Local utility scripts
├── check_shellcheck.sh     # ShellCheck (local execution)
└── pre-commit-check.sh     # Pre-commit orchestrator

yml/                        # YAML hooks
├── check_yamllint.sh       # yamllint for staged files
└── check_yamllint_all.sh   # yamllint for entire project

tests/                      # Test framework
├── run_all.sh              # Run all test suites
├── lib/test_helper.bash    # Test utilities and assertions
├── css/                    # CSS hook tests
├── git/                    # Git hook tests (gitleaks)
├── html/                   # HTML hook tests
├── javascript/             # JavaScript hook tests
├── markdown/               # Markdown hook tests
├── php/                    # PHP hook tests
├── python/                 # Python hook tests (flake8, mypy, ruff, pytest, find_test)
├── shell/                  # Shell hook tests (shfmt)
├── simple/                 # Simple hook tests (codespell, json_validate)
└── yml/                    # YAML hook tests
```

## Script Conventions

### Input Format
All scripts receive files to check as a list of arguments:
```bash
./php/check_phpstan.sh default file1.php file2.php
```

### Script Header
Every script must start with a description block after the shebang:

```bash
#!/bin/bash
# ------------------------------------------------------------------------------
# Brief description of what the script does.
# Input format and expected arguments.
# Exit conditions (success/failure criteria).
# ------------------------------------------------------------------------------
```

**Requirements:**
- Language: English
- Format: comments inside `# ---...---` delimiters
- Content: 3-5 lines describing:
  - What the script does (main action)
  - Input format (files/arguments)
  - Success/failure conditions (exit codes)

## Dependencies

- Bash 4.0+, Git, jq
- Node.js with npx (for JavaScript/TypeScript, CSS, HTML hooks)
- Python 3, Flake8, Mypy, Pytest (for Python hooks)
- Ruff (`pip install ruff`) for `python/check_ruff.sh`
- Codespell (`pip install codespell`) for `simple/check_codespell.sh`
- PHP 8.1+, Composer (for PHPStan/Pint)
- Stylelint via npx (for CSS hooks)
- HTMLHint via npx (for HTML hooks)
- markdownlint-cli (for Markdown hooks)
- yamllint (for YAML hooks)
- shfmt (`go install mvdan.cc/sh/v3/cmd/shfmt@latest` or `brew install shfmt`) for `shell/check_shfmt.sh`
- gitleaks (optional, see [install guide](https://github.com/gitleaks/gitleaks#installing)) for `git/check_gitleaks.sh`
- Docker (optional, for containerized checks)
- ShellCheck (for shell validation)

## Testing

Run all tests:
```bash
./tests/run_all.sh
```

Run specific test suite:
```bash
./tests/php/phpstan/run.sh
```

## CI/CD

GitHub Actions (`.github/workflows/tests.yml`):
- ShellCheck linting on all scripts
- Unit tests execution
- Triggered on PR and push to main
