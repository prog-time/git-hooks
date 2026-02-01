# Git Hooks Collection

A collection of reusable git hook scripts for automating code quality checks and developer workflows.

## Features

- **PHP/Laravel**: PHPStan analysis with progressive error reduction, Pint code style fixing, test coverage validation
- **Docker**: Dockerfile linting with Hadolint
- **Shell**: Script validation with ShellCheck
- **Git**: Branch naming conventions, automatic task ID injection in commits

## Quick Start

1. Clone the repository
2. Copy desired scripts to your project's `.git/hooks/` directory
3. Make scripts executable: `chmod +x .git/hooks/*`

## Available Scripts

### PHP

| Script | Description |
|--------|-------------|
| `php/check_phpstan.sh` | Runs PHPStan with progressive error reduction. Tracks error count per file and allows commits only when errors decrease. |
| `php/laravel/check_pint.sh` | Runs Laravel Pint, auto-fixes code style issues, and stages corrected files. |
| `php/find_test.sh` | Validates that modified PHP classes have corresponding unit tests. |
| `php/start_test_in_docker.sh` | Runs PHPUnit tests inside Docker for modified files. |

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

### PHPStan with Progressive Error Reduction

```bash
# Default mode: requires error count to decrease by at least 1
./php/check_phpstan.sh default src/Service.php src/Helper.php

# Strict mode: requires zero errors
./php/check_phpstan.sh strict src/Service.php
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

FILES=$(git diff --cached --name-only --diff-filter=ACM)
PHP_FILES=$(echo "$FILES" | grep '\.php$')
SH_FILES=$(echo "$FILES" | grep '\.sh$')

[[ -n "$PHP_FILES" ]] && ./php/check_phpstan.sh default $PHP_FILES
[[ -n "$SH_FILES" ]] && ./scripts/check_shellcheck.sh $SH_FILES
```

## Testing

```bash
# Run all tests
./tests/run_all.sh

# Run specific test suite
./tests/php/phpstan/run.sh
```

## Requirements

- Bash 4.0+
- Git
- jq
- PHP 8.1+ with Composer (for PHP hooks)
- Docker (optional)
- ShellCheck (for shell validation)

## License

MIT
