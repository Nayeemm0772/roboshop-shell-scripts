LOG_FILE=/tmp/catalogue
source common.sh

echo  Setup NodeJS Repos
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
  StatusCheck $?

echo  Install NodeJS
  yum install nodejs -y &>>${LOG_FILE}
  StatusCheck $?

echo adding username
id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  echo Add Roboshop Application User
  useradd roboshop &>>${LOG_FILE}
  StatusCheck $?
fi

echo  Download Catalogue Application Code
  curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
  StatusCheck $?

cd /home/roboshop

echo "Clean Old App Content"
  rm -rf catalogue &>>${LOG_FILE}
  StatusCheck $?

echo  extract the catalogue application code
  unzip /tmp/catalogue.zip &>>${LOG_FILE}
  StatusCheck $?

echo moving the catalogue-main
  mv catalogue-main catalogue &>>${LOG_FILE}
  StatusCheck $?

cd /home/roboshop/catalogue


echo installing the NodeJS Dependencies
  npm install &>>${LOG_FILE}
  StatusCheck $?

echo Update SystemD Service File
  sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service
  StatusCheck $?

echo "setup catalogue service"
   mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
   StatusCheck $?

   systemctl daemon-reload &>>${LOG_FILE}
   systemctl start catalogue &>>${LOG_FILE}

echo "Start Catalogue Service"
   systemctl enable catalogue &>>${LOG_FILE}
   StatusCheck $?



