#!/bin/bash
set -e

BUILD_DIR="poky/build"
LOG_FILE="$BUILD_DIR/bitbake-cookerdaemon.log"

echo "🔍 Checking Yocto build status..."

# Check if bitbake is running
if pgrep -f bitbake > /dev/null; then
    echo "🟢 BitBake is currently running."
else
    echo "🟡 BitBake is not running."
fi

# Show task progress if available
if [ -f "$LOG_FILE" ]; then
    echo ""
    echo "📊 Task Progress:"
    grep -E "Running tasks|NOTE: Tasks Summary" "$LOG_FILE" | tail -n 5
else
    echo "⚠️  No BitBake log found at $LOG_FILE"
fi

# Show disk usage
echo ""
echo "💾 Disk usage of build directory:"
du -sh "$BUILD_DIR/tmp" "$BUILD_DIR/sstate-cache" 2>/dev/null || echo "  (build artifacts not yet created)"

# Show failed tasks if any
FAILED_LOG="$BUILD_DIR/tmp/log/error-report/error_report.json"
if [ -f "$FAILED_LOG" ]; then
    echo ""
    echo "❌ Build errors detected:"
    jq -r '.errors[]?.task' "$FAILED_LOG"
else
    echo ""
    echo "✅ No recorded task failures."
fi

