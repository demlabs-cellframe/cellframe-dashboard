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

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
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
                color: currTheme.white
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Certificates")
            }
        }

        Rectangle
        {
            Layout.fillWidth: true

            height: 30
            color: currTheme.mainBackground

            RowLayout
            {
                anchors.fill: parent

                Text
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.alignment: Qt.AlignLeft
                    font: mainFont.dapFont.medium12
                    color: currTheme.white
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
                    opacity: root.infoTitleTextVisible || root.infoTitleTextVisibleClick? 1 : 0
                    color: currTheme.white

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 150
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
                    width: list.width
                    height: 50

                    Item{
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16


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
                                elide: Text.ElideMiddle
                                maximumLineCount: 1
                                color: currTheme.white

                                // property string colorProperty: (model.selected || delegateClicked._entered) ? currTheme.lime : currTheme.white

                                // onColorPropertyChanged: textTimer.start()

                                ColorAnimation on color {
                                    to: currTheme.lime
                                    duration: 150
                                    running: delegateClicked._entered || model.selected
                                }

                                ColorAnimation on color {
                                    to: currTheme.white
                                    duration: 150
                                    running: !delegateClicked._entered && !model.selected
                                }


                                DapCustomToolTip{
                                    visible: delegateClicked.containsMouse ?  certificateNameText.implicitWidth > certificateNameText.width ? true : false : false
                                    contentText: certificateNameText.text
                                    textFont: certificateNameText.font
                                    onVisibleChanged: updatePos()
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

                                opacity: model.selected || delegateClicked._entered ? 1 : 0

                                onOpacityChanged: root.infoTitleTextVisible = opacity

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 50
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
                            color: currTheme.mainBackground
                        }
                    }  //
                }
            }  //delegateComponent
        }
    }



}  //root
