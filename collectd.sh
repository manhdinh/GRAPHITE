#!/bin/bash

echo "-----install collectd-client------------"
    apt-get install collectd libjson-perl -y

echo "----=--Configure collectd -client--=------"
 
  collectd= /etc/collectd/collectd.conf
 #-------------------------------------------------------
  test -f $collectd.bka || cp $collectd $collectd.bka
   #-------------------------------------------------------- 
  rm $collectd

  #-----------------Tao file moi rong-----------------------------------------
   touch $collectd
  #---------------------------------------------------------------------------
  cat <<EOF > $collectd
    
    FQDNLookup true
	Interval 10
	ReadThreads 5
	LoadPlugin syslog
	<Plugin syslog>
	        LogLevel info
	</Plugin>
	#LoadPlugin battery
	LoadPlugin cpu
	LoadPlugin df
	LoadPlugin disk
	LoadPlugin entropy
	LoadPlugin interface
	LoadPlugin irq
	LoadPlugin load
	LoadPlugin memory
	LoadPlugin network
	LoadPlugin processes
	LoadPlugin rrdtool
	LoadPlugin swap
	LoadPlugin users
	<Plugin interface>
	Interface "eth0"
	Interface "eth1"
	IgnoreSelected false
	</Plugin>
	<Plugin network>
	        # client setup:
	        Server "172.16.69.204" "2003"
	</Plugin>
	<Plugin rrdtool>
	        DataDir "/var/lib/collectd/rrd"
	</Plugin>
	Include "/etc/collectd/filters.conf"
	Include "/etc/collectd/thresholds.conf"
EOF
#------------------------------------------------------------------------
   service collectd restart

#-----------------------------------------------------------------------

 

