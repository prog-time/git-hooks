# CLAUDE.md

## Project Overview

A collection of reusable git hook scripts for automating code quality checks. Main focus: PHP/Laravel (PHPStan, Pint), shell script validation (ShellCheck), Docker linting, and commit message enhancement.

## Directory Structure

```
docker/                     # Docker-related hooks
├── check_hadolint.sh       # Dockerfile linter

git/                        # Git workflow hooks
├── check_branch_name.sh    # Branch naming convention validator
└── preparations/           # Commit message enhancers
    ├── add_task_id_in_commit.sh
    └── prepare-commit-description.sh

php/                        # PHP/Laravel hooks
├── check_phpstan.sh        # PHPStan with progressive error reduction
├── find_test.sh            # Unit test coverage validator
├── start_test_in_docker.sh # Run PHPUnit tests in Docker
└── laravel/
    └── check_pint.sh       # Laravel Pint code style fixer

shell/                      # Shell script validation
└── check_shellcheck.sh     # ShellCheck via Docker

scripts/                    # Local utility scripts
├── check_shellcheck.sh     # ShellCheck (local execution)
└── pre-commit-check.sh     # Pre-commit orchestrator

tests/                      # Test framework
├── run_all.sh              # Run all test suites
├── lib/test_helper.bash    # Test utilities and assertions
└── php/phpstan/            # PHPStan hook tests
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
- PHP 8.1+, Composer (for PHPStan/Pint)
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
