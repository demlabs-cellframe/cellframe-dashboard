import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../parts"


Page {
    id: root

    property bool accept
    property string titleText
    property string contentText

    background: Rectangle {
        color: "transparent"
    }

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0

    ColumnLayout
    {
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: childrenRect.height
        spacing: 20 * pt

        Text {
            id: finishedTextTitle
            font: mainFont.dapFont.medium28
            color: currTheme.textColor
            text: titleText//qsTr("Certificate created\nsuccessfully")
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: finishedTextContent
            font: mainFont.dapFont.medium20
            color: currTheme.textColor
            text: contentText//qsTr("Certificate created\nsuccessfully")
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            DapButton {
                id: doneButton
                textButton: {if (accept) return qsTr("Done")
                    else return qsTr("Back")}
                height: 36 * pt
                width: 132 * pt
                x: parent.width * 0.5 - width * 0.5
                fontButton: mainFont.dapFont.regular16
                horizontalAligmentText: Qt.AlignHCenter

                onClicked:
                {
                    if (accept)
                        certificateNavigator.clearRightPanel()
                    else dapRightPanel.pop()
                }
            }
        }
    }

}   //root
