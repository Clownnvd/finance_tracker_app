#!/bin/bash
#
# Coverage Gate Script
# Fails CI if line coverage is below threshold
#
# Usage: ./scripts/check_coverage.sh [threshold]
# Example: ./scripts/check_coverage.sh 80
#

set -e

THRESHOLD=${1:-80}
LCOV_FILE="coverage/lcov.info"

echo "============================================"
echo "Coverage Gate Check"
echo "============================================"
echo "Threshold: ${THRESHOLD}%"
echo ""

# Check if lcov.info exists
if [ ! -f "$LCOV_FILE" ]; then
    echo "ERROR: Coverage file not found: $LCOV_FILE"
    echo "Run 'flutter test --coverage' first."
    exit 1
fi

# Calculate coverage using awk (no external dependencies)
COVERAGE=$(awk -F: '
    /^DA:/ {
        split($2, a, ",");
        total++;
        if (a[2] > 0) covered++;
    }
    END {
        if (total > 0) {
            printf "%.1f", (covered / total) * 100;
        } else {
            print "0.0";
        }
    }
' "$LCOV_FILE")

echo "Current coverage: ${COVERAGE}%"
echo ""

# Compare coverage to threshold
PASS=$(awk -v cov="$COVERAGE" -v thresh="$THRESHOLD" 'BEGIN { print (cov >= thresh) ? 1 : 0 }')

if [ "$PASS" -eq 1 ]; then
    echo "PASSED: Coverage ${COVERAGE}% >= ${THRESHOLD}%"
    exit 0
else
    echo "FAILED: Coverage ${COVERAGE}% < ${THRESHOLD}%"
    echo ""
    echo "Please add more tests to increase coverage."
    exit 1
fi
