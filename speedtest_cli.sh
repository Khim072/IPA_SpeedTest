#!/usr/bin/bash
# สร้างไฟล์ csv และเพิ่ม header

speedtest-cli --csv-header > speedtest_10.csv

# Get the list of all speedtest servers
server_list=$(speedtest-cli --list | grep -E '^[ ]*[0-9]+\)' | awk '{print $1}' |  tr -d ')')

for id in $server_list
do
  echo "Testing server ID: $id"
  speedtest-cli --server $id --csv >> speedtest_10.csv
done

echo "Testing completed. saved in speedtest_10.csv"
