#!/bin/sh

CONFIG_FILE=/data/options.json
CONFIG_RS485=/share/kocom/rs485.conf

# Read contents of CONFIG_FILE into a variable
CONFIG=$(cat "$CONFIG_FILE")

# Clear the contents of CONFIG_RS485
> "$CONFIG_RS485"

# Loop through each key in the JSON object
for i in $(echo "$CONFIG" | sed 's/},{/}\n{/g; s/\[{//; s/}\]$//; s/"//g' | awk -F ':' '{print $1}')
do
  # Exit the loop when the key is "Advanced"
  if [ "$i" = "Advanced" ]
  then 
    break
  fi 
  
  # Write the section header to CONFIG_RS485
  echo "[$i]" >> "$CONFIG_RS485"
  
  # Get the corresponding value for the key
  value=$(echo "$CONFIG" | sed -n '/'"$i"'/,/},/{/'"$i"'/!{/},/p}}' | awk -F ':' '{print $2}' | sed 's/,//')
  
  # Replace "false" with "False" and "true" with "True" in the value
  value=$(echo "$value" | sed -e "s/false/False/g" -e "s/true/True/g")
  
  # Write the key-value pair to CONFIG_RS485
  echo "$i=$value" >> "$CONFIG_RS485"
done