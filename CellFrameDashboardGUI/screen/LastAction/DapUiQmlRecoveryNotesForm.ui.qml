import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
import "../"

DapUiQmlScreen {
    property alias pressedNextButton: nextButton.pressed
    property bool isWordsCopied: copyNotesButton.checked

    id: recoveryNoteMenu
    color: "#edeff2"

    Rectangle {
        id: wordTextArea
        height: 30 * pt
        color: "#757184"
        anchors.rightMargin: 1
        anchors.leftMargin: 1
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        Text {
            id: wordText
            color: "#ffffff"
            text: qsTr("24 words")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 16
            font.pointSize: 12
            horizontalAlignment: Text.AlignLeft
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
        }
    }

    Rectangle {
        id: saveNotesDescription
        color: "#edeff2"
        height: 42
        anchors.top: wordTextArea.bottom
        anchors.topMargin: 24
        anchors.left: wordTextArea.left
        anchors.right: wordTextArea.right

        Text {
            anchors.fill: parent
            text: qsTr("Keep these words in a safe place. They will be\nrequired to restore your wallet in case of loss of\naccess to it")
            anchors.leftMargin: 1
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#FF0300"

            font {
                pointSize: 16
                family: "Roboto"
                styleName: "Normal"
                weight: Font.Normal
            }
        }
    }

    Rectangle {
        id: recoveryWords
        height: 270
        anchors.top: saveNotesDescription.bottom
        anchors.topMargin: 24
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 1 * pt
        anchors.rightMargin: 1 * pt
        color: "#edeff2"

        ListModel {
            id: listRecoveryWords
            ListElement {
                word: "Word1"
            }
            ListElement {
                word: "Word2"
            }
            ListElement {
                word: "Word3"
            }
            ListElement {
                word: "Word4"
            }
            ListElement {
                word: "Word5"
            }
            ListElement {
                word: "Word6"
            }
            ListElement {
                word: "Word7"
            }
            ListElement {
                word: "Word8"
            }
            ListElement {
                word: "Word9"
            }
            ListElement {
                word: "Word10"
            }
            ListElement {
                word: "Word11"
            }
            ListElement {
                word: "Word12"
            }
        }

        RowLayout {
            height: 270
            spacing: 60
            anchors.right: parent.right
            anchors.rightMargin: 1
            anchors.left: parent.left
            anchors.leftMargin: 1

            ListView {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                width: 50
                height: 300
                model: listRecoveryWords
                delegate: Text {
                    text: word
                    color: "#070023"
                    font {
                        pointSize: 16
                        family: "Roboto"
                        styleName: "Normal"
                        weight: Font.Normal
                    }
                }
            }

            ListView {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                width: 50
                height: 300
                model: listRecoveryWords
                delegate: Text {
                    text: word
                    color: "#070023"
                    font {
                        pointSize: 16
                        family: "Roboto"
                        styleName: "Normal"
                        weight: Font.Normal
                    }
                }
            }
        }
    }

    Rectangle {
        id: notifyNotesSavedArea
        height: 70
        anchors.top: recoveryWords.bottom
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#EDEFF2"
        anchors.leftMargin: 1

        Text {
            id: notifyText
            anchors.centerIn: parent
            text: qsTr("")
            color: "#6F9F00"
            font.pointSize: 14
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    RowLayout {
        id: actionButtons
        height: 44
        anchors.leftMargin: 1
        spacing: 30
        anchors.top: notifyNotesSavedArea.bottom
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.right: parent.right
        Layout.leftMargin: 26
        Layout.columnSpan: 2

        Button {
            id: nextButton
            height: 44
            width: 130
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Text {
                id: nextButtonText
                text: qsTr("Next")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "#ffffff"
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                font.pointSize: 18
                horizontalAlignment: Text.AlignLeft
            }

            background: Rectangle {
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: "#3E3853"
            }
        }

        Button {
            id: copyNotesButton
            height: 44
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            width: 130
            checkable: true

            Text {
                id: copyNotesButtonText
                text: qsTr("Copy")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: copyNotesButton.checked ? "#3E3853" : "#FFFFFF"
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                font.pointSize: 18
                horizontalAlignment: Text.AlignLeft
            }

            background: Rectangle {
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: copyNotesButton.checked ? "#EDEFF2" : "#3E3853"
                border.color: "#3E3853"
                border.width: 1 * pt
            }

            onClicked: notifyText.text = qsTr(
                           "Recovery words copied to clipboard. Keep them in a\nsafe place before proceeding to the next step.")
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
