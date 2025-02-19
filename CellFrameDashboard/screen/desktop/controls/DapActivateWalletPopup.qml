import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item{
    property string ttl:"60"

    property string nameWallet:""

    property bool isOpen: false
    property bool isExpired: false

    signal activatingSignal(var nameWallet, var statusRequest)


    id: popup

    Rectangle {
        id: backgroundFrame
        anchors.fill: parent
        visible: opacity

        color: currTheme.popup
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
        height: {
            if(isExpired){
                return textError.visible ? 425 : 405
            }
            else{
                return textError.visible ? 377 : 357
            }
        }


        color: currTheme.popup
        radius: currTheme.popupRadius

        MouseArea{
            anchors.fill: parent
        }

        HeaderButtonForRightPanels{
            id: closeButton
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
                text: qsTr("Activate ") + "'" + nameWallet + "'" + qsTr(" wallet")
                font: mainFont.dapFont.bold14
                color: currTheme.white
                elide: Text.ElideMiddle
            }

            Text{
                id: textExpired
                visible: isExpired
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 12
                Layout.leftMargin: 24
                Layout.rightMargin: 24

                color: currTheme.white
                text: qsTr("Secure session time expired. Please enter your password to continue")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }

            Rectangle
            {
                color: currTheme.mainBackground
                Layout.fillWidth: true
                Layout.topMargin: isExpired? 20 : 16
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
                height: 70
                color: "transparent"

                DapTextField
                {
                    id: textInputPasswordWallet
                    placeholderText: qsTr("Password")

                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignLeft
                    validator: RegExpValidator { regExp: /[^а-яёъьА-ЯЁЪЬ\s]+/}
                    echoMode: indicator.isActive ? TextInput.Normal : TextInput.Password
                    passwordChar: "•"
                    height: 26
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 18
                    bottomLineVisible: true
                    bottomLineSpacing: 5
                    bottomLine.anchors.leftMargin: 8
                    bottomLine.anchors.rightMargin: 0
                    indicatorTopMargin: 2
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
                Layout.bottomMargin: 16

                color: currTheme.red
                text: qsTr("Invalid password")
                font: mainFont.dapFont.regular12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle
            {
                color: currTheme.mainBackground
                Layout.fillWidth: true
//                Layout.topMargin: 16
                height: 30
                Text
                {
                    color: currTheme.white
                    text: qsTr("Secure session time")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
            }

            RowLayout
            {
                id: layoutPeriod

                Layout.fillWidth: true
                Layout.topMargin: 16
                Layout.leftMargin: 24
                Layout.rightMargin: 24

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
                Layout.topMargin: 16
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                height: 32
                spacing: 6
                Image{
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    mipmap: true
                    source: "qrc:/Resources/BlackTheme/icons/other/ic_infoGray.svg"
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

            DapButton
            {
                id: buttonUnlock
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 20
                implicitHeight: 36
                textButton: qsTr("Activate")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                enabled: textInputPasswordWallet.text.length
                onClicked:
                {
                    walletModule.activateOrDeactivateWallet(nameWallet,"activate", textInputPasswordWallet.text, ttl)
                    walletModule.updateWalletList()
                }
            }

            Connections{
                target: dapServiceController
                function onRcvActivateOrDeactivateReply(jsonData)
                {
                    var rcvData = JSON.parse(jsonData).result
                    if(rcvData.cmd !== "deactivate")
                    {
                        if(rcvData.success){
                            textInputPasswordWallet.bottomLine.color = currTheme.input
                            textError.visible = false
                            activatingSignal(nameWallet, true)

                            dapMainWindow.infoItem.showInfo(
                                        174,0,
                                        dapMainWindow.width*0.5,
                                        8,
                                        qsTr("Wallet activated"),
                                        "qrc:/Resources/" + pathTheme + "/icons/other/icon_walletUnlocked.svg")
                            walletModule.updateWalletInfo()
                            hide()
                        }
                        else
                        {
                            textInputPasswordWallet.bottomLine.color = currTheme.red
                            textError.visible = true
                            activatingSignal(nameWallet, false)
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
        isOpen = false
        backgroundFrame.opacity = 0.0
        farmeActivate.opacity = 0.0
        visible = false
    }

    function show(name_wallet, expired){
        isExpired = expired
        isOpen = true
        textInputPasswordWallet.bottomLine.color = currTheme.input
        textError.visible = false
        visible = true
        nameWallet = name_wallet
        textInputPasswordWallet.text = ""
        backgroundFrame.opacity = 0.4
        farmeActivate.opacity = 1
    }
}


