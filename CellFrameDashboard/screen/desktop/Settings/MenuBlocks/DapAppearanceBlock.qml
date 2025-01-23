import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"

ColumnLayout
{
    id: appearanceBlock
    anchors.fill: parent
    spacing: 0
    Item
    {
        Layout.fillWidth: true
        height: 42

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter

            font: mainFont.dapFont.bold14
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Appearance")
        }
    }

//    Rectangle
//    {
//        Layout.fillWidth: true
//        height: 30
//        color: currTheme.mainBackground

//        Text
//        {
//            anchors.fill: parent
//            anchors.leftMargin: 16
//            anchors.verticalCenter: parent.verticalCenter

//            font: mainFont.dapFont.medium12
//            color: currTheme.white
//            verticalAlignment: Qt.AlignVCenter
//            text: qsTr("GUI language")
//        }
//    }

//    Item {
//        height: 60
//        Layout.fillWidth: true
//        Layout.bottomMargin: 8

//        DapCustomComboBox
//        {
//            id: comboBoxLanguage

//            property bool init: false

//            anchors.centerIn: parent
//            anchors.fill: parent
//            anchors.margins: 10
//            anchors.bottomMargin: 0
//            anchors.topMargin: 5
//            anchors.leftMargin: 10
//            backgroundColorShow: currTheme.secondaryBackground

//            font: mainFont.dapFont.regular16

//            model: modelLanguages

////            defaultText: qsTr("Networks")

////            currentIndex: logicMainApp.currentNetwork
//            Component.onCompleted:
//            {
//                init = true

//                console.log("comboBoxLanguage onCompleted",
//                            logicMainApp.currentLanguageIndex)
//                setCurrentIndex(logicMainApp.currentLanguageIndex)
//            }

//            onCurrentIndexChanged:
//            {
//                if (init)
//                {
//                    console.log("comboBoxLanguage",
//                                currentIndex,
//                                modelLanguages.get(currentIndex).tag)

//                    translator.setLanguage(modelLanguages.get(currentIndex).tag)

//                    logicMainApp.currentLanguageIndex = currentIndex
//                    logicMainApp.currentLanguageName =
//                            modelLanguages.get(currentIndex).tag

