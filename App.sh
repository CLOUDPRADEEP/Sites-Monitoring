#!/bin/bash

# Define the file containing the website URLs
file="A.txt"

# Create a temporary file to store the results
tempfile=$(mktemp)

# Read the website URLs from the file
websites=$(cat $file)
num_websites=$(echo "$websites" | wc -l)
current_website=0

# Loop through each website and retrieve the HTTP status code
echo "$websites" | while read website; do
  # Increment the current website counters
  current_website=$((current_website + 1))

  # Use curl to retrieve the HTTP status code for each website using max 3 sec waiting time
  status=$(curl --max-time 3 -s -o /dev/null -w "%{http_code}" $website)

  # Write the status code and website URL to the temporary file
  echo $status $website >> $tempfile

  # Showing progress status to the terminal
  printf "Processing website %d of %d\r" $current_website $num_websites
  sleep 3
done

# Generate an HTML file from the temporary file
cat <<EOF > monitoring-results.html
<html>
  <head>
    <title>Testing Sites Results cloudpradeep</title>
  </head>
  <body>
    <table>
      <tr>
        <th>HTTP Codes </th>
        <th>Website URL</th>
      </tr>
EOF

# Read the contents of the temporary file and format them as a table in the HTML file
while read line; do
  status=$(echo $line | awk '{print $1}')
  website=$(echo $line | awk '{print $2}')
  echo "      <tr>" >> monitoring-results.html
  echo "        <td>$status</td>" >> monitoring-results.html
  echo "        <td>$website</td>" >> monitoring-results.html
  echo "      </tr>" >> monitoring-results.html
done < $tempfile

# Close the HTML file
cat <<EOF >> monitoring-results.html
    </table>
  </body>
</html>
EOF

# Remove the temporary file
rm $tempfile
#Lunching Web browser to view webpage
google-chrome ${OutputFile} </dev/null >/dev/null 2>&1 &
exit
# Thank you 
