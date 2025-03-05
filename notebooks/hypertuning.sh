#!/bin/bash

# Prevent the system from sleeping (Linux)
# For macOS, replace with `caffeinate -s &`
if command -v xdg-screensaver &> /dev/null; then
    xdg-screensaver reset &
    SCREENSAVER_PID=$!
elif command -v systemd-inhibit &> /dev/null; then
    systemd-inhibit --what=sleep --mode=block bash &
    INHIBIT_PID=$!
else
    echo "No sleep prevention tool found. The system may sleep."
fi

# Record the start time
START_TIME=$(date +%s)

# Function to calculate and display elapsed time
elapsed_time() {
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
    printf "Elapsed time: %02d:%02d:%02d\n" $((ELAPSED_TIME/3600)) $((ELAPSED_TIME%3600/60)) $((ELAPSED_TIME%60))
}

# Run the Jupyter Notebook in a loop
while true; do
    echo "Starting Jupyter Notebook execution..."
    jupyter nbconvert --to notebook --execute optimization_and_final_model_selection.ipynb --output optimization_and_final_model_selection_output.ipynb
    EXIT_CODE=$?
    elapsed_time

    if [ $EXIT_CODE -ne 0 ]; then
        echo "Jupyter Notebook crashed with exit code $EXIT_CODE. Restarting..." >&2
        sleep 1  # wait for 1 second before restarting
    else
        echo "Jupyter Notebook executed successfully."
        break  # Exit the loop if notebook runs successfully
    fi
done

# Clean up sleep prevention (Linux)
if [ -n "$SCREENSAVER_PID" ]; then
    kill $SCREENSAVER_PID
elif [ -n "$INHIBIT_PID" ]; then
    kill $INHIBIT_PID
fi
