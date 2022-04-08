import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

ColumnLayout
{
    id: appearanceBlock
    anchors.fill: parent
    spacing: 0
    Item
    {
        Layout.fillWidth: true
        height: 38 * pt

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 14 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Appearance")
        }
    }


    Rectangle
    {
        Layout.fillWidth: true
        height: 30 * pt
        color: currTheme.backgroundMainScreen

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 8 * pt
            anchors.bottomMargin: 8 * pt
            font: mainFont.dapFont.medium11
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Window scale")
        }
    }

    Item {
        height: 40 * pt
        Layout.fillWidth: true

        RowLayout
        {
            anchors.fill: parent
            anchors.topMargin: 13 * pt
            anchors.bottomMargin: 16 * pt
            anchors.leftMargin: 10 * pt
            anchors.rightMargin: 10 * pt

            Text
            {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredHeight: 25 * pt
                Layout.fillWidth: true
                Layout.leftMargin: 13 * pt

                font: mainFont.dapFont.regular14
                color: currTheme.textColor
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Scale value")
            }

            DapDoubleSpinBox
            {
                id: scaleSpinbox

                width: 80 * pt

                Layout.minimumHeight: 18 * pt
                Layout.maximumHeight: 18 * pt

                font: mainFont.dapFont.regular12

                realFrom: params.minWindowScale
                realTo: params.maxWindowScale
                realStep: 0.05
                decimals: 2

                //defaultValue: mainWindowScale

                value: Math.round(params.mainWindowScale*100)
            }
        }
    }

    property real newScale: 1.0

    Popup {
        id: restartDialog

        width: 300 * pt
        height: 180 * pt

        parent: Overlay.overlay
        x: (parent.width - width) * 0.5
        y: (parent.height - height) * 0.5

        modal: true

        scale: mainWindow.scale

        background: Rectangle
        {
            border.width: 0
            color: currTheme.backgroundElements
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: 10 * pt

            Text {
                Layout.fillWidth: true
                Layout.margins: 10 * pt
                font: mainFont.dapFont.regular14
                color: currTheme.textColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: qsTr("You must restart the application to apply the new scale. Do you want to restart now? ")
            }

            RowLayout
            {
                Layout.margins: 10 * pt
                Layout.bottomMargin: 20 * pt
//                Layout.leftMargin: 10 * pt
//                Layout.rightMargin: 10 * pt
                spacing: 10 * pt

                DapButton
                {
                    id: restartButton
                    Layout.fillWidth: true

                    Layout.minimumHeight: 36 * pt
                    Layout.maximumHeight: 36 * pt

                    textButton: qsTr("Restart")

                    implicitHeight: 36 * pt
                    fontButton: mainFont.dapFont.medium14
                    horizontalAligmentText: Text.AlignHCenter

                    onClicked: {
                        print("Restart")

                        restartDialog.close()

                        params.setNewScale(newScale)
                    }
                }

                DapButton
                {
                    Layout.fillWidth: true

                    Layout.minimumHeight: 36 * pt
                    Layout.maximumHeight: 36 * pt

                    textButton: qsTr("Cancel")

                    implicitHeight: 36 * pt
                    fontButton: mainFont.dapFont.medium14
                    horizontalAligmentText: Text.AlignHCenter

                    onClicked: {
                        print("Cancel")

                        restartDialog.close()
                    }
                }
            }
        }
    }

    Item {
        height: 60 * pt
        Layout.fillWidth: true

        RowLayout
        {
            anchors.fill: parent
            anchors.topMargin: 13 * pt
            anchors.bottomMargin: 16 * pt
            anchors.leftMargin: 10 * pt
            anchors.rightMargin: 10 * pt
            spacing: 10 * pt

            DapButton
            {
                id: resetScale

                focus: false

                Layout.fillWidth: true

                Layout.minimumHeight: 36 * pt
                Layout.maximumHeight: 36 * pt

                textButton: qsTr("Reset scale")

                implicitHeight: 36 * pt
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked: {
                    print("Reset scale")

                    newScale = 1.0

                    restartDialog.open()
                }
            }

            DapButton
            {
                id: applyScale

                focus: false

                Layout.fillWidth: true

                Layout.minimumHeight: 36 * pt
                Layout.maximumHeight: 36 * pt

                textButton: qsTr("Apply scale")

                implicitHeight: 36 * pt
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked: {
                    print("Apply scale")

                    newScale = scaleSpinbox.realValue

                    restartDialog.open()
                }
            }
        }

    }

    DapButton
    {
        id: resetSize

        focus: false

        Layout.fillWidth: true

        Layout.minimumHeight: 36 * pt
        Layout.maximumHeight: 36 * pt

        Layout.leftMargin: 10 * pt
        Layout.rightMargin: 10 * pt
        Layout.bottomMargin: 15 * pt

        textButton: qsTr("Reset window size")

        implicitHeight: 36 * pt
        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter

        onClicked: {
            print("Reset size")

            params.resetSize()
        }
    }


    Rectangle
    {
        Layout.fillWidth: true
        height: 30 * pt
        color: currTheme.backgroundMainScreen

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 8 * pt
            anchors.bottomMargin: 8 * pt
            font: mainFont.dapFont.medium11
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Edit menu")
        }
    }


    ListView
    {
        id:listMenuTab
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: contentHeight
        model: modelMenuTabStates
        clip: true
        delegate: delegateList
    }

    Item {
        Layout.fillHeight: true
    }

    Component{
        id:delegateList

        ColumnLayout
        {
            id:columnMenuTab
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50 * pt
            onHeightChanged: listMenuTab.contentHeight = height

            Item {
//                height: 50 * pt
                Layout.fillWidth: true
                Layout.fillHeight: true


                RowLayout
                {
                    anchors.fill: parent
                    anchors.topMargin: 13 * pt
                    anchors.bottomMargin: 16 * pt

                    Text
                    {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Layout.preferredHeight: 25 * pt
                        Layout.fillWidth: true
                        Layout.leftMargin: 13 * pt

                        font: mainFont.dapFont.regular14
                        color: currTheme.textColor
                        verticalAlignment: Qt.AlignVCenter
                        text: name
                    }
                    DapSwitch
                    {
                        id: switchTab
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 26 * pt
                        Layout.preferredWidth: 46 * pt
                        Layout.rightMargin: 19 * pt

                        backgroundColor: currTheme.backgroundMainScreen
                        borderColor: currTheme.reflectionLight
                        shadowColor: currTheme.shadowColor

                        checked: show
                        onToggled: {
                            show = checked
                            switchMenuTab(modelMenuTabStates.get(index).tag, checked)
                        }
                    }
                }
                Rectangle
                {
        //                visible: index === modelMenuTabStates.count - 1? false : true
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1 * pt
                    color: currTheme.lineSeparatorColor

                }

            }
        }
    }


