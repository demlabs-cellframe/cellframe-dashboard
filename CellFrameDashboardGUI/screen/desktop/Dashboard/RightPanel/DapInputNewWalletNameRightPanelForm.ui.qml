import QtQuick 2.4
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
    dapHeaderData:
        Row
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.rightMargin: 16 * pt
            anchors.topMargin: 12 * pt
            anchors.bottomMargin: 12 * pt
            spacing: 12 * pt
            
            Item 
            {
                id: itemButtonClose
                data: dapButtonClose
                height: dapButtonClose.height
                width: dapButtonClose.width
            }
            
            Text 
            {
                id: textHeader
                text: qsTr("New wallet")
                font.pixelSize: 14 * pt
                color: "#3E3853"
            }
        }
    
    dapContentItemData: 
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"

            Rectangle
            {
                id: frameNameWallet
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: "#757184"
                height: 16 * pt
                Text 
                {
                    id: textNameWallet
                    color: "#ffffff"
                    text: qsTr("Name of wallet")
                    font.pixelSize: 12 * pt
                    horizontalAlignment: Text.AlignLeft
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }

            Rectangle 
            {
                id: frameInputNameWallet
                height: 68 * pt
                color: "#F8F7FA"
                anchors.top: frameNameWallet.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                Text
                {
                    id: textInputNameWallet
                    text: qsTr("Pocket of happiness")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 16 * pt
                    color: "#070023"
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    anchors.left: parent.left
                    anchors.leftMargin: 20 * pt
                }
            }
            
            Rectangle 
            {
                id: frameChooseSignatureType
                anchors.top: frameInputNameWallet.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: "#757184"
                height: 16 * pt
                Text 
                {
                    id: textChooseSignatureType
                    color: "#ffffff"
                    text: qsTr("Choose signature type")
                    font.pixelSize: 12 * pt
                    anchors.leftMargin: 16 * pt
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    font.styleName: "Normal"
                    font.family: "Roboto"
                    font.weight: Font.Normal
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

        }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
