log_file="./node_height_logs.txt"
template_file="./TEMPLATE.md"
output_file="README.md"

while true; do
  # Read the log file
  log_content=$(cat "$log_file")

  # Replace the placeholder "_____" with the content of node_height_logs.txt
  cp $template_file $output_file
  echo "\`\`\`" >>$output_file
  echo "$log_content" >>$output_file
  echo "\`\`\`" >>$output_file

  # Add changes to Git
  git add "$output_file"

  # Commit the changes
  git commit -m "Updated node height logs"

  # Push the changes to GitHub
  git push origin main
  sleep 300
done
