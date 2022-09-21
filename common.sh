ID=$(id -u)
if [ $ID -ne 0 ]; then
	echo you should run this script as root user or with sudo privileges
	exit 1
fi

StatusCheck() {
  if [ $? -eq 0 ]; then
  	echo -e Status = "\e[32mSUCCESS\e[0m"
  else
	  echo -e Status = "\e[31mFAILURE\e[0m"
	  exit 1
  fi
}