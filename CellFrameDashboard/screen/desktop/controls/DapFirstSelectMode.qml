import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item{
    id: popup

    Rectangle {
        id: backgroundFrame
        anchors.fill: parent
        visible: opacity

        color: currTheme.mainBackground
        opacity: 0.0

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
        }

        Behavior on opacity {NumberAnimation{duration: 100}}
    }

    Rectangle{
        id: farmeActivate
        anchors.centerIn: parent
        visible: opacity
        opacity: 0

        Behavior on opacity {NumberAnimation{duration: 200}}

        width: 417
        height: notWorkTexts.visible ? 306 + notWorkTexts.height : 306
        color: currTheme.popup
        radius: currTheme.popupRadius

        MouseArea{
            anchors.fill: parent
        }

        ColumnLayout {
            id: layout
            anchors.fill: parent
            anchors.leftMargin: 32
            anchors.rightMargin: 32
            spacing: 0

            Text{
                Layout.topMargin: 32
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Select Node mode")
                font: mainFont.dapFont.bold17
                color: currTheme.lime
            }

            RowLayout{
                Layout.topMargin: 16
                Layout.alignment: Qt.AlignHCenter
                spacing: 0

                Text{

                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Local: ")
                    font: mainFont.dapFont.regular14
                    color: currTheme.lime
                }

                Text{

                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Operate node locally (may require installation)")
                    font: mainFont.dapFont.regular14
                    color: currTheme.white
                }
            }

            RowLayout{
                Layout.alignment: Qt.AlignHCenter
                spacing: 0

                Text{

                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Remote: ")
                    font: mainFont.dapFont.regular14
                    color: currTheme.lime
                }

                Text{

                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Operate node remotely")
                    font: mainFont.dapFont.regular14
                    color: currTheme.white
                }
            }


            //--------------custom switch---------------------//
            Rectangle{
                property int selectedItem: app.getNodeMode()

                id: customModeSwitch
                Layout.fillWidth: true
                Layout.topMargin: 16
                height: 32

                border.color: currTheme.input
                color: currTheme.mainBackground
                radius: height * 0.5

                Rectangle
                {
                    id: firstItem
                    x: 4
                    anchors.verticalCenter: parent.verticalCenter
                    z: 1
                    color: parent.selectedItem ? "transparent"
                                               : currTheme.mainButtonColorNormal1
                    radius: height * 0.5
                    width: parent.width / 2
                    height: parent.height - 8

                    Text
                    {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        height: firstItem.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: currTheme.white
                        font: mainFont.dapFont.medium14
                        text: qsTr("Local")
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            customModeSwitch.selectedItem = 0
                        }
                    }
                }

                Rectangle
                {
                    id: secondItem
                    x: 4 + firstItem.width
                    anchors.verticalCenter: parent.verticalCenter
                    z: 1
                    color: !parent.selectedItem ? "transparent"
                                                : currTheme.mainButtonColorNormal0
                    radius: height * 0.5
                    width: parent.width / 2 - 8
                    height: parent.height - 8

                    Text
                    {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        height: secondItem.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: currTheme.white
                        font: mainFont.dapFont.medium14
                        text: qsTr("Remote")
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            customModeSwitch.selectedItem = 1
                        }
                    }
                }
            }
            //--------------custom switch---------------------//

            Text{
                Layout.topMargin: 8
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("You can change the mode in the settings menu")
                font: mainFont.dapFont.regular14
                color: currTheme.gray
            }

            DapRectangleLitAndShaded{
                id: notWorkTexts
                visible: customModeSwitch.selectedItem
                Layout.topMargin: 8
                Layout.fillWidth: true
                color: currTheme.secondaryBackground
                radius: currTheme.frameRadius
                shadowColor: currTheme.shadowColor
                lightColor: currTheme.reflectionLight

                height: 270



                contentData:
                Text
                {
                    anchors.fill: parent
                    anchors.margins: 16
                    font: mainFont.dapFont.medium11
                    wrapMode: Text.WordWrap
                    color: currTheme.gray
                    layer.enabled: true
                    anchors.bottomMargin: OS_WIN_FLAG ? 14 : 16

                    text: {
                        qsTr("• Limited functionality of Web 3 API\n") +
                        qsTr("    - Sending conditional, JSON, and regular transactions does not work\n") +
                        qsTr("    - Creating vote and sending votes does not work\n") +
                        qsTr("    - Purchase of DEX orders does not work\n") +
                        qsTr("    - Staker and validator order creation commands do not work\n") +
                        qsTr("    - Commands for hold and take stake do not work\n") +
                        qsTr("• Limited functionality of DEX tab\n") +
                        qsTr("    - Create and purchase orders does not work\n") +
                        qsTr("• Master Node tab is not supported\n") +
                        qsTr("• Certificates tab is not supported\n") +
                        qsTr("• Console tab is not supported\n") +
                        qsTr("• Logs tab is not supported\n") +
                        qsTr("• dApps tab is not supported\n") +
                        qsTr("• Orders tab is not supported\n") +
                        qsTr("• Diagnostics tab is not supported")
                    }
                }
            }

            RowLayout
            {
                Layout.topMargin: 8
                Layout.alignment: Qt.AlignHCenter
                spacing: 0

                Image{
                    property bool checked: false

                    id: checkBoxImg
                    Layout.alignment: Qt.AlignVCenter
                    source: checked ? "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_on.png"
                                    : "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_off.png"
                    mipmap: true
                    sourceSize: Qt.size(36,36)

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            checkBoxImg.checked = !checkBoxImg.checked
                        }
                    }
                }
                Text{
                    Layout.leftMargin: -5
//                    verticalAlignment: checkBoxImg.verticalCenter
                    Layout.alignment: Qt.AlignVCenter
                    text:  qsTr("Don't ask again")
                    font: mainFont.dapFont.medium14
//                    lineHeightMode: Text.FixedHeight
//                    lineHeight: 16
                    color: currTheme.white

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            checkBoxImg.checked = !checkBoxImg.checked
                        }
                    }
                }
            }


            DapButton
            {
                id: buttonAccept
                Layout.fillWidth: true
                Layout.topMargin: 8
                Layout.bottomMargin: 32
                Layout.alignment: Qt.AlignBottom
                implicitHeight: 36
                textButton: qsTr("Accept")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                onClicked:
                {
                    if(checkBoxImg.checked)
                    {
                        app.setDontShowNodeModeFlag(true);
                    }

                    if(customModeSwitch.selectedItem === app.getNodeMode())
                    {
                        hide()
                    }
                    else
                    {
                        app.setNodeMode(customModeSwitch.selectedItem)
                        Qt.exit(RESTART_CODE)
                    }
                }
            }
        }
    }

    InnerShadow {
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
    DropShadow {
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

    function hide(){
        backgroundFrame.opacity = 0.0
        farmeActivate.opacity = 0.0
        visible = false
    }

    function show(){
        visible = true
        backgroundFrame.opacity = 0.4
        farmeActivate.opacity = 1
    }
}


