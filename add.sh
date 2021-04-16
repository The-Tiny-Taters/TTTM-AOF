#!/bin/bash

# Adds a mod to the pack using packwiz, and adds the mod to the update script

# Direct links are supported in format "./add.sh dr link-to-mod.jar mod-id"
# Its .toml will be added, packwiz will be refreshed, and a message to the
# update script will be added letting you know that it cannot update directs

if [ "$1" = "dr" ]; then
	hash=$(curl "$2" -L | sha256sum | awk '{print $1}')

	fileName=$(echo "$2" | grep -Po ".+/\K.+\.jar")

	# Filling up .toml
	file=mods/$3.toml
	echo "name = \"$3\"" > $file
	echo "filename = \"$fileName\"" >> $file

	if [[ "$4" == "server" || "$4" == "client" ]]; then
		echo "side = \"$4\"" >> $file
	else
		echo "side = \"both\"" >> $file
	fi

	echo "" >> $file
	echo "[download]" >> $file
	echo "url = \"$2\"" >> $file
	echo "hash-format = \"sha256\"" >> $file
	echo "hash = \"$hash\"" >> $file

	if ! grep -q $3 update.sh; then
		echo "echo \"$3 uses a direct link, must be manually updated!\"" >> update.sh
	fi

	./packwiz refresh
else
	./packwiz "$1" install "$2"

	if [[ "$3" == "server" || "$3" == "client" ]]; then
                sed -i "s/\"both\"/\"$3\"/" mods/$2.toml
		./packwiz refresh
        fi

	echo "./packwiz update $2" >> update.sh
fi
