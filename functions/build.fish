function build
    # Only run on hephaestus (retries up to 3 times for flaky network discovery)
    set -l heph_line (__find_hephaestus)
    if test $status -ne 0
        echo "hephaestus not connected — build only works on hephaestus"
        return 1
    end

    # Find Xcode project
    set -l xcodeproj (ls -d *.xcodeproj 2>/dev/null | head -1)
    if test -z "$xcodeproj"
        echo "No .xcodeproj found in current directory"
        return 1
    end
    set -l scheme (basename "$xcodeproj" .xcodeproj)

    set -l device_line $heph_line
    # Extract UUID (mixed-case)
    set -l uuid (echo "$device_line" | grep -oEi '[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}')
    if test -z "$uuid"
        echo "No connected iOS device found"
        return 1
    end
    # Device name is everything before the first .coredevice
    set -l device_name (echo "$device_line" | sed 's/ *[^ ]*\.coredevice.*//')
    echo "Building $scheme for $device_name ($uuid)..."

    # Get build settings (need destination to get correct device paths)
    set -l dest "platform=iOS,id=$uuid"

    # Build (-quiet, stderr suppressed for warnings, Ctrl+C works)
    xcodebuild -quiet -project "$xcodeproj" -scheme "$scheme" -destination "$dest" build 2>/dev/null
    if test $status -ne 0
        # Re-run to show errors
        xcodebuild -quiet -project "$xcodeproj" -scheme "$scheme" -destination "$dest" build 2>&1 | grep -E "error:" | tail -5
        echo "Build failed"
        return 1
    end

    echo "Done — $scheme built successfully for $device_name"
end
