import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

DapBottomScreen{
    property string ttl:"60"

    property string nameWallet:""

    property bool isOpen: false
    property bool isExpired: false

    heightForm:  isExpired? 439:397
    header.text: qsTr("Activate ") + "'" + nameWallet + "'" + qsTr(" wallet")
    header.elide: Text.ElideMiddle

    id: popup

    dataItem:
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 16
        anchors.bottomMargin: 0
        spacing: 0

        Text{
            Layout.topMargin: 10
            id: textExpired
            visible: isExpired
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            Layout.leftMargin: 48
            Layout.rightMargin: 48

            color: currTheme.white
            text: qsTr("Secure session time expired. Please enter your password to continue")
            font: mainFont.dapFont.medium12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }

        Rectangle
        {
            Layout.topMargin: 30
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 15
            Text
            {
                color: currTheme.gray
                text: qsTr("Wallet password")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }
        }

        Rectangle
        {
            id: framePass
            Layout.topMargin: 6
            Layout.fillWidth: true
            height: 40
            color: currTheme.secondaryBackground

            DapWalletTextField
            {
                id: textInputPasswordWallet

                echoMode: indicator.isActive ? TextInput.Normal : TextInput.Password



                placeholderText: qsTr("Password")
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.rightMargin: 16 + indicator.width + 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 1

                validator: RegExpValidator { regExp: /[0-9A-Za-z\_\:\(\)\?\@\{\}\%\<\>\,\.\*\;\:\'\"\[\]\/\?\"\|\\\^\&\*]+/ }

                indicator.anchors.rightMargin: -(16 + indicator.width/2 + 2)

                indicatorVisible: true
                indicatorSourceDisabled: "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_eyeHide.svg"
                indicatorSourceEnabled: "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_eyeShow.svg"
                indicatorSourceDisabledHover: "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_eyeHideHover.svg"
                indicatorSourceEnabledHover: "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_eyeShowHover.svg"
                selectByMouse: true
                isActiveCopy: false

                onUpdateFeild:
                    {
                        if(textInputPasswordWallet.activeFocus)
                        {
                            var delta = textInputPasswordWallet.getDelta()
                            if(delta)
                            {
                                form.y = popup.parent.height - (heightForm + delta)
                            }
                        }
                        else
                        {
                            form.y = popup.parent.height - heightForm
                        }
                    }
            }
        }

        Text{
            id: textError
            visible: false
            Layout.alignment: Qt.AlignLeft
            Layout.topMargin: 4

            color: currTheme.red
            text: qsTr("Invalid password")
            font: mainFont.dapFont.regular12
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle
        {
            color: currTheme.mainBackground
            Layout.fillWidth: true
            Layout.topMargin: 20
            height: 15
            Text
            {
                color: currTheme.gray
                text: qsTr("Secure session time")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }
        }

        RowLayout
        {
            id: layoutPeriod

            Layout.fillWidth: true
            Layout.topMargin: 15

            DapButton
            {
                id: button10Min
                Layout.fillWidth: true
                implicitHeight: 26
                textButton: qsTr("10m")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button10Min.selected = true
                    button30Min.selected = false
                    button1Hour.selected = false
                    button2Hour.selected = false
                    ttl = "10"

                }
            }

            DapButton
            {
                id: button30Min
                Layout.fillWidth: true
                implicitHeight: 26
                textButton: qsTr("30m")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button10Min.selected = false
                    button30Min.selected = true
                    button1Hour.selected = false
                    button2Hour.selected = false
                    ttl = "30"

                }
            }

            DapButton
            {
                id: button1Hour
                Layout.fillWidth: true
                implicitHeight: 26
                textButton: qsTr("1h")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: true
                onClicked:
                {
                    button10Min.selected = false
                    button30Min.selected = false
                    button1Hour.selected = true
                    button2Hour.selected = false
                    ttl = "60"
                }
            }

            DapButton
            {
                id: button2Hour
                Layout.fillWidth: true
                implicitHeight: 26
                textButton: qsTr("2h")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular12
                selected: false
                onClicked:
                {
                    button10Min.selected = false
                    button30Min.selected = false
                    button1Hour.selected = false
                    button2Hour.selected = true
                    ttl = "120"
                }
            }
        }

        RowLayout{
            Layout.fillWidth: true
            Layout.topMargin: 20
            height: 32
            spacing: 6
            DapImageRender{
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                source: "qrc:/walletSkin/Resources/BlackTheme/icons/other/ic_infoGray.svg"
            }

            Text{
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: qsTr("The session may end earlier if the node service detects inactivity")
                font: mainFont.dapFont.medium12
                color: currTheme.gray
                wrapMode: Text.WordWrap
            }
        }

        Item{Layout.fillHeight: true}

        DapButton
        {
            id: buttonUnlock
            Layout.fillWidth: true
            Layout.leftMargin: 118
            Layout.rightMargin: 118
            Layout.bottomMargin: 48
            implicitHeight: 36
            textButton: qsTr("Activate")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            enabled: textInputPasswordWallet.text.length
            onClicked:
            {
                walletModule.activateOrDeactivateWallet(nameWallet, "activate", textInputPasswordWallet.text, ttl)
                walletModule.updateWalletList()
            }
        }
    }

    function hide(){
        isOpen = false
        visible = false
        dapBottomPopup.hide()
    }

    function show(name_wallet, expired){
        isExpired = expired
        isOpen = true
        textError.visible = false
        visible = true
        nameWallet = name_wallet
        textInputPasswordWallet.text = ""
    }

    Component.onCompleted:
        show(nameWall, expiresWallet)

    Connections{
        target: dapServiceController
        function onRcvActivateOrDeactivateReply(rcvData){
            var jsonDoc = JSON.parse(rcvData)
            if(jsonDoc && jsonDoc.result.cmd === "activate" && jsonDoc.result.success)
            {
                framePass.border.width = 0
                textError.visible = false
                activatingSignal(nameWallet, true)

                dapMainWindow.infoItem.showInfo(
                            171,0,
                            qsTr("Wallet activated"),
                            "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/icon_walletUnlocked.svg")

                hide()
            }
            else
            {
                textError.visible = true

                framePass.border.width = 1
                framePass.border.color = currTheme.red
                framePass.radius = 4

                activatingSignal(nameWallet, false)
            }
        }
    }
}


