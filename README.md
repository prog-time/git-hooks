# Git Hooks Collection

A collection of reusable git hook scripts for automating code quality checks and developer workflows.

## Features

- **JavaScript/TypeScript**: ESLint, Prettier, TypeScript type checking, Vitest test runner, test existence validation
- **Python**: Flake8 linting, Mypy static analysis, Pytest runner, service test validation (local and Docker modes)
- **PHP/Laravel**: PHPStan analysis with progressive error reduction, Pint code style fixing, test coverage validation
- **CSS/SCSS/Less**: Stylelint code style validation
- **HTML**: HTMLHint linting
- **Markdown**: markdownlint style validation
- **YAML**: yamllint style validation
- **Docker**: Dockerfile linting with Hadolint
- **Shell**: Script validation with ShellCheck
- **Git**: Branch naming conventions, automatic task ID injection in commits

## Quick Start

1. Clone the repository
2. Copy desired scripts to your project's `.git/hooks/` directory
3. Make scripts executable: `chmod +x .git/hooks/*`

## Available Scripts

### JavaScript / TypeScript

| Script | Description |
|--------|-------------|
| `javascript/check_eslint_all.sh` | Runs ESLint with `--fix` across the entire project (`app/`, `components/`, `lib/`, `types/`). |
| `javascript/check_prettier.sh` | Runs Prettier on staged `.ts` files passed as arguments. |
| `javascript/check_prettier_all.sh` | Runs Prettier on all TypeScript files using glob patterns. |
| `javascript/check_tsc_all.sh` | Runs TypeScript type checking via `tsconfig.check.json`. |
| `javascript/check_vitest.sh` | Runs Vitest for specified files or the full suite. Supports `--watch` and `--coverage`. |
| `javascript/check_vitest_all.sh` | Runs the full Vitest test suite. |
| `javascript/check_tests.sh` | Runs Vitest only for changed/staged TypeScript files, auto-discovers matching test files. |
| `javascript/check_tests_all.sh` | Runs the full Vitest test suite (simple wrapper). |
| `javascript/check_test_coverage.sh` | Runs Vitest with optional `--watch` and `--coverage` flags. |
| `javascript/check_tests_exist.sh` | Validates that each staged TypeScript source file has a corresponding `tests/...test.ts` file. |

### Python

| Script | Description |
|--------|-------------|
| `python/check_flake8.sh` | Runs Flake8 locally on Python files (line length 120). |
| `python/check_flake8_in_docker.sh` | Runs Flake8 inside the `app_dev` Docker container. |
| `python/check_mypy.sh` | Runs Mypy locally on changed `app/*.py` files. |
| `python/check_mypy_in_docker.sh` | Runs Mypy inside the Docker container, maps host/container paths. |
| `python/check_pytest.sh` | Runs the full Pytest suite locally with `PYTHONPATH=./app`. |
| `python/check_pytest_in_docker.sh` | Runs Pytest inside the Docker container, converts container paths to host paths. |
| `python/find_test.sh` | Validates that each service in `app/services/` has exactly one corresponding test file. |

### PHP

| Script | Description |
|--------|-------------|
| `php/check_phpstan.sh` | Runs PHPStan with progressive error reduction. Tracks error count per file and allows commits only when errors decrease. |
| `php/laravel/check_pint.sh` | Runs Laravel Pint, auto-fixes code style issues, and stages corrected files. |
| `php/find_test.sh` | Validates that modified PHP classes have corresponding unit tests. |
| `php/start_test_in_docker.sh` | Runs PHPUnit tests inside Docker for modified files. |

### CSS / SCSS / Less

| Script | Description |
|--------|-------------|
| `css/check_stylelint.sh` | Runs Stylelint on staged CSS/SCSS/Less files passed as arguments. |
| `css/check_stylelint_all.sh` | Runs Stylelint on all CSS/SCSS/Less files in the project. Used in pre-push hooks. |

### HTML

| Script | Description |
|--------|-------------|
| `html/check_htmlhint.sh` | Runs HTMLHint on staged HTML files passed as arguments. |
| `html/check_htmlhint_all.sh` | Runs HTMLHint on all HTML files in the project. Used in pre-push hooks. |

### Markdown

| Script | Description |
|--------|-------------|
| `markdown/check_markdownlint.sh` | Runs markdownlint on staged `.md` files passed as arguments. |
| `markdown/check_markdownlint_all.sh` | Runs markdownlint on all `.md` files in the project. Used in pre-push hooks. |

### YAML

| Script | Description |
|--------|-------------|
| `yml/check_yamllint.sh` | Runs yamllint on staged `.yml`/`.yaml` files passed as arguments. |
| `yml/check_yamllint_all.sh` | Runs yamllint on all `.yml`/`.yaml` files in the project. Used in pre-push hooks. |

### Git Workflow

| Script | Description |
|--------|-------------|
| `git/check_branch_name.sh` | Validates branch names match pattern: `{type}/{task-id}_{description}` |
| `git/preparations/add_task_id_in_commit.sh` | Prepends task ID from branch name to commit message. |
| `git/preparations/prepare-commit-description.sh` | Appends list of changed files to commit message. |

### Docker

| Script | Description |
|--------|-------------|
| `docker/check_hadolint.sh` | Lints Dockerfiles using Hadolint. |

### Shell

| Script | Description |
|--------|-------------|
| `shell/check_shellcheck.sh` | Validates shell scripts using ShellCheck (via Docker). |
| `scripts/check_shellcheck.sh` | Validates shell scripts using ShellCheck (local). |

## Usage Examples

### JavaScript/TypeScript

