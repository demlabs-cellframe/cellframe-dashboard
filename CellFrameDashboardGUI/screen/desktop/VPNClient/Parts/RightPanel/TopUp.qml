import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    ListModel {
        id: limitModel
        ListElement {
            value: 123
            token: "KELT"
        }
    }

    readonly property int limitDelegateHeight: 40

    ColumnLayout
    {
        anchors.fill: parent

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.minimumHeight: 30
//            Layout.rightMargin: 10

            spacing: 10

            Button
            {
                Layout.maximumWidth: 20
                Layout.maximumHeight: 20
                Layout.topMargin: 10
//                Layout.alignment: Qt.AlignBottom
                font.pointSize: 12
                text: qsTr("X")
                onClicked: goToHomePage()
            }

            Text
            {
                Layout.fillWidth: true
                Layout.topMargin: 8
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 12
                font.bold: true
                color: "white"

                text: qsTr("Top up current usage")
            }
        }

        ScrollView
        {
            Layout.maximumWidth: parent.width
            Layout.fillHeight: true
            clip: true
/*            ScrollBar.vertical: ScrollBar {
                active: true
            }*/
            ScrollBar.horizontal: ScrollBar {
                active: false
                visible: false
            }

            ColumnLayout
            {
                anchors.fill: parent
                anchors.rightMargin: 25

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 30

                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        color: "white"
                        font.pointSize: 10
                        verticalAlignment: Qt.AlignVCenter
                        text: qsTr("Ammount")
                    }

                    color: "dark blue"
                }

                ColumnLayout
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10

                    RowLayout
                    {
                        Layout.fillWidth: true

                        TextField
                        {
                            Layout.fillWidth: true
                            Layout.maximumHeight: 30
                            horizontalAlignment: Qt.AlignRight
                            font.pointSize: 10
                            placeholderText: "0"
                        }

                        ComboBox
                        {
                            Layout.maximumWidth: 100
                            Layout.maximumHeight: 30
                            font.pointSize: 10
                            model: dapTokenModel
                        }
                    }

                    Text
                    {
                        Layout.fillWidth: true
                        color: "white"
                        font.pointSize: 10
                        text: "5m 12d 13h at the current price"
                    }
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 30

                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        color: "white"
                        font.pointSize: 10
                        verticalAlignment: Qt.AlignVCenter
                        text: qsTr("Auto balance replenishment")
                    }

                    color: "dark blue"
                }

                ColumnLayout
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10

                    CheckBox {
                        id: autoTopUpCheckBox

                        checked: true

                        indicator.anchors.left: autoTopUpCheckBox.left

                        contentItem:
                        Text {
                            anchors.left: autoTopUpCheckBox.indicator.right
                            anchors.leftMargin: 10
                            verticalAlignment: Qt.AlignVCenter
                            text: qsTr("Auto top up")
                            color: "white"
                        }

                    }

                    ListView
                    {
                        Layout.fillWidth: true
                        Layout.minimumHeight:
                            limitModel.count * limitDelegateHeight
                        clip: true
        //                ScrollBar.vertical: ScrollBar {
        //                    active: true
        //                }

                        enabled: !autoTopUpCheckBox.checked

                        model: limitModel

                        delegate:
                            RowLayout
                            {
                                width: parent.width
                                height: limitDelegateHeight

                                Text
                                {
                                    color: "white"
                                    font.pointSize: 10
                                    text: "Limit"
                                }

                                TextField
                                {
                                    Layout.fillWidth: true
                                    Layout.maximumHeight: 30
                                    horizontalAlignment: Qt.AlignRight
                                    font.pointSize: 10
                                    placeholderText: "0"
        //                            text: value
                                    onTextChanged: value = Number(text)
                                }

                                ComboBox
                                {
                                    Layout.maximumWidth: 100
                                    Layout.maximumHeight: 30
                                    font.pointSize: 10
                                    model: dapTokenModel
        //                            currentValue: token
                                    onCurrentIndexChanged: token = currentText
                                }
                            }
                    }


                    Button
                    {
                        enabled: !autoTopUpCheckBox.checked
                        Layout.fillWidth: true
                        Layout.maximumHeight: 20
                        font.pointSize: 8
                        text: qsTr("Add token for auto top up")
                        onClicked:
                        {
                            limitModel.append({ "value" : 0, "token" : "KELT" })
                        }
                    }
                }

                Button
                {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumHeight: 30
                    font.pointSize: 10
                    text: qsTr("Top up")
                }

//                Item
//                {
//                    Layout.fillHeight: true
//                }
            }
        }


    }

    color: "blue"
}
