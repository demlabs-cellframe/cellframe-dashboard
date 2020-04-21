#!/bin/bash

KEY="~/.ssh/prod_build"
HOST="CloudXMAC@185.17.26.239"
srcpath=$(pwd)

tar czpf $wd/dapchainvpn-client.tar.gz ./
# Will pack an archive and then moving on.
ssh -i $KEY $HOST 'rm -rf demlabs/production/resources/dap.support && mkdir -p demlabs/production/resources/dap.support/dapchainvpn-client' && \
scp -i $KEY "$wd/dapchainvpn-client.tar.gz" "$HOST:~/demlabs/production/resources/dap.support/dapchainvpn-client" && \
ssh -i $KEY $HOST 'cd demlabs/production/resources/dap.support/dapchainvpn-client && tar -xzpf dapchainvpn-client.tar.gz' && \
ssh -i $KEY $HOST "cd demlabs/production && ./prob $brand mac build" && \
scp -i $KEY $HOST:~/demlabs/production/build/$brand/ROOT/*.pkg $wd/builds/pkg/ && \
ssh -i $KEY $HOST rm -rf demlabs/production/build/* && rm -rf demlabs/production/resources/dap.support || errcode=$?

exit $errcode
