function run
    # Find Xcode project
    set -l xcodeproj (ls -d *.xcodeproj 2>/dev/null | head -1)
    if test -z "$xcodeproj"
        echo "No .xcodeproj found in current directory"
        return 1
    end
    set -l scheme (basename "$xcodeproj" .xcodeproj)

    # Find connected device (prefer hephaestus)
    set -l all_devices (xcrun devicectl list devices 2>/dev/null | grep -E "available \(paired\)" | grep -iv watch)
    set -l device_line ""
    for line in $all_devices
        if string match -qi "*hephaestus*" "$line"
            set device_line "$line"
            break
        end
    end
    if test -z "$device_line"
        set device_line $all_devices[1]
    end
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
    set -l settings (xcodebuild -project "$xcodeproj" -scheme "$scheme" -destination "$dest" -showBuildSettings 2>/dev/null)
    set -l products_dir (printf '%s\n' $settings | grep '^ *BUILT_PRODUCTS_DIR' | awk '{print $3}')
    set -l product_name (printf '%s\n' $settings | grep '^ *FULL_PRODUCT_NAME' | awk '{print $3}')
    set -l bundle_id (printf '%s\n' $settings | grep '^ *PRODUCT_BUNDLE_IDENTIFIER' | awk '{print $3}')

    # Build (-quiet, stderr suppressed for warnings, Ctrl+C works)
    xcodebuild -quiet -project "$xcodeproj" -scheme "$scheme" -destination "$dest" build 2>/dev/null
    if test $status -ne 0
        # Re-run to show errors
        xcodebuild -quiet -project "$xcodeproj" -scheme "$scheme" -destination "$dest" build 2>&1 | grep -E "error:" | tail -5
        echo "Build failed"
        return 1
    end

    # Install and launch
    echo "Installing and launching..."
    xcrun devicectl device install app --device "$uuid" "$products_dir/$product_name" 2>&1 | tail -3
    and xcrun devicectl device process launch --device "$uuid" "$bundle_id" 2>&1 | tail -3

    echo "Done — $scheme running on $device_name"
end
