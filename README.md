# HDHomerun-proxy
Proxy HDHomerun video stream over Apache

Want to be able to view your HDHomerun EXTEND video stream over the internet?  If you 
have tried this before and failed, it might because of the default TTL values
put into the stream by HDHomerun.  Proxying the stream through Apache changes
the TTL value to a much larger number.

This script works by scanning the local network for web servers listening
on port 80.  It then uses `curl` to test connectivity to each discovered web
server and look within the results to see if the webserver is serving
HDHomerun EXTEND content.  Finally, it will configure the local Apache 2
web server to proxy the content over port 8888 at the `/auto` endpoint.

# Setup -- This script relies upon the following prerequisites to be installed.
1. Install nmap
1. Install Apache
1. Install hdhomerun-config


