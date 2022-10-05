myname=Niranjan
s3_bucket=upgrad-$(echo "$myname" | tr '[A-Z]' '[a-z]')
timestamp=$(date '+%d%m%Y-%H%M%S')
servName=apache2

sudo apt update -y

if [[ -z $(dpkg -l | grep $servName) ]]
then
	echo "===> installing $servName"
	sudo apt install $servName -y
fi

if [[ $(systemctl is-active $servName) != 'active' ]]
then
	echo "===> starting $servName"
	sudo systemctl start $servName
fi


if [[ $(systemctl is-enabled $servName) != 'enabled' ]]
then
	echo "===> enabling $servName"
	sudo systemctl enable $servName
fi



sudo apt install awscli -y


cd /var/log/$servName/
tar cvf  /tmp/$myname-httpd-logs-$timestamp.tar *.log

aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

cd
