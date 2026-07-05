# Corporate_Audit_Eval

# Corporate Account Auditor — Troubleshooting Lab

## Scenario

You are a junior automation engineer supporting **NonDescript Financial Services**. The Security Operations team receives a daily CSV export of employee accounts from HR. They need a lightweight internal tool that can:

- classify user accounts by inactivity,
- summarize employee records by department,
- add new employee records,
- generate audit reports, and
- archive reports for a compliance review.

A previous contractor left this prototype in an incomplete and unreliable state. Your task is to troubleshoot and repair it without changing the business requirements.

> **Important:** The project is intentionally broken. It contains both syntax errors and logic errors across Bash and Python. Do not expect it to work on the first run.

---

## Skills Practiced

### Linux / Bash

- navigating a project directory
- executing shell scripts
- `while` loops and `case` statements
- variables and user input
- output redirection
- file copying and archival
- reading error output
- checking generated files with `cat`, `ls`, and `grep`

### Python

- variables and user input
- `if` / `elif` / `else`
- lists and tuples
- reading and appending files
- parsing comma-separated data
- validating input
- troubleshooting `SyntaxError`, `TypeError`, and logic mistakes

---

## Project Structure

```text
corp-audit-troubleshooting-lab/
├── README.md
├── audit_menu.sh
├── evaluate_lab.sh
├── archive/
├── data/
│   └── employees.txt
├── reports/
└── scripts/
    ├── account_audit.py
    ├── add_employee.py
    └── department_summary.py
```

---

## Prerequisites

Verify that Bash and Python 3 are available:

```bash
bash --version
python3 --version
```

On a typical Linux or macOS terminal, make the shell scripts executable:

```bash
chmod +x audit_menu.sh evaluate_lab.sh
```

---

## Setup

Place the project in a writable directory, then enter it:

```bash
cd /path/to/corp-audit-troubleshooting-lab
chmod +x audit_menu.sh evaluate_lab.sh
```

Confirm the files are present:

```bash
find . -maxdepth 2 -type f | sort
```

The source data is located at:

```text
data/employees.txt
```

Each record follows this format:

```text
username,department,days_since_last_login
```

The supplied data deliberately includes blank, malformed, and invalid records. Your repaired scripts must handle these safely.

---

## Run the Broken Application

Start with the orchestration script:

```bash
./audit_menu.sh
```

You may also test each Python component directly:

```bash
python3 scripts/account_audit.py
python3 scripts/department_summary.py
python3 scripts/add_employee.py
```

Read errors carefully. For syntax verification without fully executing a Python script:

```bash
python3 -m py_compile scripts/account_audit.py
python3 -m py_compile scripts/department_summary.py
python3 -m py_compile scripts/add_employee.py
```

For Bash syntax verification:

```bash
bash -n audit_menu.sh
```

---

## Business Requirements

Do not change these requirements while repairing the code.

### 1. Account Audit Rules

Valid records must be classified as follows:

| Days Since Last Login | Status |
|---:|---|
| 0–29 | `ACTIVE` |
| 30–89 | `REVIEW` |
| 90 or more | `DISABLE` |

Malformed records and records with a non-numeric inactivity value must be skipped rather than crashing the program.

The audit report should begin with:

```text
ACCOUNT AUDIT REPORT
====================
```

### 2. Department Summary Rules

Count only valid employee records.

For the supplied source data, the valid departments are:

```text
Sales: 1
Finance: 1
IT: 1
Marketing: 1
Security: 1
```

The summary should begin with:

```text
DEPARTMENT SUMMARY
==================
```

### 3. Add Employee Rules

The add-employee script must:

- prompt for username, department, and days since last login;
- reject a blank username;
- reject a blank department;
- reject non-numeric days;
- append **one** valid CSV record to `data/employees.txt`;
- avoid changing the data file for invalid input.

A valid new employee should be written as:

```text
lgarcia,Legal,44
```

### 4. Bash Orchestration Rules

