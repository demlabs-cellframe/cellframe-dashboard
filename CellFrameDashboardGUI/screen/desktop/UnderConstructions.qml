import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtGraphicalEffects 1.0

Rectangle{
    color: currTheme.mainBackground
    anchors.fill: parent

    RowLayout{
        anchors.fill: parent
//        anchors.leftMargin: 278 

        Image {
            id: under_cunstruct_img
            Layout.preferredWidth: 500 
            Layout.preferredHeight: 210.8 

            Layout.alignment: Qt.AlignTop

            Layout.leftMargin: (parent.width - width) / 2 - 18 
            Layout.topMargin: (parent.height - height) / 2 - 24 

            source: "qrc:/Resources/" + pathTheme + "/Illustratons/comingsoon_illustration.png"
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 500 
            sourceSize.height: 211 

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
