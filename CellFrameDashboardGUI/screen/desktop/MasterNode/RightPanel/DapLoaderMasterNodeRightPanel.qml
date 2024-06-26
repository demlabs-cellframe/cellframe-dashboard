import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.4
import "qrc:/widgets"

DapRectangleLitAndShaded {

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 34
        anchors.rightMargin: 34
        spacing: 12

        Item{
            Layout.fillHeight: true
        }

        Image {
            id: loader
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
//            Layout.topMargin: 140
            Layout.fillWidth: true
            sourceSize: Qt.size(46,46)
            smooth: true
            antialiasing: true
            fillMode: Image.PreserveAspectFit

            source: "qrc:/Resources/"+ pathTheme +"/icons/other/loader.svg"

            RotationAnimator
            {
                id: animatorIndicator
                target: loader
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                running: true
            }
        }

        Text
        {
            id: stageText
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            color: currTheme.white
            font: mainFont.dapFont.medium14
            text: registrationStagesText[nodeMasterModule.creationStage ]
        }

        Item{
            Layout.fillHeight: true
        }
    }
}
