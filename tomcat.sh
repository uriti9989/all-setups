#!/bin/bash

# Configuration
TOMCAT_VER="9.0.85"  # Verify latest version at https://tomcat.apache.org/download-90.cgi
MANAGER_USER="admin"  # Change username here
MANAGER_PASS="1234"  # Change password here

# Install Java
yum install java-17-amazon-corretto -y

# Download Tomcat
wget https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz || {
    echo "Failed to download Tomcat. Check version at https://tomcat.apache.org"
    exit 1
}

# Extract and configure
tar -zxvf apache-tomcat-${TOMCAT_VER}.tar.gz
cd apache-tomcat-${TOMCAT_VER}

# Properly configure tomcat-users.xml
cat > conf/tomcat-users.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <user username="${MANAGER_USER}" password="${MANAGER_PASS}"
        roles="manager-gui,manager-script,manager-jmx,manager-status"/>
</tomcat-users>
EOF

# Enable remote manager access
sed -i '/<Valve/,+2s/^/<!-- /' webapps/manager/META-INF/context.xml
sed -i '/<Valve/,+2s/$/ -->/' webapps/manager/META-INF/context.xml

# Start Tomcat
bin/startup.sh

echo "--------------------------------------------------"
echo "Tomcat ${TOMCAT_VER} installed successfully!"
echo "Manager URL: http://$(curl -s ifconfig.me):8080/manager/html"
echo "Username: ${MANAGER_USER}"
echo "Password: ${MANAGER_PASS}"
echo "--------------------------------------------------"
