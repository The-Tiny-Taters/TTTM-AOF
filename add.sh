#!/bin/bash

# Adds a mod to the pack using packwiz, and adds the mod to the update script

./packwiz "$1" install "$2"

echo "./packwiz update $2" >> update.sh
