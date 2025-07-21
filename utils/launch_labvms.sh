#!/bin/bash

# VM list
VMS=(
  "lab-1-mgmt1:192.168.0.10"
  "lab-1-db1:192.168.0.11"
  "lab-1-embed-generator:192.168.0.12"
  "lab-1-ingestion:192.168.0.13"
  "lab-1-ui:192.168.0.14"
  "lab-1-api:192.168.0.15"
  "lab-1-PyTorch:192.168.0.16"
)

USERNAME="mike"

# Function to get the first WezTerm window ID
get_window_id() {
  wezterm cli list --format json | jq -r '.[0].window_id' 2>/dev/null
}

# Clean all known hosts first (optional)
for vm in "${VMS[@]}"; do
  IP="${vm##*:}"
  ssh-keygen -R "$IP" >/dev/null 2>&1
done

# Open first VM in a new window
FIRST_VM="${VMS[0]}"
NAME="${FIRST_VM%%:*}"
IP="${FIRST_VM##*:}"

echo "🚀 Opening WezTerm with $NAME..."
wezterm start -- ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USERNAME@$IP" &

# Wait for the window to initialize and get its ID
sleep 2
WINDOW_ID=$(get_window_id)

if [[ -z "$WINDOW_ID" ]]; then
  echo "❌ Failed to get WezTerm window ID"
  exit 1
fi

# Open remaining VMs in new tabs of the same window
for vm in "${VMS[@]:1}"; do
  NAME="${vm%%:*}"
  IP="${vm##*:}"

  echo "➕ Opening tab for $NAME..."
  wezterm cli spawn --window-id "$WINDOW_ID" -- ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USERNAME@$IP"
  sleep 0.3  # Small delay between tab openings
done

echo "🎉 All VMs opened in WezTerm!"