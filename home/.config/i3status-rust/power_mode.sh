# Read the value from /sys/firmware/acpi/platform_profile
profile=$(cat /sys/firmware/acpi/platform_profile)

# Define colors and corresponding symbols
GREY="{\"icon\":\"\",\"state\":\"Info\", \"text\": \"\\Uf111\"}" # quiet 
ORANGE="{\"icon\":\"\",\"state\":\"Warning\", \"text\": \"\Uf111\"}" # balanced
RED="{\"icon\":\"\",\"state\":\"Critical\", \"text\": \"\Uf111\"}" # performance
json = true

# Check the value and print the corresponding symbol
if [[ "$profile" == "performance" ]]; then
    echo -e "$RED"
elif [[ "$profile" == "balanced" ]]; then
    echo -e "$ORANGE"
elif [[ "$profile" == "quiet" ]]; then
    echo -e "$GREY"
else
    echo "Unknown profile"
fi
