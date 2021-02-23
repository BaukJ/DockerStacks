#!/usr/bin/env bash

STACKS="$(ls stacks)"

OPT_DEPLOY=""
OPT_REMOVE=""
while getopts dr opt; do
    case $opt in
        d)  OPT_DEPLOY="yes" ;;
        r)  OPT_REMOVE="yes" ;;
        \?) echo "Invalid option -$OPTARG!" >&2
            exit 1 ;;
        :)  echo "Option -$OPTARG requires an argument." >&2
            exit 1 ;;
    esac
done
shift $((OPTIND - 1))

function logg_error {
    for line in "$@"
    do
        printf "ERROR: %s\n" "$line"
    done
    exit 3
}

STACKS="$(ls stacks)"
STACK="$1"

if [[ -z "$STACK" ]]
then
    logg_error "Need to provide a stack file!" "Valid stacks:" $STACKS
fi
if [[ ! -d "stacks/$STACK" ]]
then
    logg_error "Stack file does not exist: '$STACK'" "Valid stacks:" $STACKS
fi

cd "stacks/$STACK"
if [[ "$OPT_DEPLOY" && "$OPT_REMOVE" ]]
then
    docker stack rm "$STACK"
elif [[ "$OPT_DEPLOY" ]]
then
    docker stack deploy --compose-file docker-compose.yaml "$STACK"
elif [[ "$OPT_REMOVE" ]]
then
    docker-compose down
else
    docker-compose up -d
fi
