#!/bin/bash

TEMP_FOLDER="/home/temp"


# Remote server details
# Testing was performed on a Kali Linux virtual machine on the same network


REMOTE_SERVER="kali@192.168.54.244"
REMOTE_LOG_DIR="/home/kali/Logs"			#Save the logs to this folder


# Step 1: Unzip the logs and store in a temporary folder
unzip_logs() {
    mkdir $TEMP_FOLDER								#Make the temp folder if it doesn't exist
    cp /opt/zeek/logs/2024-01-25/*.* $TEMP_FOLDER				#Copy the logs to the temp folder
    for zip_file in $TEMP_FOLDER/*.gz; do							#For every zip file in the directory with the .gz extension
	 base_name=$(basename "$zip_file" .gz)					#Get the full name of the file, complete with the extension
   	 gzip -c "$zip_file" > "$TEMP_FOLDER/$base_name"					#Unzip the file using the base name created
    done
}


# Step 2: Use SSH to send the logs to another computer
send_logs() {
    scp "$TEMP_FOLDER"/* "$REMOTE_SERVER:$REMOTE_LOG_DIR"		#Send the log files to the Kali machine
}


# Step 3: Delete the temporary logs that were unzipped
cleanup() {
    rm -rf "$TEMP_FOLDER"/*										#Remove the files inside the temp folder
}


# Execute the steps
unzip_logs
send_logs
cleanup
