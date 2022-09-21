LOG_FILE=/tmp/catalogue
source common.sh

&>>${LOG_FILE}
StatusCheck $?

echo setup MongoDB Repos.
  curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}

  StatusCheck $?

echo  Install Mongo and start the Service.

  yum install -y mongodb-org &>>${LOG_FILE}
  systemctl enable mongod &>>${LOG_FILE}
  systemctl start mongod &>>${LOG_FILE}

  StatusCheck $?

echo Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file

  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG_FILE}

  StatusCheck $?

echo restart the service

  systemctl restart mongod &>>${LOG_FILE}

  StatusCheck $?

echo Download the schema and load it.

   curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${LOG_FILE}
  
   cd /tmp &>>${LOG_FILE}
   unzip mongodb.zip &>>${LOG_FILE}
   cd mongodb-main &>>${LOG_FILE}
   mongo < catalogue.js &>>${LOG_FILE}
   mongo < users.js &>>${LOG_FILE}

   StatusCheck $?

  