//                    console.log("logicMainApp.currentLanguageIndex",
//                                logicMainApp.currentLanguageIndex)
//                }
//            }
//        }
//    }

    Rectangle
    {
        Layout.fillWidth: true
        height: 30
        color: currTheme.mainBackground

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter

            font: mainFont.dapFont.medium12
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Window scale")
        }
    }

    Item {
        height: 40
        Layout.fillWidth: true

        RowLayout
        {
            anchors.fill: parent
            anchors.topMargin: 18
//            anchors.bottomMargin: 16
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            Text
            {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredHeight: 25
                Layout.fillWidth: true
//                Layout.leftMargin: 13

                font: mainFont.dapFont.regular14
                color: currTheme.white
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Scale value")
            }

            DapDoubleSpinBox
            {
                id: scaleSpinbox

                Layout.alignment: Qt.AlignRight
                Layout.maximumWidth: 94
                Layout.minimumWidth: 94

                Layout.minimumHeight: 18
                Layout.maximumHeight: 18

                font: mainFont.dapFont.regular14

                realFrom: params.minWindowScale
                realTo: params.maxWindowScale
                realStep: 0.05
                decimals: 2

                maxSym: 4

                //defaultValue: mainWindowScale

                value: Math.round(params.mainWindowScale*100)
            }
        }
    }

    property real newScale: 1.0

    DapMessagePopup
    {
        id: restartPopup
        dapButtonCancel.visible: true
        onSignalAccept: accept ? params.setNewScale(newScale) : close()
    }

    Item {
        height: 26
        Layout.fillWidth: true
        Layout.topMargin: 20
        Layout.leftMargin: 16
        Layout.rightMargin: 16

        RowLayout
        {
            anchors.fill: parent
            spacing: 10

            DapButton
            {
                id: resetScale

                focus: false
                enabled: settings.window_scale !== 1
                
                Layout.fillWidth: true

                Layout.minimumHeight: 26
                Layout.maximumHeight: 26

                textButton: qsTr("Reset scale")

                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked: {
                    newScale = 1.0
                    restartPopup.smartOpen(qsTr("Confirm reboot"), qsTr("You must restart the application to apply the new scale. Do you want to restart now?"))
                }

                DapCustomToolTip{
                    contentText: qsTr("Reset scale")
                }
            }

            DapButton
            {
                id: applyScale

                focus: false

                Layout.fillWidth: true

                Layout.minimumHeight: 26
                Layout.maximumHeight: 26

                enabled: scaleSpinbox.realValue !== settings.window_scale

                textButton: qsTr("Apply scale")

                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked: {
                    newScale = scaleSpinbox.realValue
                    restartPopup.smartOpen(qsTr("Confirm reboot"), qsTr("You must restart the application to apply the new scale. Do you want to restart now?"))
                }

                DapCustomToolTip{
                    contentText: qsTr("Apply scale")
                }
            }
        }
    }

    DapButton
    {
        id: resetSize

        focus: false

        Layout.fillWidth: true

        Layout.minimumHeight: 26
        Layout.maximumHeight: 26

        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.topMargin: 10
        Layout.bottomMargin: 20

        textButton: qsTr("Reset window size")

        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter

        onClicked: {
            params.resetSize()
        }

        DapCustomToolTip{
            contentText: qsTr("Reset window size")
        }
    }


    Rectangle
    {
        Layout.fillWidth: true
        height: 30
        color: currTheme.mainBackground
        visible: app.getNodeMode() === 0

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter

            font: mainFont.dapFont.medium12
            color: currTheme.white
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
        visible: app.getNodeMode() === 0
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
            height: 50
            onHeightChanged: listMenuTab.contentHeight = height

            Item {
//                height: 50
                Layout.fillWidth: true
                Layout.fillHeight: true


                RowLayout
                {
                    anchors.fill: parent
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16

                    Text
                    {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
//                        Layout.preferredHeight: 25
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        font: mainFont.dapFont.regular14
                        color: currTheme.white
                        verticalAlignment: Qt.AlignVCenter
                        text: name
                    }
                    DapSwitch
                    {
                        id: switchTab
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 26
                        Layout.preferredWidth: 46
//                        Layout.rightMargin: 19
                        indicatorSize: 30

                        backgroundColor: currTheme.mainBackground
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
                    height: 1
                    color: currTheme.mainBackground

                }

            }
        }
    }


/*    Repeater
    {
        model: modelMenuTabStates.count
        Item {
            height: 50
            Layout.fillWidth: true

            RowLayout
            {
                anchors.fill: parent
                anchors.topMargin: 13
                anchors.bottomMargin: 16

                Text
                {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredHeight: 25
                    Layout.fillWidth: true
                    Layout.leftMargin: 13

                    font: mainFont.dapFont.regular14
                    color: currTheme.textColor
                    verticalAlignment: Qt.AlignVCenter
                    text: modelMenuTabStates.get(index).name
                }
                DapSwitch
                {
                    id: switchTab
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.preferredHeight: 26
                    Layout.preferredWidth: 46
                    Layout.rightMargin: 19

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
                height: 1
                color: currTheme.lineSeparatorColor

            }
        }
    }*/

//    Rectangle
//    {
//        Layout.fillWidth: true
//        height: 30
//        color: currTheme.backgroundMainScreen

//        Text
//        {
//            anchors.left: parent.left
//            anchors.leftMargin: 17
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
//            Layout.preferredHeight: 50
//            Layout.preferredWidth: 327

//            RowLayout
//            {
//                anchors.fill: parent

//                Text
//                {
//                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
//                    Layout.leftMargin: 15

//                    font: mainFont.dapFont.regular14
//                    color: currTheme.textColor
//                    verticalAlignment: Qt.AlignVCenter
//                    text: themes.get(index).name
//                }
//                Switch
//                {
//                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
//                    Layout.rightMargin: 15
//                    Layout.preferredHeight: 26*pt
//                    Layout.preferredWidth: 46
//                }
//            }
//            Rectangle
//            {
//                anchors.left: parent.left
//                anchors.right: parent.right
//                anchors.bottom: parent.bottom
//                height: 1
//                color: currTheme.lineSeparatorColor
//            }
//        }
//    }
}
