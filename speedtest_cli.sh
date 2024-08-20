#!/bin/bash

# Define output file
output_file="speedtest_10.csv"

# Check if the speedtest-cli command is available
if ! command -v speedtest-cli &> /dev/null
then
    echo "speedtest-cli could not be found. Please install it first."
    exit 1
fi

# Initialize CSV file with header
speedtest-cli --csv-header > "$output_file"

# Get the list of all speedtest servers
server_list=$(speedtest-cli --list | grep -E '^[ ]*[0-9]+\)' | awk '{print $1}' | tr -d ')')

# Define number of servers to test (you can change this as needed)
max_servers=10
server_count=0

for id in $server_list
do
  # Check if we have reached the maximum number of servers to test
  if [ "$server_count" -ge "$max_servers" ]; then
    echo "Reached the maximum number of servers to test: $max_servers"
    break
  fi

  echo "Testing server ID: $id"
  
  # Record start time
  start_time=$(date +%s)
  
  # Perform the speed test and append to CSV file
  if speedtest-cli --server $id --csv >> "$output_file"; then
    echo "Server ID $id test completed successfully."
  else
    echo "Error testing server ID $id."
  fi
  
  # Record end time and calculate duration
  end_time=$(date +%s)
  duration=$((end_time - start_time))
  
  echo "Server ID $id test duration: $duration seconds."

  # Increment server count
  server_count=$((server_count + 1))
done

echo "Testing completed. Results saved in $output_file"
