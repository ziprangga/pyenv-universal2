#!/usr/bin/env bash

# Test script for pyenv-universal2

UNIVERSAL2_COMMAND="$(pyenv root)/plugins/pyenv-universal2/bin/pyenv-universal2"
PYTHON_VERSION="3.11.5"
TEST_SUFFIX="test"
LOG_FILE="universal2-test.log"
DRY_RUN="--dry-run"

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

log() {
    echo -e "${GREEN}[TEST] $1${RESET}"
}

error() {
    echo -e "${RED}[ERROR] $1${RESET}" >&2
    exit 1
}

assert_success() {
    local exit_code="$1"
    local test_desc="$2"

    if [[ "$exit_code" -eq 0 ]]; then
        log "✔ PASS: $test_desc"
    else
        error "✖ FAIL: $test_desc (Exit code: $exit_code)"
    fi
}

assert_failure() {
    local exit_code="$1"
    local test_desc="$2"

    if [[ "$exit_code" -ne 0 ]]; then
        log "✔ PASS (expected failure): $test_desc"
    else
        error "✖ FAIL (expected failure): $test_desc (Exit code: $exit_code)"
    fi
}

run_test() {
    local test_desc="$1"
    shift
    local command="$@"

    log "Running: $command"
    # eval "$command" >> "$LOG_FILE" 2>&1
    eval "$command"
    local exit_code=$?

    # echo "-----------------------------------" >> "$LOG_FILE"
    # echo "[COMMAND]: $command" >> "$LOG_FILE"
    # echo "[EXIT CODE]: $exit_code" >> "$LOG_FILE"
    # echo "-----------------------------------" >> "$LOG_FILE"

    assert_success "$exit_code" "$test_desc"
}

run_fail_test() {
    local test_desc="$1"
    shift
    local command="$@"

    log "Running (expecting failure): $command"
    # eval "$command" >> "$LOG_FILE" 2>&1
    eval "$command"
    local exit_code=$?

    # echo "-----------------------------------" >> "$LOG_FILE"
    # echo "[COMMAND]: $command" >> "$LOG_FILE"
    # echo "[EXIT CODE]: $exit_code" >> "$LOG_FILE"
    # echo "-----------------------------------" >> "$LOG_FILE"

    assert_failure "$exit_code" "$test_desc"
}

# Start tests
log "Starting pyenv-universal2 tests..."

# Ensure the script is executable
chmod +x "$UNIVERSAL2_COMMAND"

# Version check
run_test "Check pyenv-universal2 version" "$UNIVERSAL2_COMMAND version"

# Help command
run_test "Check help output" "$UNIVERSAL2_COMMAND help"

# Build dry-run
run_test "Test 'build' dry-run" "$UNIVERSAL2_COMMAND build $PYTHON_VERSION $DRY_RUN --suffix=$TEST_SUFFIX"

# Single architecture build dry-run
run_test "Test 'arm64' build dry-run" "$UNIVERSAL2_COMMAND arm64 $PYTHON_VERSION $DRY_RUN --suffix=$TEST_SUFFIX"
run_test "Test 'x86_64' build dry-run" "$UNIVERSAL2_COMMAND x86_64 $PYTHON_VERSION $DRY_RUN --suffix=$TEST_SUFFIX"

# Merge dry-run
run_test "Test 'merge' dry-run" "$UNIVERSAL2_COMMAND merge $PYTHON_VERSION $DRY_RUN --suffix=$TEST_SUFFIX"

# Test failure: Missing Python version
run_fail_test "Test 'build' without Python version (should fail)" "$UNIVERSAL2_COMMAND build"

# Test invalid command
run_fail_test "Test unknown command (should fail)" "$UNIVERSAL2_COMMAND unknown_command"

log "All tests completed!"
