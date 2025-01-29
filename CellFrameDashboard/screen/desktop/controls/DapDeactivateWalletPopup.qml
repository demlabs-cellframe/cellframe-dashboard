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
        height: 150
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

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 17
            anchors.bottomMargin: 24
            spacing: 0

            Text{
                Layout.fillWidth: true
                Layout.leftMargin: 50
                Layout.rightMargin: 50
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Deactivate wallet")
                font: mainFont.dapFont.bold14
                lineHeightMode: Text.FixedHeight
                lineHeight: 17.5
                color: currTheme.white
                elide: Text.ElideMiddle
            }

            Text{
                Layout.topMargin: 5
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Are you sure you want to deactivate your wallet?")
                font: mainFont.dapFont.medium12
                lineHeightMode: Text.FixedHeight
                lineHeight: 16
                color: currTheme.white
            }

            DapButton
            {
                id: buttonLock
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.alignment: Qt.AlignBottom
                implicitHeight: 36
                textButton: qsTr("Deactivate")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                onClicked:
                {
                    walletModule.activateOrDeactivateWallet(nameWallet, "deactivate")
                    walletModule.updateWalletList()
                    buttonLock.enabled = false
                }
            }

            Connections{
                target: dapServiceController
                function onRcvActivateOrDeactivateReply(jsonData)
                {
                    var rcvData = JSON.parse(jsonData).result
                    if(rcvData.cmd !== "activate")
                    {
                        if(rcvData.success){
                            deactivatingSignal(nameWallet, true)
                            dapMainWindow.infoItem.showInfo(
                                        191,0,
                                        dapMainWindow.width*0.5,
                                        8,
                                        qsTr("Wallet deactivated"),
                                        "qrc:/Resources/" + pathTheme + "/icons/other/icon_walletLocked.svg")
                            walletModule.updateWalletInfo()
                            hide()
                        }
                        else
                        {
                            console.log("Error deactivating wallet:", JSON.stringify(rcvData.message))
                            deactivatingSignal(nameWallet, false)
                            dapMainWindow.infoItem.showInfo(
                                        191,0,
                                        dapMainWindow.width*0.5,
                                        8,
                                        qsTr("Error deactivating"),
                                        "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
                            buttonLock.enabled = true
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
        visible = true
        nameWallet = name_wallet
        buttonLock.enabled = true
        backgroundFrame.opacity = 0.4
        farmeActivate.opacity = 1
    }
}


