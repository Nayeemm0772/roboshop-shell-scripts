LOG_FILE=/tmp/user
source common.sh

echo Setup NodeJS Repos
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
  StatusCheck $?

echo Install NodeJS
  yum install nodejs -y &>>${LOG_FILE}
  StatusCheck $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  echo Add Roboshop Application User
  useradd roboshop &>>${LOG_FILE}
  StatusCheck $?
fi

echo  Download User Application Code
  curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
  StatusCheck $?

echo  Change the directory
  cd /home/roboshop &>>${LOG_FILE}
  StatusCheck $?

echo "Clean Old App Content"
  rm -rf user &>>${LOG_FILE}
  StatusCheck $?

echo  extract the user application code
  unzip /tmp/user.zip &>>${LOG_FILE}
  StatusCheck $?

echo moving the user-main

  mv user-main user &>>${LOG_FILE}
  StatusCheck $?

echo changing the directory
  cd /home/roboshop/user &>>${LOG_FILE}
  StatusCheck $?

echo installing the NodeJS Dependencies
  npm install &>>${LOG_FILE}
  StatusCheck $?

echo Update SystemD service file
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal' /home/roboshop/user/systemd.service &>>${LOG_FILE}
  StatusCheck $?

echo "setup user service"
   mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>${LOG_FILE}
   StatusCheck $?

   systemctl daemon-reload &>>${LOG_FILE}
   systemctl start user &>>${LOG_FILE}

echo "Start user Service"
   systemctl enable user &>>${LOG_FILE}
   StatusCheck $?



