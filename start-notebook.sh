#!/bin/bash

set -e

if [ -z "$ENV_PWD" ]
then
  echo "Using Jupyter token"
  jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token=''
else
  echo "Using Jupyter password"
  HASHED_PWD=`python -c "from notebook.auth import passwd; print(passwd('$ENV_PWD'))"`
  jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.password="$HASHED_PWD" --NotebookApp.token=''
fi

