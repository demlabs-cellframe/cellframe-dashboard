import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item
{
    property string nameWallet:""

    id: popup

    Rectangle 
    {
        id: backgroundFrame
        anchors.fill: parent
        visible: opacity

        color: currTheme.popup
        opacity: 0.0

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: hide()
        }

        Behavior on opacity {NumberAnimation{duration: 100}}
    }

    Rectangle
    {
        id: farmeActivate
        anchors.centerIn: parent
        visible: opacity
        opacity: 0

        Behavior on opacity {NumberAnimation{duration: 200}}

        width: 298
        height: 279

        color: currTheme.popup
        radius: currTheme.popupRadius

        MouseArea
        {
            anchors.fill: parent
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.topMargin: 24
            anchors.bottomMargin: 24
            spacing: 0

            Text
            {
                Layout.fillWidth: true
                Layout.leftMargin: 50
                Layout.rightMargin: 50
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Create password")
                font: mainFont.dapFont.bold16
                color: currTheme.white
                elide: Text.ElideMiddle
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

                    onTextChanged:
                    {
                        text === "" ? continueBtn.enabled = false : continueBtn.enabled = true
                    }
                }
            }

            Text
            {
                id: textExpired
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 16
                Layout.leftMargin: 32
                Layout.rightMargin: 32

                color: currTheme.white
                text: qsTr("After confirmation, you will be required to enter your password every time you use the wallet")
                font: mainFont.dapFont.medium14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }

            RowLayout
            {
                id: layoutPeriod

                Layout.fillWidth: true
                Layout.topMargin: 24
                Layout.leftMargin: 32
                Layout.rightMargin: 32
                DapButton
                {
                    id: cancelBtn
                    Layout.fillWidth: true
                    implicitHeight: 40
                    textButton: qsTr("Cancel")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.regular14
                    selected: false
                    onClicked:
                    {
                        hide()
                    }
                }

                DapButton
                {
                    id: continueBtn
                    Layout.fillWidth: true
                    implicitHeight: 40
                    textButton: qsTr("Continue")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.regular14
                    selected: true
                    onClicked:
                    {
                        logicMainApp.requestToService("DapCreatePassForWallet", nameWallet, textInputPasswordWallet.text)
                    }
                }
            }

             Connections
             {
                 target: dapServiceController
                 function onPasswordCreated(rcvData)
                 {
                     if(rcvData === "Success")
                     {
                         dapMainWindow.infoItem.showInfo(
                                     180,0,
                                     dapMainWindow.width*0.5,
                                     8,
                                     "Wallet converted",
                                     "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")


                     }
                     else
                     {
                         dapMainWindow.infoItem.showInfo(
                                     210,0,
                                     dapMainWindow.width*0.5,
                                     8,
                                     "Error wallet convert",
                                     "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
                     }
                     hide()
                 }
             }
        }
    }

    InnerShadow 
    {
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
    DropShadow 
    {
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

    function hide()
    {

        backgroundFrame.opacity = 0.0
        farmeActivate.opacity = 0.0
        visible = false
    }

    function show(name_wallet)
    {
        continueBtn.enabled = false
        textInputPasswordWallet.bottomLine.color = currTheme.input
        visible = true
        nameWallet = name_wallet
        textInputPasswordWallet.text = ""
        backgroundFrame.opacity = 0.4
        farmeActivate.opacity = 1
    }
}
