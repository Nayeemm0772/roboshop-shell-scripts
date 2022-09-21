LOG_FILE=/tmp/catalogue
echo Install Nginx &>>${LOG_FILE}

yum install nginx -y &>>${LOG_FILE}
systemctl enable nginx &>>${LOG_FILE}
systemctl start nginx &>>${LOG_FILE}

if [ $? -eq 0 ]; then
	echo Status = SUCCESS
else
	echo Status = FAILURE
fi

echo download the HTDOCS content and deploy under the Nginx path

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}

if [ $? -eq 0 ]; then
	echo Status = SUCCESS
else
	echo Status = FAILURE
fi

echo Deploy the downloaded content in Nginx Default Location.

cd /usr/share/nginx/html &>>${LOG_FILE}
rm -rf * &>>${LOG_FILE}
unzip /tmp/frontend.zip &>>${LOG_FILE}
mv frontend-main/static/* . &>>${LOG_FILE}
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}

if [ $? -eq 0 ]; then
	echo Status = SUCCESS
else
	echo Status = FAILURE
fi

echo  restart the service once to effect the changes.
systemctl restart nginx &>>${LOG_FILE}

if [ $? -eq 0 ]; then
	echo Status = SUCCESS
else
	echo Status = FAILURE
fi







