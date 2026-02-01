# Tests

## Structure

```
tests/
├── run_all.sh              # Run all tests
├── lib/
│   └── test_helper.bash    # Common test functions
├── php/phpstan/            # PHPStan hook tests
├── shell/                  # Shell script tests
├── docker/                 # Docker hook tests
└── simple/                 # Simple validator tests
```

## Running Tests

```bash
# Run all tests
./tests/run_all.sh

# Run specific test suite
./tests/php/phpstan/run.sh

# Run single test case
./tests/php/phpstan/cases/01_new_file_blocks_commit.sh
```

## Writing Tests

Each test case should:
1. Source `test_helper.bash`
2. Call `setup_test_env` to create isolated environment
3. Create fixtures and mocks as needed
4. Run the hook with `run_hook`
5. Assert results with `assert_*` functions
6. Call `cleanup_test_env` (automatic on exit)

## Test Case Template

```bash
#!/bin/bash
source "$(dirname "$0")/../../lib/test_helper.bash"

setup_test_env

# ... test logic ...

assert_exit_code 0
cleanup_test_env
```
