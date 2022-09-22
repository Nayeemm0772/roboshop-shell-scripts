LOG_FILE=/tmp/shipping
source common.sh

echo "Install Maven"
  yum install maven -y  &>>${LOG_FILE}
  StatusCheck $?

id roboshop &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
    echo "Add RoboShop Application User"
    useradd roboshop &>>${LOG_FILE}
    StatusCheck $?
  fi

echo "Clean Old App Content"
  cd /home/roboshop && rm -rf shipping &>>${LOG_FILE}
  StatusCheck $?

echo "Extract SHipping Application Code"
  unzip /tmp/shipping.zip &>>${LOG_FILE}
  StatusCheck $?

mv shipping-main shipping
cd /home/roboshop/shipping

echo "Download Dependencies & Make Package"
  mvn clean package &>>${LOG_FILE}
  mv target/shipping-1.0.jar shipping.jar   &>>${LOG_FILE}
  StatusCheck $?

echo Update SystemD Service File : Update CARTENDPOINT with Cart Server IP
  sed -i -e 's/CARTENDPOINT/cart.roboshop.internal/' /home/roboshop/shipping/systemd.service
  StatusCheck $?

echo Update SystemD Service File : Update DBHOST with MySQL Server IP
  sed -i -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/shipping/systemd.service
  StatusCheck $?
  
echo "Setup shipping Service"
  mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service &>>${LOG_FILE}
  StatusCheck $?

  systemctl daemon-reload &>>${LOG_FILE}
  systemctl enable shipping &>>${LOG_FILE}

echo "Start shipping Service"
  systemctl start shipping &>>${LOG_FILE}
  StatusCheck $?

echo "Enable Shipping Service"
  systemctl enable shipping
  StatusCheck $?

