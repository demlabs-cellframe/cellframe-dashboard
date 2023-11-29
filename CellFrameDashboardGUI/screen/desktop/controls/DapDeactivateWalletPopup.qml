import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item{

    property string nameWallet:""

    signal deactivatingSignal(var nameWallet, var statusRequest)

    id: popup

    Rectangle {
        id: backgroundFrame
        anchors.fill: parent
        visible: opacity

        color: currTheme.mainBackground
        opacity: 0.0

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onClicked: hide()
        }

        Behavior on opacity {NumberAnimation{duration: 100}}
    }

    Rectangle{
        id: farmeActivate
        anchors.centerIn: parent
        visible: opacity
        opacity: 0

        Behavior on opacity {NumberAnimation{duration: 200}}

        width: 328
        height: textError.visible ? 289 : 265
        color: currTheme.popup
        radius: currTheme.popupRadius

        MouseArea{
            anchors.fill: parent
        }

        HeaderButtonForRightPanels{
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 9
            anchors.rightMargin: 10

            height: 20
            width: 20
            heightImage: 20
            widthImage: 20

            normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
            hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"

            onClicked: hide()
        }

        ColumnLayout{
            anchors.fill: parent
            anchors.topMargin: 24
            anchors.bottomMargin: 24
            spacing: 0

            Text{
                Layout.fillWidth: true
                Layout.leftMargin: 50
                Layout.rightMargin: 50
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Deactivate " + "'" + nameWallet + "'" + " wallet"
                font: mainFont.dapFont.bold14
                color: currTheme.white
                elide: Text.ElideMiddle
            }

            Text{
                Layout.topMargin: 12
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Enter password to deactivate wallet")
                font: mainFont.dapFont.medium12
                color: currTheme.white
            }

            Rectangle
            {
                color: currTheme.mainBackground
                Layout.fillWidth: true
                Layout.topMargin: 20
                height: 30
                Text
                {
                    color: currTheme.white
                    text: qsTr("Wallet password")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.leftMargin: 18
                Layout.rightMargin: 24
                height: 69
                color: "transparent"

                DapTextField
                {
                    id: textInputPasswordWallet

                    echoMode: indicator.isActive ? TextInput.Normal : TextInput.Password


                    anchors.verticalCenter: parent.verticalCenter
                    placeholderText: qsTr("Password")
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignLeft
                    anchors.fill: parent
                    anchors.leftMargin: echoMode === TextInput.Password && length ? 6 : 0
                    anchors.topMargin: 20
                    anchors.bottomMargin: 29
                    anchors.rightMargin: 24


                    validator: RegExpValidator { regExp: /[^а-яёъьА-ЯЁЪЬ\s\-]+/}
//                    validator: RegExpValidator { regExp: /[0-9A-Za-z\_\:\(\)\?\@\{\}\%\<\>\,\.\*\;\:\'\"\[\]\/\?\"\|\\\^\&\*]+/ }
                    bottomLineVisible: true
                    bottomLineSpacing: 8

                    bottomLine.anchors.leftMargin: echoMode === TextInput.Password && length ? 1 : 7
                    bottomLine.anchors.rightMargin: -24
                    indicator.anchors.rightMargin: -24

                    indicatorVisible: true
                    indicatorSourceDisabled: "qrc:/Resources/BlackTheme/icons/other/icon_eyeHide.svg"
                    indicatorSourceEnabled: "qrc:/Resources/BlackTheme/icons/other/icon_eyeShow.svg"
                    indicatorSourceDisabledHover: "qrc:/Resources/BlackTheme/icons/other/icon_eyeHideHover.svg"
                    indicatorSourceEnabledHover: "qrc:/Resources/BlackTheme/icons/other/icon_eyeShowHover.svg"

                    selectByMouse: true
                    DapContextMenu{isActiveCopy: false}
                }
            }

            Text{
                id: textError
                visible: false
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: -12
                Layout.bottomMargin: 20

                color: currTheme.red
                text: qsTr("Invalid password")
                font: mainFont.dapFont.regular12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            DapButton
            {
                id: buttonLock
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
//                Layout.topMargin: 0
                implicitHeight: 36
                textButton: qsTr("Deactivate")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                enabled: textInputPasswordWallet.text.length
                onClicked:
                {
                    logicMainApp.requestToService("DapWalletActivateOrDeactivateCommand", nameWallet,"deactivate", textInputPasswordWallet.text)
                    walletModule.getWalletsInfo("true")
                    modulesController.updateListWallets()
                }
            }

            Connections{
                target: dapServiceController
                function onRcvActivateOrDeactivateReply(rcvData){
                    if(rcvData.cmd !== "activate")
                    {
                        if(rcvData.success){
                            textInputPasswordWallet.bottomLine.color = currTheme.input
                            textError.visible = false
                            deactivatingSignal(nameWallet, true)


                            dapMainWindow.infoItem.showInfo(
                                        191,0,
                                        dapMainWindow.width*0.5,
                                        8,
                                        "Wallet deactivated",
                                        "qrc:/Resources/" + pathTheme + "/icons/other/icon_walletLocked.svg")

                            hide()
                        }else{
                            textInputPasswordWallet.bottomLine.color = currTheme.red
                            textError.visible = true
                            deactivatingSignal(nameWallet, false)
                        }
                    }
                }
            }
        }
    }

    InnerShadow {
        anchors.fill: farmeActivate
        source: farmeActivate
        color: currTheme.reflection
        horizontalOffset: 1
        verticalOffset: 1
        radius: 0
        samples: 10
        opacity: farmeActivate.opacity
        fast: true
        cached: true
    }
    DropShadow {
        anchors.fill: farmeActivate
        source: farmeActivate
        color: currTheme.shadowMain
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 20
        opacity: farmeActivate.opacity ? 0.42 : 0
        cached: true
    }

    function hide(){
        backgroundFrame.opacity = 0.0
        farmeActivate.opacity = 0.0
        visible = false
    }

    function show(name_wallet){
        textInputPasswordWallet.bottomLine.color = currTheme.input
        textError.visible = false
        visible = true
        nameWallet = name_wallet
        textInputPasswordWallet.text = ""
        backgroundFrame.opacity = 0.4
        farmeActivate.opacity = 1
    }
}


