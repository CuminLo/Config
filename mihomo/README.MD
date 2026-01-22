  # 1. Install the LaunchDaemon service
  sudo cp com.mihomo.daemon.plist /Library/LaunchDaemons/
  sudo chown root:wheel /Library/LaunchDaemons/com.mihomo.daemon.plist
  sudo chmod 644 /Library/LaunchDaemons/com.mihomo.daemon.plist

  # 2. Install the management script
  sudo cp mihomo /usr/local/bin/
  sudo chmod +x /usr/local/bin/mihomo

  # 3. Load the service immediately
  sudo mihomo start

  Verification

  After running the commands above, you can verify the service is running by:

  1. Checking the status:
  # Check if the process is running
  ps aux | grep clash.meta
  2. Checking the logs:
  mihomo log

  Usage

  You can now use the mihomo command to manage the service:
  - sudo mihomo start   - Start the service
  - sudo mihomo stop    - Stop the service
  - sudo mihomo restart - Restart the service
  - mihomo log          - View logs (Ctrl+C to exit)
