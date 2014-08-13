
#! /bin/bash -ex

echo "-------------- Cap nhat he thong ------------------"
   apt-get update && apt-get -y dist-upgrade 
   apt-get -y upgrade && apt-get -f install
echo "----------------------------------------------------"

echo "-------Cau hinh dia chi ip va hostname---------------"

echo "auto eth0" 					      >> /etc/network/interface
echo "iface eth0 inet static" 	>> /etc/network/interface
echo "address  192.168.1.71"  	>> /etc/network/interface
echo "netmask  255.255.255.0"   >> /etc/network/interface
echo "gateway  192.168.1.1"     >> /etc/network/interface
echo "dns-nameservers 8.8.8.8"  >> /etc/network/interface

/etc/init.d/networking restart

echo "------------------------------------------------------"

echo "---- Khai bao hostname -------------------------------"
echo "    graphite-server" 			>/etc/hostname 
echo "-------------------------------------------------------"

echo "-----------------Install system-------------------------"

  apt-get install -y graphite-web graphite-carbon
  apt-get update
echo "--------------------------------------------------------"

echo "--------------------Cai dat PostgreSQL-------------------"
 
    apt-get install -y  postgresql libpq-dev python-psycopg2
echo "---------Create a Database User and a Database------------"
    sudo -u postgres psql
    CREATE USER graphite WITH PASSWORD 'Admin123';
    CREATE DATABASE graphite WITH OWNER graphite;
    \q
 echo " ------------------------------------------------------------"

 echo "------------------Cau hinh graphite web-app-----------------"
  
  cp /etc/graphite/local_settings.py /etc/graphite/local_settings.py.bka

 echo "SECRET_KEY = 'a_salty_string' " 			     >> /etc/graphite/local_settings.py 
 echo "TIME_ZONE = 'Asia/Ho_Chi_Minh' "  		     >> /etc/graphite/local_settings.py
 echo "USE_REMOTE_USER_AUTHENTICATION = True" 	 >> /etc/graphite/local_settings.py

 echo  <<EOF >  /etc/graphite/local_settings.py 
  DATABASES = {
    'default': {
        'NAME': 'graphite',
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'USER': 'graphite',
        'PASSWORD': 'password',
        'HOST': '127.0.0.1',
        'PORT': ''
    }

}
EOF
echo "------ Dong bo du lieu----------------------------------------"

     sudo graphite-manage syncdb
     sleep 3

echo "----------------Carbon configure-----------------------------"

      sed -i 's/false/true/g'  /etc/default/graphite-carbon
      sleep 3

      sed -i 's/false/true/g'  /etc/carbon/carbon.conf
echo "---------------Configure Storage------------------------------"
      sudo cp /usr/share/doc/graphite-carbon/examples/storage-aggregation.conf.example /etc/carbon/storage-aggregation.conf
      sleep 3

 echo "---Khoi dong lai dich vu carbon-cache-------------------------"
       sudo service carbon-cache start

 echo "------------------------------------------------------------------------------"

 echo "-------------------Install and configure Apache2--------------------------------"
    
        sudo apt-get  -y install apache2 libapache2-mod-wsgi
        sudo apt-get update
  #--------------------------------------------------------------------------------------
        sudo a2dissite 000-default
  #--------------------------------------------------------------------------------------
        sudo cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available
   #-----------------------------------------------------------------------------------
        sudo a2ensite apache2-graphite
   #--------------------------------------------------------- ------------------------- 
  echo "-----------khoi dong lai dich vu Apache2--------------------------------------"
        sudo service apache2 reload
  #------------------------------------------------------------------------------------"
  echo " truy cap vao tai khoan http://172.16.69.71 ( ip server) "


  echo "--Cai dat va cau hinh Collectd tren may server-----------------------------"

      apt-get update
      apt-get install  -y collectd collectd-utils
  echo "------------------------------------------------------------------------------"
  echo "---=---Configure collectd----=------------"
  echo "Hostname $hostname"     >> /etc/collectd/collectd.conf

  echo " LoadPlugin network"    >> /etc/collectd/collectd.conf
  echo " LoadPlugin write_graphite"
  echo " <Plugin network>"      >>/etc/collectd/collectd.conf
  echo " Listen "*" "2003""     >>/etc/collectd/collectd.conf
  echo "  </Plugin>"              >>/etc/collectd/collectd.conf
  

  echo " ---=-Khoi dong lai dich vu--=--------------"
   service  collectd restart
 echo "-----------------------------------------------"