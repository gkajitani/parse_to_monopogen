#! /bin/bash

# Can edit depending on available thread
max_jobs=6

for script in split*.sh; do
  ./"$script" &

    # Wait if there's already 3 running jobs
    while [ "$(jobs -r | wc -l)" -ge "$max_jobs" ]; do
      sleep 1
    done
  done
# Wait for remaining jobs to finish
wait

echo "Demultiplexing completed."
