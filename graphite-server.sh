
#!/bin/bash -ex

echo "-------------- Cap nhat he thong ------------------"
   apt-get update && apt-get -y dist-upgrade 
   apt-get -y upgrade && apt-get -f install

echo "-----------------Install system-------------------------"

apt-get install -y graphite-web graphite-carbon
apt-get update
echo "--------------------------------------------------------"

echo "--------------------Cai dat PostgreSQL-------------------"
 
apt-get install -y  postgresql libpq-dev python-psycopg2
echo "---------Create a Database User and a Database------------"
cat << EOF |sudo -u postgres psql
  CREATE USER graphite WITH PASSWORD 'Admin123';
  CREATE DATABASE graphite WITH OWNER graphite;
\q
EOF
echo " ------------------------------------------------------------"

echo "------------------Cau hinh graphite web-app-----------------"

$local=/etc/graphite/local_settings.py

test -f $local.bka || cp $local $local.bka

rm $local

touch $local
#---------------------------------------------------------------------------------- 
cat  <<EOF  >>$local
SECRET_KEY = 'a_salty_string'
TIME_ZONE = 'Asia/Ho_Chi_Minh'
LOG_RENDERING_PERFORMANCE = True
LOG_CACHE_PERFORMANCE = True
LOG_METRIC_ACCESS = True
GRAPHITE_ROOT = '/usr/share/graphite-web'
CONF_DIR = '/etc/graphite'
STORAGE_DIR = '/var/lib/graphite/whisper'
CONTENT_DIR = '/usr/share/graphite-web/static'
WHISPER_DIR = '/var/lib/graphite/whisper'
LOG_DIR = '/var/log/graphite'
INDEX_FILE = '/var/lib/graphite/search_index'  # Search index file
USE_REMOTE_USER_AUTHENTICATION = True
DATABASES = {
'default': {
'NAME': 'graphite',
'ENGINE': 'django.db.backends.postgresql_psycopg2',
'USER': 'graphite',
'PASSWORD': 'Admin123',
'HOST': '127.0.0.1',
'PORT': ''
    }
  }

EOF
sleep 3
#-------------------------------------------------------------------------
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
 
