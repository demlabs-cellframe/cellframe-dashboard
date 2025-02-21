
# Android keystore storage
Used by /prod_build/pack.sh scripts from different projects.

Put here .jks file, and provide a .sh file (see example.sh).

andrdeployqt will use this params to generate a signed APK. 

Use this in gitlab-ci files and for manual builds on linux systems.

dapchainvpn-client example: 'prod_build/pack.sh --target android --sign /opt/buildtools/example.sh'
