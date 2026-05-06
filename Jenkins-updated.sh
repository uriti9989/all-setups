#!/bin/bash

# STEP-1: INSTALLING GIT 
yum install git -y

# STEP-2: ADDING JENKINS REPOSITORY
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# STEP-3: INSTALL JAVA 21 (Required for Jenkins 2.555.1+)
yum install java-21-amazon-corretto-devel -y

# STEP-4: INSTALL JENKINS
yum clean all
yum install jenkins -y

# STEP-5: CONFIGURE JAVA ENVIRONMENT FOR JENKINS
mkdir -p /var/lib/jenkins
chown -R jenkins:jenkins /var/lib/jenkins

# Set JAVA_HOME for Jenkins
cat > /etc/default/jenkins << EOF
JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto.x86_64
JENKINS_HOME=/var/lib/jenkins
JENKINS_USER=jenkins
JENKINS_PORT=8080
EOF

# STEP-6: START JENKINS
systemctl daemon-reload
systemctl start jenkins
systemctl enable jenkins

# STEP-7: VERIFY AND DISPLAY PASSWORD
sleep 10
if systemctl is-active --quiet jenkins; then
    echo "✅ Jenkins started successfully with Java 21!"
    echo "🔑 Initial Admin Password:"
    cat /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "❌ Jenkins failed to start. Checking logs..."
    journalctl -u jenkins --no-pager -n 20
fi
