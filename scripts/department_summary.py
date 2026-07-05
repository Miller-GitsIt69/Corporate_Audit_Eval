# Purposefully broken: troubleshoot this file.
# Business requirement:
#   Count valid employee records by department.
#   Ignore malformed records and records with non-numeric inactivity values.

department_counts = {}

with open("data/employees.txt", "r") as file:
    for line in file:
        line = line.strip()

        if line == "":
            continue

        parts = line.split(",")

        if len(parts) != 3:
            continue

        username = parts[0]
        department = parts[1]
        days = parts[2]

        if not days.isdigit():
            continue

        if department in department_counts:
            department_counts[department] += 1
        else:
            department_counts[department] = 1           # Corrected: original code was "department_counts[department] = 0" (should be 1) 

print("******** DEPARTMENT SUMMARY ********")
print("==================")

for department, count in department_counts.items():      # Corrected: original code was "for department, count in department_counts:" (should be .items())
    print(f"{department}: {count}")