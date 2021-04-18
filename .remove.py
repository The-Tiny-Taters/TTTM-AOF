#!/usr/bin/python3
# Courtesy of CodedSakura <3

import sys

if len(sys.argv) < 2:
    print(f"Usage: {sys.argv[0]} [...filepath]")
    exit(1)

with open('index.toml', 'r') as f:
    data = list(map(lambda x: x.split('\n'), f.read().split('\n\n')))

forRemoval = sys.argv[1:]
segmentsForRemoval = []

for segment in data:
    for line in segment:
        if line.startswith('file = '):
            filename = line[8:-1]
            if filename in forRemoval:
                forRemoval.remove(filename)
                # to not cause issues when items are next to each other
                segmentsForRemoval.append(segment)

for segment in segmentsForRemoval:
    data.remove(segment)

for notRemoved in forRemoval:
    print(f'Did not remove {notRemoved}!')

with open('index.toml', 'w') as f:
    f.write('\n\n'.join(['\n'.join(x) for x in data]))
