#!/bin/sh

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_DEFAULT_REGION='ap-northeast-1'

MY_IP=`curl -f -s ifconfig.me`

trap "aws ec2 revoke-security-group-ingress --group-id ${AWS_SECURITY_GROUP} --protocol tcp --port 22 --cidr $MY_IP/32" 0 1 2 3 15

aws ec2 authorize-security-group-ingress --group-id ${AWS_SECURITY_GROUP} --protocol tcp --port 22 --cidr $MY_IP/32
ssh ${USER_NAME}@${HOST_IP} 'cd medicine_confirmation && \
                             git pull && \
                             docker-compose -f docker-compose.pro.yml stop && \
                             docker-compose -f docker-compose.pro.yml run --rm web rails db:migrate && \
                             docker-compose -f docker-compose.pro.yml run --rm web rails assets:precompile RAILS_ENV=production && \
                             docker-compose -f docker-compose.pro.yml build && \
                             docker-compose -f docker-compose.pro.yml up -d'
