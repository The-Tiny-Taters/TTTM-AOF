#!/bin/bash

indexedFiles=( )

function refreshIndex {
	IFS=$'\n' read -d '' -r -a lines < index.toml

	file=""
	removed=( )
	changed=( )
	for line in "${lines[@]}"
	do
		if [[ $line == *"file = \""* ]]; then
			echo -ne "Loading indexed file: $file                                                            \r"
			file=$(echo $line | grep -Po "file = \"\K.+?(?=\")")
		elif [[ $line == *"hash = "* ]]; then
			if [[ -f "$file" ]]; then
				if grep -q -w "$file" .packwizignore; then
					removed+=($file)
				else
					currentHash=$(echo $line | grep -Po "hash = \"\K.+?(?=\")")
					newHash=$(md5sum $file | awk '{print $1}')
					if [[ $currentHash != $newHash ]]; then
						changed+=($file)
						sed -i "s/$currentHash/$newHash/g" index.toml
					fi
					indexedFiles+=($file)
				fi
			else
				removed+=($file)
			fi
		fi
	done
	echo "Indexed files loaded                                                    "

	for remove in "${removed[@]}"
	do
		echo "Removing $remove from index"
		rawFile=$(echo "$remove" | sed "s/\//\\\\\//g")
		echo ':a;N;$!ba;s/\[\[files\]\]\nfile = \"'"$rawFile"'\"\n[^\n]*\n\(metafile = [^\n]*\n\)\{0,1\}\n//g'
		sed -i ':a;N;$!ba;s/\[\[files\]\]\nfile = \"'"$rawFile"'\"\n[^\n]*\n\(metafile = [^\n]*\n\)\{0,1\}\n//g' index.toml
	done

	for change in "${changed[@]}"
	do
		echo "Updated hash of $change"
	done

	echo "Checking for new files..."
	indexNewFiles ""
}

function indexNewFiles {
	if [[ $1 == "" ]]; then
		for file in *
		do
			if [[ -d "$file" ]]; then
				indexNewFiles $file
			else
                                indexNewFile $file
			fi
		done
	elif grep -q -w "$1/" .packwizignore; then
		: # ignore ignored directories
	else
		for file in $1/*
		do
			if [[ -d "$file" ]]; then
                                indexNewFiles $file
                        else
				indexNewFile $file
                        fi
                done
	fi
}

function indexNewFile {
	if grep -q -w "$1" .packwizignore; then
		: # ignore ignored files
	elif [[ $1 == "pack.toml" || $1 == "index.toml" ]]; then
		: # ignore pack and index
	else
		if (echo ${indexedFiles[@]} | fgrep -q -w "$1"); then
			: # no need to add indexed files
                else
                        hash=$(md5sum $1 | awk '{print $1}')
			echo "[[files]]" >> index.toml
			echo "file = \"$1\"" >> index.toml
			echo "hash = \"$hash\"" >> index.toml
			if [[ $1 == *mods/* ]]; then
				echo "metafile = true" >> index.toml
			fi
			echo >> index.toml
			echo "New file indexed: $1"
                fi
	fi
}

function refreshPack {
	currentHash=$(grep -Po "hash = \"\K.+?(?=\")" pack.toml)
	newHash=$(md5sum index.toml | awk '{print $1}')

	sed -i "s/$currentHash/$newHash/" pack.toml
}

refreshIndex
refreshPack

echo "Refresh complete!"
echo "Don't forget to update the pack version in pack.toml if you've made changes"
