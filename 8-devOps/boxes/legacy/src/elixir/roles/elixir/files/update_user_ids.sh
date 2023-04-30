#!/bin/bash

#U=`id -u`
#G=`id -g`

#usermod -u $U app

#groupmod -g $G app

MARK_FILE="/home/app/pass"

if [ -f "$MARK_FILE" ]; then
    echo nop
else

    if [ -z ${GET_IDS_USING_CONSUL+x} ]; then
        USER_ID=$(id -u)
        GROUP_ID=$(id -g)
    else
        if [ "$GET_IDS_USING_CONSUL" = "yes" ]; then
            USER_ID=$(curl -X GET http://172.17.0.2:8500/v1/kv/nomad-USER_ID?raw)
            GROUP_ID=$(curl -X GET http://172.17.0.2:8500/v1/kv/nomad-GROUP_ID?raw)
        else
            USER_ID=$(id -u)
            GROUP_ID=$(id -g)
        fi

    fi


    # http://blog.dscpl.com.au/2015/12/unknown-user-when-running-docker.html
    # https://github.com/openshift/jenkins/blob/355600974c22617f5fc4d4bf5eac1aee064e7a2f/2/contrib/jenkins/jenkins-common.sh#L13
    # jenkins/2/contrib/jenkins/jenkins-common.sh
    # echo "default:x:${USER_ID}:${GROUP_ID}:Default Application User:${HOME_DIR}:/sbin/nologin" >> /etc/passwd

    sed '$d' /etc/passwd > $MARK_FILE
    echo "app:x:${USER_ID}:${GROUP_ID}::/home/app:/bin/bash" >> $MARK_FILE
    cat $MARK_FILE > /etc/passwd

    mix local.rebar --force || true
    mix local.hex --force || true

fi

# cp -R /home/app/src-init /home/app/src
