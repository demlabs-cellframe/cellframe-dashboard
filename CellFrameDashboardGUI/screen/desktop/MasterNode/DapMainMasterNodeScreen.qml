import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"
import "qrc:/"

Page
{
    id: dapMasterNodeScreen

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
        Item
        {
            anchors.fill: parent


            DapButton
            {
                id: startMasterNode
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16

                implicitHeight: 36
                textButton: qsTr("Start Master Node")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                onClicked:
                {
                    dapRightPanel.push(startMasterNodePanel)
                }
            }
        }
    }
}
