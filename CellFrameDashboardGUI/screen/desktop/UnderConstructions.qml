import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtGraphicalEffects 1.0

Rectangle{
    color: currTheme.backgroundMainScreen
    anchors.fill: parent

    RowLayout{
        anchors.fill: parent
//        anchors.leftMargin: 278 * pt

        Image {
            id: under_cunstruct_img
            Layout.preferredWidth: 500 * pt
            Layout.preferredHeight: 210.8 * pt

            Layout.alignment: Qt.AlignTop

            Layout.leftMargin: (parent.width - width) / 2 - 18 * pt
            Layout.topMargin: (parent.height - height) / 2 - 24 * pt

            source: "qrc:/Resources/" + pathTheme + "/Illustratons/comingsoon_illustration.png"
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 500 * pt
            sourceSize.height: 211 * pt

            ColorOverlay {
                id: overlay
                anchors.fill: under_cunstruct_img
                source: under_cunstruct_img
                color: "#FFFF0000"
                visible: false
              }
        }

    }
}
