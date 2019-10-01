#!/usr/bin/env bash

STACKS="$(ls stacks)"

function logg_error {
    for line in "$@"
    do
        echo "ERROR: $line"
    done
    exit 3
}

STACKS="$(ls stacks)"
STACK="$1"

if [[ -z "$STACK" ]]
then
    logg_error "Need to provide a stack file!" "Valid stacks: $STACKS"
fi
if [[ ! -d "stacks/$STACK" ]]
then
    logg_error "Stack file does not exist: '$STACK'" "Valid stacks: $STACKS"
fi

cd "stacks/$STACK"
docker stack deploy --compose-file docker-compose.yaml "$STACK"
