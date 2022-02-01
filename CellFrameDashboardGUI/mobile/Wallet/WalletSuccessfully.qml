import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
    title: qsTr("24 words")

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width
        spacing: 30

        Item {
            Layout.fillHeight: true
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Wallet created successfully")
            wrapMode: Text.WordWrap
        }

        Button {
            Layout.alignment: Qt.AlignHCenter

            text: qsTr("Done")
            onClicked:
            {
                mainStackView.clearAll()
            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}
