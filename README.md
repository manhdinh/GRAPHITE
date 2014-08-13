==================================
Graphite.
 
I. Tìm hiểu về graphite
 1. Graphite : 
   - là 1 ứng dụng thu thập, lưu trữ và hiển thị thông tin máy chủ và các ứng dụng.
   - thư viện đồ họa nhiêu thành phần sử dụng để  hiển thị thông số hình ảnh theo thời gian thực
  2.Các thành phần
   
   * Graphite-webapp:
     - thiết kế các biểu đồ dữ liệu.
	 - Cung câp giao diện đồ họa  để hiển thị các thông số từ máy chủ và ứng dụng.
	 - Tạo đồ thị dựa trên dữ liệu mà nó nhận được
	 => chỉ hiển thị biểu đồ không lưu trữ lại dữ liệu.
	*Carbon:
	 -thành phần lưu trữ dữ liệu của graphite
	 -Xử lý dữ liệu được gửi qua câc tiến trình khác để thu thập và truyền tải số liệu thống kê.
	 
	*Whiper:
	 - là thư viện CSDL của Graphite => sử dụng lưu thông tin nhận được.
	 - cung cấp nhanh và tin cậy số liệu theo thời gian thực.
	 
   3. Các thành phần khác:
   
     Graphite chỉ thống kê thông tin dữ liệu dựa vào 2 thành phần là StatD,Collectd.
   
   
    a.Collectd:
	   - Thu thập thông tin  thống  kê về các thành phần của máy chủ như : Ram,CPU,network theo thời gian thực
	   - thu thập các thông tin tù các ứng dụng : Apache,Nginx,iptable,memcache,...
	   
	   =:Cug cấp các thông tin trước khi tạo các ứng dụng trên máy chủ
	   
	 b,StatD:
        - thu tập thông tin thông qua các cổng chạy trên  giao thức UDP => tổng hợp -> đưa lên Graphite.


    II. Cài đặt và sử dụng :
	  
	  Mô hình : 
	     
	  
	     <img src="http://i.imgur.com/nlXfCmX.png">
	  
	 1. Cài đặt Graphite :
            
		* Cập nhập Os và cài các gói:
		 ```
		    sudo apt-get update
			sudo apt-get install graphite-web graphite-carbon
		 ```
		 
		* Cấu hình  CSDL với Django:
		 
        - cài PostgreSQL:
        ```
		  sudo apt-get install postgresql libpq-dev python-psycopg2

        ```		
        -Create a Database User and a Database:
		 ```
		   sudo -u postgres psql
		   CREATE USER graphite WITH PASSWORD 'password';
           CREATE DATABASE graphite WITH OWNER graphite;
           \q

		 ```
		* Cấu hình  Graphite-webapp :
		 
		 ```
		   sudo nano /etc/graphite/local_settings.py
         ```
		 - sửa file:
		 ```
		   SECRET_KEY = 'a_salty_string'
		   
           TIME_ZONE = 'Asia/Ho_Chi_Minh'
		   
		   USE_REMOTE_USER_AUTHENTICATION = True
           
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

		 ```
		-  Đồng bộ dữ liệu:
		```
		   sudo graphite-manage syncdb

		```
		* Cấu hình Carbon:
        
		- bật dịch vụ carbon :
		```
		 sudo nano /etc/default/graphite-carbon
         
		CARBON_CACHE_ENABLED=true

        ```		
		- sửa file :
 		```
		sudo nano /etc/carbon/carbon.conf
        ```
	    ```
		 ENABLE_LOGROTATION = True
		```
        - Cài đặt và cấu hình Apache:
		
		 ```
		  sudo apt-get install -y apache2 libapache2-mod-wsgi

		 ```
		- tắt dịch vụ host ảo :
		 ```
		   sudo a2dissite 000-default
		 ```
		- Next, copy the Graphite Apache virtual host file into the available sites directory:
         ```
		  sudo cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available

		 ```
        - Enable host ảo:
		 ```
		  sudo a2ensite apache2-graphite

		 ```
        - Khởi động lại dịch vụ Apache:
		 ```
		  sudo service apache2 reload

		 ```
	- Truy cập vào : ```
	                  http://server_domain_name_or_IP
	                 ```
	sẽ được giao diện như dưới :
	 <img src="http://i.imgur.com/6eUgKnM.png">
	- Chọn tab graphite :
     <img src="http://i.imgur.com/YooahDo.png">	
	   
	   