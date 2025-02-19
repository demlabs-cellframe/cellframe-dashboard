import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../controls"

Item
{
    id: mainItem

    signal closed()
    signal save()
    signal reset()

    Page
    {
        id: page

        x: 0
        y: dapMainWindow.height + height
        width: dapMainWindow.width
        height: 320

        Behavior on y{
            NumberAnimation{
                duration: 200
            }
        }

        onVisibleChanged:
        {
            if (visible)
                y = dapMainWindow.height - height
            else
                y = dapMainWindow.height + height
        }

        background: Rectangle {
            color: currTheme.mainBackground
            radius: 30
            border.width: 1
            border.color: currTheme.border
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 1
                anchors.bottomMargin: 1
                color: currTheme.mainBackground
            }
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 1
                anchors.bottomMargin: 1
                color: currTheme.mainBackground
            }
        }

        Text
        {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16

            horizontalAlignment: Text.AlignHCenter

            font: mainFont.dapFont.bold14
            color: currTheme.white

            text: qsTr("Are you sure?")
        }

        Image {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 16
            z: 1

            source: area.containsMouse? "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross_hover.svg" :
                                        "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross.svg"
            mipmap: true

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    dapBottomPopup.hide()
                    mainItem.closed()
                }
            }
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.topMargin: 100
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            spacing: 10

            Text
            {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20

                text: qsTr(
"Are you sure you want to change the node settings? After saving the settings, the node will be rebooted.")
                color: currTheme.gray
                font: mainFont.dapFont.regular15

                wrapMode: Text.WordWrap

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            DapButton
            {
        //        enabled: false
                Layout.topMargin: 50
                Layout.alignment: Qt.AlignCenter
                implicitHeight: 36
                implicitWidth: 132
                textButton: qsTr("Save changes")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14

                onClicked:
                {
                    dapBottomPopup.hide()
                    mainItem.save()
                }
            }

/*            RowLayout
            {
                Layout.topMargin: 50
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                spacing: 20

                DapButton
                {
            //        enabled: false
                    implicitHeight: 36
                    implicitWidth: 132
                    textButton: qsTr("Reset changes")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14

                    onClicked:
                    {
                        dapBottomPopup.hide()
                        mainItem.reset()
                    }
                }

                DapButton
                {
            //        enabled: false
                    implicitHeight: 36
                    implicitWidth: 132
                    textButton: qsTr("Save changes")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14

                    onClicked:
                    {
                        dapBottomPopup.hide()
                        mainItem.save()
                    }
                }
            }*/

            Item
            {
                Layout.fillHeight: true
            }
        }

    }

}

