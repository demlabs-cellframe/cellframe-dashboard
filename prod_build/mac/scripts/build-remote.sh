#!/bin/bash

KEY="~/.ssh/prod_build"
HOST="CloudXMAC@185.17.26.239"
srcpath=$(pwd)

tar czpf $wd/sapnet-client.tar.gz ./
# Will pack an archive and then moving on.
ssh -i $KEY $HOST 'rm -rf demlabs/production/resources/sap.support && mkdir -p demlabs/production/resources/sap.support/sapnet-client' && \
scp -i $KEY "$wd/sapnet-client.tar.gz" "$HOST:~/demlabs/production/resources/sap.support/sapnet-client" && \
ssh -i $KEY $HOST 'cd demlabs/production/resources/sap.support/sapnet-client && tar -xzpf sapnet-client.tar.gz' && \
ssh -i $KEY $HOST 'cd demlabs/production && ./prob sapnet-client mac build' && \
scp -i $KEY $HOST:~/demlabs/production/build/UltraPad/ROOT/*.pkg $wd/builds/pkg/ && \
ssh -i $KEY $HOST rm -rf demlabs/production/build/* && rm -rf demlabs/production/resources/sap.support || errcode=$?

exit $errcode
