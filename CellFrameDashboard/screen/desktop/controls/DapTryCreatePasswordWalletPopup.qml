import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item
{
    property string nameWallet:""
    property var nextWindowComponent

    id: popup

    Rectangle
    {
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

    Rectangle
    {
        id: farmeActivate
        anchors.centerIn: parent
        visible: opacity
        opacity: 0

        Behavior on opacity {NumberAnimation{duration: 200}}

        width: 298
        height: 218

        color: currTheme.popup
        radius: currTheme.popupRadius

        MouseArea
        {
            anchors.fill: parent
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.topMargin: 32
            anchors.bottomMargin: 32
            spacing: 0

            Text
            {
                Layout.fillWidth: true
                Layout.leftMargin: 32
                Layout.rightMargin: 32
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Sure to Create Password?")
                font: mainFont.dapFont.medium16
                color: currTheme.white
                elide: Text.ElideMiddle
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
                text: qsTr("When restoring a wallet originally created without a password, no password will be requested")
                font: mainFont.dapFont.regular14
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
                        hide()
                        nextWindowComponent.show(nameWallet)
                    }
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

    function show(name_wallet, nextWindow, expired)
    {
        nextWindowComponent = nextWindow
        visible = true
        nameWallet = name_wallet
        backgroundFrame.opacity = 0.4
        farmeActivate.opacity = 1
    }
}
