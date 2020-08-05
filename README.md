# HDHomerun-proxy
Proxy HDHomerun video stream over Apache

Want to be able to view your HDHomerun EXTEND video stream over the internet?  If you 
have tried this before and failed, it might because of the default TTL values
put into the stream by HDHomerun.  Proxying the stream through Apache changes
the TTL value to a much larger number.

## Purpose

This script works by scanning the local network for web servers listening
on port 80.  It then uses `curl` to test connectivity to each discovered web
server and look within the results to see if the webserver is serving
HDHomerun EXTEND content.  Finally, it will configure the local Apache 2
web server to proxy the content over port 8888 at the `/auto` endpoint.

## Setup -- This script relies upon the following prerequisites to be installed.
1. Install nmap
```
sudo apt-get install nmap
```
1. Install Apache
```
sudo apt-get install apache2

# Add the Listen 8888 statement into the ports.conf file.
echo "Listen 8888" >> /etc/apache2/ports.conf

sudo /etc/init.d/apache2 restart
```
1. Install [hdhomerun-config](https://info.hdhomerun.com/info/hdhomerun_config)

1. Run the setup script
```
./setup.sh
```

## Running

Open VLC.  Media -- Open Network Stream -- http://localhost:8888/auto/v55.1?transcode=internet720

VLC will have opened channel 55.1 and should be playing the stream.