```bash
# ESLint — fix entire project
./javascript/check_eslint_all.sh

# Prettier — format specific files
./javascript/check_prettier.sh app/utils.ts lib/helpers.ts

# TypeScript type check
./javascript/check_tsc_all.sh

# Run tests for changed files (auto-discovers matching test files)
./javascript/check_tests.sh app/utils.ts app/helpers.ts

# Run Vitest with coverage
./javascript/check_vitest.sh --coverage

# Run Vitest for specific files in watch mode
./javascript/check_vitest.sh app/utils.ts --watch

# Verify test files exist for staged sources
./javascript/check_tests_exist.sh app/utils.ts components/Header.tsx
```

### Python

```bash
# Flake8 — local
./python/check_flake8.sh app/services/user_service.py app/routes/api.py

# Flake8 — in Docker
./python/check_flake8_in_docker.sh app/services/user_service.py

# Mypy — local
./python/check_mypy.sh app/services/auth.py app/models/user.py

# Mypy — in Docker
./python/check_mypy_in_docker.sh app/services/auth.py

# Pytest — local
./python/check_pytest.sh

# Pytest — in Docker
./python/check_pytest_in_docker.sh

# Verify test files exist for services
./python/find_test.sh app/services/user_service.py app/services/auth.py
```

### PHPStan with Progressive Error Reduction

```bash
# Default mode: requires error count to decrease by at least 1
./php/check_phpstan.sh default src/Service.php src/Helper.php

# Strict mode: requires zero errors
./php/check_phpstan.sh strict src/Service.php
```

### CSS / SCSS / Less

```bash
# Check staged files
./css/check_stylelint.sh styles/main.css components/button.scss

# Check all files in the project
./css/check_stylelint_all.sh
```

### HTML

```bash
# Check staged files
./html/check_htmlhint.sh templates/index.html templates/layout.html

# Check all files in the project
./html/check_htmlhint_all.sh
```

### Markdown

```bash
# Check staged files
./markdown/check_markdownlint.sh README.md docs/guide.md

# Check all files in the project
./markdown/check_markdownlint_all.sh
```

### YAML

```bash
# Check staged files
./yml/check_yamllint.sh .github/workflows/ci.yml docker-compose.yml

# Check all files in the project
./yml/check_yamllint_all.sh
```

### Branch Name Validation

```bash
# In pre-commit hook
./git/check_branch_name.sh
# Valid: feature/dev-123_user_auth, bugfix/issue-456_fix_login
# Invalid: main, my-branch, feature/no_task_id
```

### Task ID in Commits

```bash
# In prepare-commit-msg hook
./git/preparations/add_task_id_in_commit.sh
# Branch: feature/dev-123_new_feature
# Commit: "add validation" → "dev-123 | add validation"
```

## Integration

### Pre-commit Hook Example

```bash
#!/bin/bash
# .git/hooks/pre-commit

set -e

FILES=$(git diff --cached --name-only --diff-filter=ACM)

# JavaScript/TypeScript
bash javascript/check_eslint_all.sh
bash javascript/check_prettier.sh $FILES
bash javascript/check_tests_exist.sh $FILES
bash javascript/check_tests.sh $FILES

# Python (local)
bash python/check_flake8.sh $FILES
bash python/check_mypy.sh $FILES
bash python/find_test.sh $FILES

# Python (Docker) — use instead of local variants if project runs in Docker
# bash python/check_flake8_in_docker.sh $FILES
# bash python/check_mypy_in_docker.sh $FILES
# bash python/check_pytest_in_docker.sh

# PHP
PHP_FILES=$(echo "$FILES" | grep '\.php$' || true)
[[ -n "$PHP_FILES" ]] && bash php/check_phpstan.sh default $PHP_FILES

# CSS/SCSS/Less
bash css/check_stylelint.sh $FILES

# HTML
bash html/check_htmlhint.sh $FILES

# Markdown
bash markdown/check_markdownlint.sh $FILES

# YAML
bash yml/check_yamllint.sh $FILES

# Shell
SH_FILES=$(echo "$FILES" | grep '\.sh$' || true)
[[ -n "$SH_FILES" ]] && bash scripts/check_shellcheck.sh $SH_FILES
```

## Testing

```bash
# Run all tests
./tests/run_all.sh

# Run specific test suite
./tests/php/phpstan/run.sh
./tests/javascript/tests_exist/run.sh
./tests/javascript/eslint_all/run.sh
./tests/javascript/vitest/run.sh
./tests/python/flake8/run.sh
./tests/python/mypy/run.sh
./tests/python/find_test/run.sh
./tests/css/stylelint/run.sh
./tests/css/stylelint_all/run.sh
./tests/html/htmlhint/run.sh
./tests/html/htmlhint_all/run.sh
./tests/markdown/markdownlint/run.sh
./tests/markdown/markdownlint_all/run.sh
./tests/yml/yamllint/run.sh
./tests/yml/yamllint_all/run.sh
```

## Requirements

- Bash 4.0+
- Git
- jq
- Node.js with npx (for JavaScript/TypeScript, CSS, HTML hooks)
- Python 3, Flake8, Mypy, Pytest (for Python hooks)
- PHP 8.1+ with Composer (for PHP hooks)
- Stylelint (`npm install -g stylelint`) or via `npx`
- HTMLHint (`npm install -g htmlhint`) or via `npx`
- markdownlint-cli (`npm install -g markdownlint-cli`)
- yamllint (`pip install yamllint` or system package)
- Docker (optional, for Docker-based hooks)
- ShellCheck (for shell validation)

## License

MIT
