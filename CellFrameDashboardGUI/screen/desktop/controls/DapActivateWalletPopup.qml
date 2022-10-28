import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item{
    property string ttl:"60"

    property string nameWallet:""

    signal activatingSignal(var nameWallet)

    id: popup

    Rectangle {
        id: backgroundFrame
        anchors.fill: parent
        visible: opacity

        color: currTheme.backgroundMainScreen
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
        height: 357
        color: currTheme.buttonColorNoActive
        radius: currTheme.radiusRectangle

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
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Activate wallet")
                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }

            Rectangle
            {
                color: currTheme.backgroundMainScreen
                Layout.fillWidth: true
                Layout.topMargin: 16
                height: 30
                Text
                {
                    color: currTheme.textColor
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
                    font: echoMode === TextInput.Password && length ? mainFont.dapFont.regular8 :
                                                                      mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignLeft
                    anchors.fill: parent
                    anchors.leftMargin: echoMode === TextInput.Password && length ? 6 : 0
                    anchors.topMargin: 20
                    anchors.bottomMargin: 29
                    anchors.rightMargin: 24


                    validator: RegExpValidator { regExp: /[0-9A-Za-z\_\:\(\)\?\@\s*]+/ }
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
                }
            }

            Rectangle
            {
                color: currTheme.backgroundMainScreen
                Layout.fillWidth: true
//                Layout.topMargin: 16
                height: 30
                Text
                {
                    color: currTheme.textColor
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
                    color: currTheme.textColorGrayThree
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
                textButton: qsTr("Unlock")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                enabled: textInputPasswordWallet.text.length
                onClicked:
                {
                    dapServiceController.requestToService("DapWalletActivateOrDeactivateCommand", nameWallet,"activate", textInputPasswordWallet.text, ttl)
                    activatingSignal(nameWallet)
                }
            }
        }
    }

    DropShadow {
        anchors.fill: farmeActivate
        source: farmeActivate
        color: currTheme.reflection
        horizontalOffset: -1
        verticalOffset: -1
        radius: 0
        samples: 0
        opacity: farmeActivate.opacity
        fast: true
        cached: true
    }
    DropShadow {
        anchors.fill: farmeActivate
        source: farmeActivate
        color: currTheme.shadowColor
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 20
        opacity: farmeActivate.opacity
    }

    function hide(){
        backgroundFrame.opacity = 0.0
        farmeActivate.opacity = 0.0
        visible = false
    }

    function show(name_wallet){
        visible = true
        nameWallet = name_wallet
        textInputPasswordWallet.text = ""
        backgroundFrame.opacity = 0.4
        farmeActivate.opacity = 1
    }
}