The menu must run until the user selects option `5`.

| Option | Required Result |
|---:|---|
| `1` | Run `account_audit.py` and write `reports/account_report.txt` |
| `2` | Run `department_summary.py` and write `reports/department_report.txt` |
| `3` | Run `add_employee.py` interactively |
| `4` | Copy available `.txt` reports into `archive/` |
| `5` | Exit with a success status |
| Other input | Display an invalid-selection message and keep the menu open |

---

## Expected Input / Output Scenarios

Treat these like compact programming-challenge test cases. The exact formatting may differ slightly, but the functional result must match.

### Scenario 1 — Account Audit

**Command**

```bash
python3 scripts/account_audit.py
```

**Expected meaningful output**

```text
jdoe | Sales | 5 days | ACTIVE
asmith | Finance | 30 days | REVIEW
bwilson | IT | 12 days | ACTIVE
mjones | Marketing | 95 days | DISABLE
sroberts | Security | 90 days | DISABLE
```

The malformed and invalid source lines must not produce employee-status rows.

---

### Scenario 2 — Department Summary

**Command**

```bash
python3 scripts/department_summary.py
```

**Expected meaningful output**

```text
Sales: 1
Finance: 1
IT: 1
Marketing: 1
Security: 1
```

---

### Scenario 3 — Valid Employee Input

**Input**

```text
Username: lgarcia
Department: Legal
Days since last login: 44
```

**Expected result**

```text
data/employees.txt gains exactly one new line:
lgarcia,Legal,44
```

---

### Scenario 4 — Invalid Employee Input

**Input**

```text
Username:
Department: Legal
Days since last login: 44
```

**Expected result**

```text
The program rejects the input and does not append a record.
```

Try additional invalid inputs, such as a blank department or `abc` for days.

---

### Scenario 5 — Full Orchestration Flow

**Menu input sequence**

```text
1
2
4
5
```

**Expected filesystem result**

```text
reports/account_report.txt
reports/department_report.txt
archive/account_report.txt
archive/department_report.txt
```

---

## Suggested Troubleshooting Order

1. Verify script syntax with `bash -n` and `python3 -m py_compile`.
2. Repair the menu enough to dispatch each selected option.
3. Repair and test `account_audit.py`.
4. Repair and test `department_summary.py`.
5. Repair and test `add_employee.py`.
6. Run the full menu flow.
7. Run the evaluator.

Avoid editing `evaluate_lab.sh` while working through the lab. It is a functional test harness, not a file you need to repair.

---

## Evaluation

After you believe the application works, run:

```bash
./evaluate_lab.sh
```

The evaluator checks:

- account classifications at the 30-day and 90-day boundaries;
- department counts;
- valid and invalid employee input handling;
- report generation through the menu;
- report archival.

It intentionally restores the original employee data and report/archive contents after it completes. A passing result ends with:

```text
Results: 15 passed, 0 failed.
Lab evaluation passed.
```

---

## Resetting the Lab Manually

The evaluator restores files after it runs. For a manual reset, replace the employee data with the original fixture:

```bash
cat << 'EOF' > data/employees.txt
jdoe,Sales,5
asmith,Finance,30
bwilson,IT,12
mjones,Marketing,95
sroberts,Security,90
badline
tclark,HR,not_a_number
format_issue,Legal,18,extra

EOF

rm -f reports/*.txt archive/*.txt
```

---

## Tear Down

When you are finished with the exercise, leave the project directory and remove it:

```bash
cd ..
rm -rf corp-audit-troubleshooting-lab
```

Be careful with `rm -rf`: confirm the current directory and project name before running it.

---

## Optional Instructor Review Prompts

After solving the lab, explain:

1. Which errors prevented execution before runtime?
2. Which errors allowed execution but produced wrong behavior?
3. Why is validating external data important in operational automation?
4. Why can tuples be useful for fixed employee records but not be written directly to a file?
5. Why should an orchestration script validate that expected files exist before archiving?
