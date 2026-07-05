#!/usr/bin/env bash

# Functional evaluator for the Corporate Audit Troubleshooting Lab.
# Run only after you have attempted to repair the application:
#   ./evaluate_lab.sh
#
# This script temporarily changes lab data and clears generated .txt reports.
# It restores the original data, reports, and archive contents before exiting.

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_ROOT" || exit 1

PASS_COUNT=0
FAIL_COUNT=0
TEMP_DIR="$(mktemp -d)"

pass() {
    echo "PASS - $1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
    echo "FAIL - $1"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

check_contains() {
    local label="$1"
    local content="$2"
    local expected="$3"

    if printf "%s" "$content" | grep -Fq "$expected"; then
        pass "$label"
    else
        fail "$label"
    fi
}

check_file_contains() {
    local label="$1"
    local file="$2"
    local expected="$3"

    if [ -f "$file" ] && grep -Fq "$expected" "$file"; then
        pass "$label"
    else
        fail "$label"
    fi
}

cleanup() {
    if [ -f "$TEMP_DIR/employees.txt" ]; then
        cp "$TEMP_DIR/employees.txt" data/employees.txt
    fi

    rm -f reports/*.txt archive/*.txt

    if [ -d "$TEMP_DIR/reports" ]; then
        cp -R "$TEMP_DIR/reports/." reports/ 2>/dev/null
    fi

    if [ -d "$TEMP_DIR/archive" ]; then
        cp -R "$TEMP_DIR/archive/." archive/ 2>/dev/null
    fi

    rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

mkdir -p data scripts reports archive
cp data/employees.txt "$TEMP_DIR/employees.txt"
mkdir -p "$TEMP_DIR/reports" "$TEMP_DIR/archive"
cp -R reports/. "$TEMP_DIR/reports/" 2>/dev/null
cp -R archive/. "$TEMP_DIR/archive/" 2>/dev/null

rm -f reports/*.txt archive/*.txt

echo "Running functional evaluation..."
echo

# 1. Account-audit output
ACCOUNT_OUTPUT="$(python scripts/account_audit.py 2>&1)"
ACCOUNT_EXIT_CODE=$?

if [ "$ACCOUNT_EXIT_CODE" -eq 0 ]; then
    pass "account_audit.py exits successfully"
else
    fail "account_audit.py exits successfully"
fi

check_contains "account audit marks ACTIVE users" "$ACCOUNT_OUTPUT" "jdoe | Sales | 5 days | ACTIVE"
check_contains "account audit marks REVIEW users at 30 days" "$ACCOUNT_OUTPUT" "asmith | Finance | 30 days | REVIEW"
check_contains "account audit marks DISABLE users at 90 days" "$ACCOUNT_OUTPUT" "sroberts | Security | 90 days | DISABLE"

# 2. Department summary
SUMMARY_OUTPUT="$(python scripts/department_summary.py 2>&1)"
SUMMARY_EXIT_CODE=$?

if [ "$SUMMARY_EXIT_CODE" -eq 0 ]; then
    pass "department_summary.py exits successfully"
else
    fail "department_summary.py exits successfully"
fi

check_contains "department summary counts Sales" "$SUMMARY_OUTPUT" "Sales: 1"
check_contains "department summary counts Security" "$SUMMARY_OUTPUT" "Security: 1"

# 3. Add employee: valid input
ADD_OUTPUT="$(printf 'lgarcia\nLegal\n44\n' | python scripts/add_employee.py 2>&1)"
ADD_EXIT_CODE=$?

if [ "$ADD_EXIT_CODE" -eq 0 ]; then
    pass "add_employee.py accepts valid input"
else
    fail "add_employee.py accepts valid input"
fi

if grep -Fxq "lgarcia,Legal,44" data/employees.txt; then
    pass "add_employee.py appends a valid CSV record"
else
    fail "add_employee.py appends a valid CSV record"
fi

# 4. Add employee: invalid blank username must be rejected without modifying data
cp data/employees.txt "$TEMP_DIR/before_invalid_add.txt"
INVALID_ADD_OUTPUT="$(printf '\nLegal\n44\n' | python scripts/add_employee.py 2>&1)"
INVALID_ADD_EXIT_CODE=$?

if [ "$INVALID_ADD_EXIT_CODE" -eq 0 ] && cmp -s "$TEMP_DIR/before_invalid_add.txt" data/employees.txt; then
    pass "add_employee.py rejects a blank username without changing data"
else
    fail "add_employee.py rejects a blank username without changing data"
fi

# Restore original data before testing menu-driven reports.
cp "$TEMP_DIR/employees.txt" data/employees.txt
rm -f reports/*.txt archive/*.txt

# 5. Orchestration menu and archive flow
MENU_OUTPUT="$(printf '1\n2\n4\n5\n' | bash audit_menu.sh 2>&1)"
MENU_EXIT_CODE=$?

if [ "$MENU_EXIT_CODE" -eq 0 ]; then
    pass "audit_menu.sh exits cleanly after option 5"
else
    fail "audit_menu.sh exits cleanly after option 5"
fi

check_file_contains "menu creates account_report.txt" "reports/account_report.txt" "ACCOUNT AUDIT REPORT"
check_file_contains "menu creates department_report.txt" "reports/department_report.txt" "DEPARTMENT SUMMARY"
check_file_contains "archive contains account_report.txt" "archive/account_report.txt" "ACCOUNT AUDIT REPORT"
check_file_contains "archive contains department_report.txt" "archive/department_report.txt" "DEPARTMENT SUMMARY"

echo
echo "Results: $PASS_COUNT passed, $FAIL_COUNT failed."

if [ "$FAIL_COUNT" -eq 0 ]; then
    echo "Lab evaluation passed."
    exit 0
else
    echo "Lab evaluation failed. Continue troubleshooting the application code."
    exit 1
fi