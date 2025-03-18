import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0
import QtQuick.Controls 2.2
import "qrc:/widgets"
import "../../"
import "RightPanel"

Page
{
//    property alias dapFrameApps: frameApps
    property alias dapListViewApps: listViewDapps
//    property alias dapDownloadPanel: downloadRightPanel
//    property alias dapDefaultRightPanel: defaultRightPanel

    property string currentPlugin:""
    property string currentFiltr:qsTr("Both")

    signal updateFiltr(string status)

    anchors.fill: parent
    hoverEnabled: true

    background: Rectangle{color: currTheme.mainBackground}

    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        DapDappsTopPanel{
            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            height: 32

            itemWidthEnabled: true
            itemWidth: 90

            onSelected:
            {
                currentFiltr = status
                updateFiltr(status)
            }            
        }

        ListView{
            id: listViewDapps
            Layout.topMargin: 20
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: dapAppsModel
            clip: true
            spacing: 20

            ScrollBar.vertical: ScrollBar{
                active: true
                interactive: true
            }

            delegate: delegateDapps

        }

        DapButton
        {
            visible: false //todo
            Layout.margins: 16
            Layout.fillWidth: true

            Layout.minimumHeight: 36
            Layout.maximumHeight: 36

            textButton: qsTr("Add dApp")

            implicitHeight: 36
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            FileDialog {
                id: dialogSelectPlug
                title: qsTr("Please choose a *.zip file")
                folder: "~"
                visible: false
                nameFilters: [qsTr("Zip files (*.zip)"), "All files (*.*)"]
                defaultSuffix: "qml"
                onAccepted:
                {
                    var test = decodeURIComponent(dialogSelectPlug.files[0])
                    pluginsController.addPlugin(dialogSelectPlug.files[0], 0, 0);
                }
            }
            onClicked:
            {
                dialogSelectPlug.open()
            }
        }
    }

    Component{
        id: delegateDapps

        Item{
            width: listViewDapps.width
            height: 64

            Item
            {
                anchors.fill: parent
                anchors.rightMargin: 16
                anchors.leftMargin: 16

                Rectangle
                {
                    id: itemRect
                    anchors.fill: parent
                    color: mouseArea.containsMouse ? currTheme.mainButtonColorNormal0 : currTheme.secondaryBackground
                    radius: 12
                }

                InnerShadow {
                    id: shadow
                    anchors.fill: itemRect
                    radius: 3
                    samples: 10
                    horizontalOffset: 2
                    verticalOffset: 2
                    color: currTheme.reflection
                    opacity: 0.51
                    source: itemRect
                    cached: true
                    fast: true
                }
                DropShadow {
                    anchors.fill: itemRect
                    radius: 10
                    samples: 10
                    horizontalOffset: 4
                    verticalOffset: 4
                    color: currTheme.shadowMain
                    opacity: 0.18
                    source: itemRect
                    cached: true
                    fast: true
                }

                RowLayout
                {
                    anchors.fill: parent
                    anchors.topMargin: 12
                    anchors.bottomMargin: 12
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16

                    Text {
                        Layout.fillWidth: true
                        Layout.alignment:  Qt.AlignLeft | Qt.AlignVCenter

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        text: name
                        font: mainFont.dapFont.medium16
                        color: currTheme.white
                        elide: Text.ElideRight
                    }

                    ColumnLayout{

                        spacing: 7


                        Text {
                            Layout.alignment:  Qt.AlignTop | Qt.AlignRight
                            text: status === "1" ? qsTr("Activated"):qsTr("Inactive")
                            font: mainFont.dapFont.medium14
                            color: currTheme.white
                        }

                        RowLayout{
                            Layout.alignment:  Qt.AlignBottom | Qt.AlignRight

                            spacing: 4

                            DapImageRender{
                                id:indicatorVerified
                                source: verifed === "0" ? "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/ico_noVerified.svg" :
                                                          "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/icon_verified.svg"
                            }

                            Text {
                                text: verifed === "0" ? "Unverified":"Verified"
                                font: mainFont.dapFont.regular12
                                color: verifed === "0" ? currTheme.orange : "#C4FF00"
                            }
                        }
                    }

                    DapImageRender{
                        Layout.alignment:  Qt.AlignRight | Qt.AlignVCenter
                        Layout.leftMargin: 16
                        id: aboutButton
                        source: "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/icon_rightChevron.svg"
                    }
                }

                MouseArea
                {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:
                    {
//                        tokenView.tokenIndex = index
                        selectedDapps.clear()
                        selectedDapps.append(dapAppsModel.get(index))
                        dapBottomPopup.show("qrc:/walletSkin/forms/dApps/Parts/DappsInfo.qml")
                    }
                }
            }
        }
    }

//    RowLayout
//    {
//        id:frameApps
//        anchors.fill: parent

//        spacing: 24

//        DapAppsDefaultRightPanel
//        {
//            id:defaultRightPanel
//            Layout.fillHeight: true
//            Layout.minimumWidth: 350

//            Connections
//            {
//                target:dapAppsTab
//                onUpdateButtons:
//                {
//                    defaultRightPanel.setEnableButtons()
//                }
//            }
//            onCurrentStatusSelected:
//            {
//                currentFiltr = status
//                updateFiltr(status)
//            }
//        }

//        DapAppsDownloadRightPanel
//        {
//            id:downloadRightPanel
//            Layout.fillHeight: true
//            Layout.minimumWidth: 350
//            Layout.maximumWidth: 350
//        }
//    }
}
