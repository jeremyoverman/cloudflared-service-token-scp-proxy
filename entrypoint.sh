#!/bin/bash

export HOST="$1"
export USER="$2"
export CLIENT_ID="$3"
export CLIENT_SECRET="$4"
export KEY_TYPE="$7"
export PORT="$8"
export FILES="$9"

envsubst < "/root/ssh-client.conf" > "/root/.ssh/config" 
PUBLIC_KEY="$(echo $5 | base64 --decode)"
PRIVATE_KEY="$(echo $6 | base64 --decode)"

sh -c "cat > /root/.ssh/${KEY_TYPE} << 'EOL'
$PRIVATE_KEY
EOL"
sh -c "cat > /root/.ssh/${KEY_TYPE}.pub << 'EOL'
$PUBLIC_KEY
EOL"

chmod 0600 /root/.ssh/${KEY_TYPE}

echo "***  connecting to ssh target: ***\n"
cat /root/.ssh/config

function run_command() {
  echo "Running command: $@"
  ssh -o "StrictHostKeyChecking no" -p $PORT $USER@$HOST "$@"
}

function upload() {
  local file_map=$(echo $1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  # Check if the input contains a ':'
  if [[ "$file_map" != *:* ]]; then
    echo "ERROR: invalid format, missing ':' delimiter in $file_map"
    exit 1
  fi

  local from=$(echo $file_map | cut -d ':' -f 1)
  local to=$(echo $file_map | cut -d ':' -f 2)

  echo "*** uploading $from to $to ***"

  # Ensure the source is a directory and copy the contents into the target directory
  if [ -d "$from" ]; then
    # If source is a directory, copy its contents, not the directory itself
    run_command mkdir -p $to
    scp -rp -P $PORT $from/* $USER@$HOST:$to/
  else
    # If source is a file, just copy the file
    run_command mkdir -p $(dirname $to)
    scp -p -P $PORT $from $USER@$HOST:$to
  fi
}

echo "***  uploading files ***\n"
IFS=$'\n'
for file_map in $FILES; do
  upload "$file_map"
done
unset IFS
