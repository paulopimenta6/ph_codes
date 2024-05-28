#!/bin/bash

find . -type f -exec sh -c 'mv "$1" "$1.png"' _ {} \;

exit 1