/*    Repeater
    {
        model: modelMenuTabStates.count
        Item {
            height: 50 * pt
            Layout.fillWidth: true

            RowLayout
            {
                anchors.fill: parent
                anchors.topMargin: 13 * pt
                anchors.bottomMargin: 16 * pt

                Text
                {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredHeight: 25 * pt
                    Layout.fillWidth: true
                    Layout.leftMargin: 13 * pt

                    font: mainFont.dapFont.regular14
                    color: currTheme.textColor
                    verticalAlignment: Qt.AlignVCenter
                    text: modelMenuTabStates.get(index).name
                }
                DapSwitch
                {
                    id: switchTab
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.preferredHeight: 26 * pt
                    Layout.preferredWidth: 46 * pt
                    Layout.rightMargin: 19 * pt

                    backgroundColor: currTheme.backgroundMainScreen
                    borderColor: currTheme.reflectionLight
                    shadowColor: currTheme.shadowColor

                    checked: modelMenuTabStates.get(index).show
                    onToggled: {
                        modelMenuTabStates.get(index).show = checked
                        switchMenuTab(modelMenuTabStates.get(index).tag, checked)
                    }
                }
            }
            Rectangle
            {
//                visible: index === modelMenuTabStates.count - 1? false : true
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1 * pt
                color: currTheme.lineSeparatorColor

            }
        }
    }*/

//    Rectangle
//    {
//        Layout.fillWidth: true
//        height: 30 * pt
//        color: currTheme.backgroundMainScreen

//        Text
//        {
//            anchors.left: parent.left
//            anchors.leftMargin: 17 * pt
//            anchors.verticalCenter: parent.verticalCenter
//            font: mainFont.dapFont.medium11
//            color: currTheme.textColor
//            verticalAlignment: Qt.AlignVCenter
//            text: qsTr("Colours")
//        }
//    }
//    Repeater
//    {
//        model: themes

//        Item {
//            Layout.preferredHeight: 50 * pt
//            Layout.preferredWidth: 327 * pt

//            RowLayout
//            {
//                anchors.fill: parent

//                Text
//                {
//                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
//                    Layout.leftMargin: 15 * pt

//                    font: mainFont.dapFont.regular14
//                    color: currTheme.textColor
//                    verticalAlignment: Qt.AlignVCenter
//                    text: themes.get(index).name
//                }
//                Switch
//                {
//                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
//                    Layout.rightMargin: 15 * pt
//                    Layout.preferredHeight: 26*pt
//                    Layout.preferredWidth: 46 * pt
//                }
//            }
//            Rectangle
//            {
//                anchors.left: parent.left
//                anchors.right: parent.right
//                anchors.bottom: parent.bottom
//                height: 1 * pt
//                color: currTheme.lineSeparatorColor
//            }
//        }
//    }
}
