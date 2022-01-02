#!/bin/bash
set -euo pipefail
# trap killing signals and stop the controller
trap "tpeap stop" HUP INT QUIT TERM

# start the controller
tpeap start

# symlink logs to stdout
#ln -sf /dev/stdout /opt/tplink/EAPController/logs/server.log

# tail logs
tail -f /opt/tplink/EAPController/logs/server.log & wait ${!}
