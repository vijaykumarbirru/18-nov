#!/bin/bash
apt update -y
apt install -y net-tools telnet curl

echo "Backend EC2 is running successfully" > /etc/motd

# OPTIONAL: Start a tiny backend web server for testing
apt install -y python3
cat <<EOF >/home/ubuntu/app.py
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()
        self.wfile.write(b"Hello from BACKEND EC2 in Private Subnet!\n")

HTTPServer(('0.0.0.0', 8080), Handler).serve_forever()
EOF

nohup python3 /home/ubuntu/app.py &
