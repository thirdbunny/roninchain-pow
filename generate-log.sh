#!/bin/bash

LOG_FILE="./node_height_logs.txt"

while true; do
  echo "Querying node heights..."

  # Get block numbers from both nodes
  network_block=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' https://api.roninchain.com/rpc | jq -r '.result' | sed 's/0x//')
  local_block=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545 | jq -r '.result' | sed 's/0x//')

  # Convert hex to decimal
  network_height=$((16#$network_block))
  local_height=$((16#$local_block))

  # Calculate blocks left
  blocks_left=$((network_height - local_height))

  # Get current timestamp and create log entry
  timestamp=$(date "+%a %b %d %I:%M:%S %p %Z %Y")
  log_entry="$timestamp Your Node Height: $local_height | Network Height: $network_height | Blocks Left: $blocks_left"

  # Append new log entry
  echo "$log_entry" >>"$LOG_FILE"

  # Keep only last 20 lines
  tail -n 20 "$LOG_FILE" >"$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"

  # Wait 5 seconds before next check
  sleep 5
done
