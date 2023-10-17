user_logs=$(grep "$username" /var/log/auth.log)
connection_count=$(echo "$user_logs" | awk '/sshd/ && /Accepted/ {print $1}' | sort | uniq -c | wc -l)
current_date=$(date +'%d-%m-%Y-%H-%M')
filename="number_connection-$current_date"
echo "$connection_count" > "$filename"
tar -cf "$filename.tar" "$filename"
mv "$filename.tar" "$backup_dir"
