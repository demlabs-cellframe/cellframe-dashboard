import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"
import "RightPanel"

DapAbstractScreen
{
    id: dapAppScreen

    anchors.fill: parent

    RowLayout
    {
        anchors
        {
            fill: parent
            margins: 24 * pt
        }

        spacing: 24 * pt

        DapRectangleLitAndShaded
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            color: currTheme.backgroundElements
            radius: currTheme.radiusRectangle
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:
                Item
                {
                    anchors.fill: parent

                    // Header
                    Item
                    {
                        id: dAppsShowHeader
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 38 * pt
                        Text
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 18 * pt
                            anchors.topMargin: 10 * pt
                            anchors.bottomMargin: 10 * pt

                            verticalAlignment: Qt.AlignVCenter
                            text: qsTr("Available apps")
                            font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                            color: currTheme.textColor
                        }
                    }

                    ListView
                    {
                        id: listViewApps
                        anchors.top: dAppsShowHeader.bottom
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        clip: true

                        delegate: delegateApp
                    }

                    Component
                    {
                        id:delegateApp
                        Column
                        {
                            width: parent.width

                            Rectangle
                            {
                                id: stockNameBlock
                                height: 30 * pt
                                width: parent.width
                                color: currTheme.backgroundMainScreen

                            }
                        }
                    }
                }
        }

        Loader {
            id: rightPanel

            asynchronous: true

            Layout.fillHeight: true
            Layout.minimumWidth: 350 * pt

            sourceComponent: defaultRightPanel

            onLoaded: {
                item.visible = true
            }

        }  //rightPanel
    }

    Component
    {
        id:defaultRightPanel
        DapAppsDefaultRightPanel
        {
            anchors.fill: parent
        }
    }

}
