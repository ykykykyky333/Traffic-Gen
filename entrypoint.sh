#!/bin/sh

echo "Starting Tor..."
service tor start

sleep 10

echo "Sending traffic..."
python3 /scripts/hit.py -u https://evanappmv.blogspot.com/2025/12/yt.html -l 3 -w 5 -d True

tail -f /dev/null
