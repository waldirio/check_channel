#!/bin/bash

#
# Date ......: 08/08/2016
# Developer .: Waldirio Pinheiro <waldirio@redhat.com>
# Purpose ...: Check all channels and give information about Errata (In the channel, To Add and To Sync
# Changelog .:
#

SERVER="localhost"
USER="admin"
PASSWD="redhat"
LOG="/tmp/errata_channel_info.txt"


header()
{
  clear
  > $LOG
  echo "Channel,ErrataInTheChannel,ErrataToAddFromRH,ErrataToSync"	| tee -a $LOG
}

listChannels()
{
  # Dont copy and paste the code, in the tr command we have one tab (CTRL+V + CTRL+I)
  # to see, download the code and execute cat -vet check_channel.sh
  listAllChannels=$(spacewalk-remove-channel -l |paste -s |tr '	' ' ')

  #listAllChannels="waldirio-lfo-dev-rhel-i386-server-6"
  for b in $listAllChannels
  do
  
    listErrata $b
    varCountListErrata=$?

    listSyncErrata $b
    varListSyncErrata=$?
 
    echo "$b,$varCountListErrata,MISSING_YET,$varListSyncErrata"	| tee -a $LOG
  done
}


listErrata()
{
  countListErrata=$(spacewalk-api --server=$SERVER --user=$USER --password=$PASSWD channel.software.listErrata "%session%" $1|grep "'id'"|wc -l)
  return $countListErrata

}

listAddErrata()
{
:
}

listSyncErrata()
{
  countSyncErrata=$(spacewalk-api --server=$SERVER --user=$USER --password=$PASSWD channel.software.listErrataNeedingSync "%session%" $1 |grep "'id'"|wc -l)
  return $countSyncErrata
}

endApp()
{
  echo ""
  echo ""
  echo "####################################################################"
  echo "Please take a look into the file $LOG"
  echo " - you can import this file using the comma as delimiter."
}


# Main

header
listChannels
endApp
