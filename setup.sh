#!/bin/bash
WEBSERVERS=webservers.txt
HDHR=hdhrs.txt
MATCH_FILE=hdhr_with_transcoder.txt
rm $WEBSERVERS
rm $HDHR
rm $MATCH_FILE
echo Now searching for web servers.
nmap -p 80 192.168.1.0/24 > $WEBSERVERS
cat $WEBSERVERS | grep 192.168.1 | awk '{ print $5 }' | grep 192.168  | tee $WEBSERVERS


#Looping through each IP in the list
while read ipaddr
do
echo "Evaluating $ipaddr"
curl --max-time 10 http://$ipaddr | grep silicondust
matchfound=$?
if [[  matchfound -eq 0 ]]; then
   echo "Found match in $ipaddr"
   echo $ipaddr >> $HDHR
fi
done < $WEBSERVERS


# #Now looking for the hdhomerun that has the transcoder
while read hdhr
do
  echo "Looking for a transcoder on $hdhr"
  hdhomerun_config $hdhr get /sys/features | grep  transcode
  matchfound=$?
  if [[  matchfound -eq 0 ]]; then
   echo "Found HDHR transcoder in $hdhr"
   echo $hdhr > $MATCH_FILE
  fi
done < $HDHR

#Configuring the Apache proxy
if [ -e $MATCH_FILE ]; then
export hdhrip=`cat $MATCH_FILE`
sudo bash << EOF
pushd /etc/apache2/sites-available
a2dissite hdhr_auto.conf
popd
sed "s/IPADDR/$hdhrip/g" hdhr_auto.conf.TEMPL > /etc/apache2/sites-available/hdhr_auto.conf
#cp hdhr_auto.conf /etc/apache2/sites-available
pushd /etc/apache2/sites-available
a2ensite hdhr_auto.conf
service apache2 reload
popd
EOF
fi
echo Finished.
