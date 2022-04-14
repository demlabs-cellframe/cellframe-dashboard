import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../parts"


Page {
    id: root
    property alias doneButton: doneButton
    property alias finishedText: finishedText

    background: Rectangle {
        color: "transparent"
    }

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Text {
                id: finishedText
                y: 198 * pt
                x: 53 * pt
                font: mainFont.dapFont.medium28
                color: currTheme.textColor
                text: qsTr("Certificate created\nsuccessfully")
                horizontalAlignment: Text.AlignHCenter
            }

            DapButton {
                id: doneButton
                textButton: qsTr("Done")
                y: 468 * pt
                x: (parent.width - width) / 2
                height: 36 * pt
                width: 132 * pt
                fontButton: mainFont.dapFont.regular16
                horizontalAligmentText: Qt.AlignHCenter

                onClicked: certificateNavigator.clearRightPanel()
            }
        }
    } //frameRightPanel

}   //root
