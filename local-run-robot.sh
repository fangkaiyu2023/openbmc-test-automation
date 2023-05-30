#!/bin/bash -x
MACHINE=${MACHINE:-"romulus"}
ROBOT_CODE_HOME=${ROBOT_CODE_HOME:-$PWD}
ROBOT_TEST_CMD="${ROBOT_TEST_CMD:-"python3 -m robot\
    -v OPENBMC_HOST:127.0.0.1 \
    -v SSH_PORT:2222 \
    -v HTTPS_PORT:2443 \
    -v IPMI_PORT:2623 \
    -v PLATFORM_ARCH_TYPE:x86 \
    -v REDFISH_SUPPORT_TRANS_STATE:1 \
    --argumentfile ./test_lists/QEMU_CI ./tests ./redfish ./ipmi"}"

chmod ugo+rw -R "${ROBOT_CODE_HOME}"/*

# 执行CI测试
eval "${ROBOT_TEST_CMD}"

cp "${ROBOT_CODE_HOME}"/*.xml "${HOME}/"
cp "${ROBOT_CODE_HOME}"/*.html "${HOME}/"
if [ -d logs ] ; then
    cp -Rf "${ROBOT_CODE_HOME}"/logs "${HOME}"/ ;
fi

#rm -rf ${ROBOT_CODE_HOME}
