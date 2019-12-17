import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "../"
import "qrc:/"

DapUiQmlScreen {
    property alias pressedNextButton: nextButton.pressed
    property bool isWordsCopied: copyNotesButton.checked

    id: recoveryNoteMenu
    color: "#edeff2"

    Rectangle {
        id: wordTextArea
        height: 30 * pt
        color: "#757184"
        anchors.rightMargin: 1 * pt
        anchors.leftMargin: 1 * pt
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        Text {
            id: wordText
            color: "#ffffff"
            text: qsTr("24 words")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8 * pt
            anchors.top: parent.top
            anchors.topMargin: 8 * pt
            anchors.left: parent.left
            anchors.leftMargin: 16 * pt
            font.pointSize: 12 * pt
            horizontalAlignment: Text.AlignLeft
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
        }
    }

    Rectangle {
        id: saveNotesDescription
        color: "#edeff2"
        height: 42 * pt
        anchors.top: wordTextArea.bottom
        anchors.topMargin: 24 * pt
        anchors.left: wordTextArea.left
        anchors.right: wordTextArea.right

        Text {
            anchors.fill: parent
            text: qsTr("Keep these words in a safe place. They will be\nrequired to restore your wallet in case of loss of\naccess to it")
            anchors.leftMargin: 1 * pt
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#FF0300"

            font {
                pointSize: 14 * pt
                family: "Roboto"
                styleName: "Normal"
                weight: Font.Normal
            }
        }
    }

    Rectangle {
        id: recoveryWords
        height: 270 * pt
        anchors.top: saveNotesDescription.bottom
        anchors.topMargin: 24 * pt
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
            height: 270 * pt
            spacing: 60 * pt
            anchors.right: parent.right
            anchors.rightMargin: 1 * pt
            anchors.left: parent.left
            anchors.leftMargin: 1 * pt

            ListView {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                width: 50 * pt
                height: 300 * pt
                model: listRecoveryWords
                delegate: Text {
                    text: word
                    color: "#070023"
                    font {
                        pointSize: 16 * pt
                        family: "Roboto"
                        styleName: "Normal"
                        weight: Font.Normal
                    }
                }
            }

            ListView {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                width: 50 * pt
                height: 300 * pt
                model: listRecoveryWords
                delegate: Text {
                    text: word
                    color: "#070023"
                    font {
                        pointSize: 16 * pt
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
        height: 70 * pt
        anchors.top: recoveryWords.bottom
        anchors.topMargin: 24 * pt
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#EDEFF2"
        anchors.leftMargin: 1 * pt

        Text {
            id: notifyText
            anchors.centerIn: parent
            text: qsTr("")
            color: "#6F9F00"
            font.pointSize: 14 * pt
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    RowLayout {
        id: actionButtons
        height: 44 * pt
        anchors.leftMargin: 1 * pt
        spacing: 30 * pt
        anchors.top: notifyNotesSavedArea.bottom
        anchors.topMargin: 24 * pt
        anchors.left: parent.left
        anchors.right: parent.right
        Layout.leftMargin: 26 * pt
        Layout.columnSpan: 2

        DapButton{
            id: nextButton
            heightButton:  44 * pt
            widthButton: 130 * pt
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            textButton: qsTr("Next")
            existenceImage: false
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontSizeButton: 18 * pt
            colorBackgroundButton: "#3E3853"
        }

        DapButton{
            id: copyNotesButton
            heightButton: 44 * pt
            widthButton: 130 * pt
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            checkable: true
            textButton: qsTr("Copy")
            existenceImage: false
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontSizeButton: 18 * pt
            colorBackgroundButton: copyNotesButton.checked ? "#EDEFF2" : "#3E3853"
            colorTextButton: copyNotesButton.checked ? "#3E3853" : "#FFFFFF"
            borderColorButton: "#3E3853"
            borderWidthButton: 1 * pt

            onClicked: notifyText.text = qsTr(
                           "Recovery words copied to clipboard. Keep them in a\nsafe place before proceeding to the next step.")
        }
    }
}
