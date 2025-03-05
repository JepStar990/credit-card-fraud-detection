#!/bin/bash

while true; do
    jupyter nbconvert --to notebook --execute optimization_and_final_model_selection.ipynb --output optimization_and_final_model_selection_output.ipynb
    if [ $? -ne 0 ]; then
        echo "Jupyter Notebook crashed with exit code $?. Restarting..." >&2
        sleep 1  # wait for 1 second before restarting
    else
        break  # Exit the loop if notebook runs successfully
    fi
done
