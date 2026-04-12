#!/bin/bash
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
  -activate \
  -configure -allowAccessFor -allUsers \
  -configure -access -on \
  -configure -privs -all \
  -configure -clientopts -setvnclegacy -vnclegacy yes \
  -restart -agent -console 2>/dev/null || true
