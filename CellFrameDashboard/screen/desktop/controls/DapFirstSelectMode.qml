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

        width: 470
        height: 400
        color: currTheme.popup
        radius: currTheme.popupRadius

        MouseArea{
            anchors.fill: parent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 17
            anchors.bottomMargin: 24
            spacing: 0

            Text{
                Layout.fillWidth: true
                Layout.leftMargin: 50
                Layout.rightMargin: 50
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Select Node Mode")
                font: mainFont.dapFont.bold17
                lineHeightMode: Text.FixedHeight
                lineHeight: 17.5
                color: currTheme.white
                elide: Text.ElideMiddle
            }

            Text{
                Layout.topMargin: 5
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Select the mode of connection to the node.\nRemote - mode for working with a remote node\nLocal - mode for working with local node (may require installation).")
                font: mainFont.dapFont.regular14
                lineHeightMode: Text.FixedHeight
                lineHeight: 16
                color: currTheme.white
            }


            RowLayout
            {
                property int selected: app.getNodeMode()

                id: modeLayout
                Layout.topMargin: 16
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.alignment: Qt.AlignHCenter
                spacing: 32

                Rectangle{
                    width: 100
                    height: width

                    border.width: 1
                    border.color: modeLayout.selected   ||
                                  areaRemote.containsMouse ? currTheme.border
                                                          : currTheme.mainBackground
                    color: modeLayout.selected   ||
                           areaRemote.containsMouse ? currTheme.secondaryBackground
                                                   : currTheme.mainBackground
                    radius: 8

                    Text{
                        anchors.centerIn: parent
                        text: qsTr("Remote")
                        font: mainFont.dapFont.regular14
                        lineHeightMode: Text.FixedHeight
                        lineHeight: 16
                        color: currTheme.white
                    }

                    MouseArea{
                        id: areaRemote
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            modeLayout.selected = 1
                        }
                    }
                }

                Rectangle
                {
                    width: 100
                    height: width

                    border.width: 1
                    border.color: !modeLayout.selected   ||
                                  areaLocal.containsMouse ? currTheme.border
                                                          : currTheme.mainBackground
                    color: !modeLayout.selected   ||
                           areaLocal.containsMouse ? currTheme.secondaryBackground
                                                   : currTheme.mainBackground
                    radius: 8

                    Text{
                        anchors.centerIn: parent
                        text: qsTr("Local")
                        font: mainFont.dapFont.regular14
                        lineHeightMode: Text.FixedHeight
                        lineHeight: 16
                        color: currTheme.white
                    }

                    MouseArea{
                        id: areaLocal
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            modeLayout.selected = 0
                        }
                    }
                }
            }

            Text{
                Layout.topMargin: 5
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("*You can change the mode in the settings menu")
                font: mainFont.dapFont.regular12
                lineHeightMode: Text.FixedHeight
                lineHeight: 16
                color: currTheme.white
            }


            RowLayout
            {
                Layout.topMargin: 16
                Layout.alignment: Qt.AlignHCenter
                spacing: 0

                Image{
                    property bool checked: false

                    id: checkBoxImg
                    Layout.alignment: Qt.AlignVCenter
                    source: checked ? "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_on.png"
                                    : "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_off.png"
                    mipmap: true
                    sourceSize: Qt.size(40,40)

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
                Layout.leftMargin: 24
                Layout.rightMargin: 24
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

                    if(modeLayout.selected === app.getNodeMode())
                    {
                        hide()
                    }
                    else
                    {
                        app.setNodeMode(modeLayout.selected)
                        hide()
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


