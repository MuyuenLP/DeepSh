#!/bin/bash

PROXY_PORT=7890


echo "Your Username is [$USER]"

LASR_LOGIN_IP=$(last -i $USER | head -n 1 | awk '{print $3}')
echo "Your last login IP is [$LASR_LOGIN_IP]"

echo "Set proxy to ${LASR_LOGIN_IP}:$PROXY_PORT"
export all_proxy=${LASR_LOGIN_IP}:$PROXY_PORT


