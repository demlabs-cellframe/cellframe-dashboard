import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "parts"
import "qrc:/widgets"



DapRectangleLitAndShaded {
    id: root
    property alias model: list.model
    property alias delegateComponent: delegateComponent
    signal selectedIndex(int index)
    signal infoClicked(int index)

    property string seletedCertificateAccessType: qsTr("Public")
    property bool infoTitleTextVisible: false
    property bool infoTitleTextVisibleClick: false

    color: currTheme.backgroundElements
    radius: currTheme.radiusRectangle
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
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
                color: currTheme.textColor
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Certificates")
            }
        }

        Rectangle
        {
            Layout.fillWidth: true

            height: 30
            color: currTheme.backgroundMainScreen

            RowLayout
            {
                anchors.fill: parent

                Text
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.alignment: Qt.AlignLeft
                    font: mainFont.dapFont.medium12
                    color: currTheme.textColor
                    verticalAlignment: Qt.AlignVCenter
                    text: root.seletedCertificateAccessType
                }

                Text {
                    id: infoTitleText
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 17

                    verticalAlignment: Text.AlignVCenter
                    font: mainFont.dapFont.medium12
                    text: qsTr("Info")
                    opacity: if (root.infoTitleTextVisible || root.infoTitleTextVisibleClick) return 1; else return 0
                    color: currTheme.textColor

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 100
                        }
                    }
                }
            }
        }


        ListView
        {
            id: list
            Layout.fillHeight: true
            Layout.fillWidth: true

            clip: true

            ScrollBar.vertical: ScrollBar {
                active: true
            }

            Component {
                id: delegateComponent

                Item{
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    height: 50

                    MouseArea{
                        id: delegateClicked
                        anchors.fill: parent
                        hoverEnabled: true
                        property bool _entered: false
                        onEntered:
                        {
                            _entered = true
                        }

                        onExited:
                        {
                            _entered = false
                        }
                        onClicked: {
                            root.selectedIndex(model.index)
                            models.selectedAccessKeyType = model.accessKeyType
                            root.infoTitleTextVisibleClick = true
                            if (openedRightPanelPage == "Info" && model.index !== infoIndex)
                                certificateNavigator.clearRightPanel()
                        }

                        onDoubleClicked: {
                            root.infoClicked(model.index)
                        }
                    }

                    RowLayout {
                        //this property need set from root
                        anchors.fill: parent

                        Text {
                            id: certificateNameText
                            //x: 14
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            font: mainFont.dapFont.regular16
                            text: model.completeBaseName   //model.fileName
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            color: currTheme.textColor

                            property string colorProperty: (model.selected || delegateClicked._entered) ? currTheme.hilightColorComboBox : currTheme.textColor

                            onColorPropertyChanged: textTimer.start()

                            Timer {
                                id: textTimer
                                    interval: 300
                                    onTriggered: certificateNameText.color = certificateNameText.colorProperty
                                }
                        }

                        Image{

                            Layout.alignment: Qt.AlignRight
                            Layout.rightMargin: -2

                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 30

                            width: 30
                            height: 30
                            mipmap: true
                            source: "qrc:/Resources/"+ pathTheme +"/icons/other/ic_info.png"

                            opacity: if (model.selected || delegateClicked._entered) return 1; else return 0

                            onOpacityChanged: root.infoTitleTextVisible = opacity

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 300
                                }
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: {
                                    root.infoClicked(model.index)
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: bottomLine
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.bottom
                        height: 1
                        color: currTheme.lineSeparatorColor
                    }
                }  //
            }  //delegateComponent
        }
    }



}  //root
