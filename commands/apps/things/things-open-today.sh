#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Today in Things
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Things
# @raycast.icon images/things.png

# Documentation:
# @raycast.description Open the Today list in Things 3.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

open "things:///show?id=today"
