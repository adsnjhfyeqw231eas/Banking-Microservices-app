#!/bin/bash
# configure maven docker and jenkins
sudo apt install docker.io maven -y
sudo apt install openjdk-11-jdk openjdk-11-jre -y
sleep 1
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sleep 10
sudo usermod -aG docker jenkins
systemctl status jenkins

