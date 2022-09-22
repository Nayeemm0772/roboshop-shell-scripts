LOG_FILE=/tmp/cart
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

echo  Download user Application Code
  curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
  StatusCheck $?

cd /home/roboshop

echo "Clean Old App Content"
  rm -rf user &>>${LOG_FILE}
  StatusCheck $?

echo  extract the user application code
  unzip /tmp/user.zip &>>${LOG_FILE}
  StatusCheck $?

echo moving the user-main
  mv user-main user &>>${LOG_FILE}
  StatusCheck $?

  cd /home/roboshop/cart

echo installing the NodeJS Dependencies
  npm install &>>${LOG_FILE}
  StatusCheck $?

echo Update SystemD Service File : REDIS_ENDPOINT with REDIS server IP Address
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/roboshop/cart/systemd.service
  StatusCheck $?

echo Update SystemD Service File : CATALOGUE_ENDPOINT with Catalogue server IP address
  sed -i -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service
  StatusCheck $?

echo "setup cart service"
   mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>${LOG_FILE}
   StatusCheck $?

   systemctl daemon-reload &>>${LOG_FILE}
   systemctl start cart &>>${LOG_FILE}

echo "Start Cart Service"
   systemctl enable cart &>>${LOG_FILE}
   StatusCheck $?




