import QtQuick 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
    dapButtonClose.normalImageButton: "qrc:/res/icons/back_icon.png"
    dapButtonClose.hoverImageButton: "qrc:/res/icons/back_icon_hover.png"
    
    dapHeaderData:
        Rectangle
        {
            id: frameHeaderItem
            anchors.fill: parent
            height: parent.height
            color: "transparent"
            Rectangle
            {
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 12 * pt
                color: "transparent"
                
                Item 
                {
                    id: itemButtonBack
                    data: dapButtonClose
                    height: dapButtonClose.height
                    width: dapButtonClose.width
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                
                Text 
                {
                    id: textHeader
                    text: qsTr("New wallet")
                    font.pixelSize: 14 * pt
                    color: "#3E3853"
                    anchors.left: itemButtonBack.right
                    anchors.leftMargin: 12 * pt
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
                
            Rectangle
            {
                id: bottomBorder
                height: 1 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "#757184"
            }
        }
    
    dapContentItemData: 
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"

            Rectangle
            {
                id: frameMethod
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottomMargin: 8 * pt
                color: "#757184"
                height: 30 * pt
                Text 
                {
                    id: textMethod
                    color: "#ffffff"
                    text: qsTr("24 words")
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
            
            Text 
            {
                id: textTopMessage
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: frameMethod.bottom
                anchors.topMargin: 24 * pt
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                anchors.bottomMargin: 24 * pt
                text: qsTr("Keep these words in a safe place. They will be\nrequired to restore your wallet in case of loss of\naccess to it")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#FF0300"
                font 
                {
                    family: "Roboto"
                    styleName: "Normal"
                    weight: Font.Normal
                    pixelSize: 14 * pt
                }
            }
            
            Rectangle 
            {
                id: frameRecoveryWords
                anchors.top: textTopMessage.bottom
                anchors.topMargin: 24 * pt
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                color: "transparent"
                height: 250 * pt
        
                ListModel 
                {
                    id: modelRecoveryWords
                    ListElement 
                    {
                        word: "Word1"
                    }
                    ListElement 
                    {
                        word: "Word2"
                    }
                    ListElement 
                    {
                        word: "Word3"
                    }
                    ListElement 
                    {
                        word: "Word4"
                    }
                    ListElement 
                    {
                        word: "Word5"
                    }
                    ListElement 
                    {
                        word: "Word6"
                    }
                    ListElement 
                    {
                        word: "Word7"
                    }
                    ListElement 
                    {
                        word: "Word8"
                    }
                    ListElement 
                    {
                        word: "Word9"
                    }
                    ListElement 
                    {
                        word: "Word10"
                    }
                    ListElement 
                    {
                        word: "Word11"
                    }
                    ListElement 
                    {
                        word: "Word12"
                    }
                }
        
                RowLayout 
                {
                    id: rowListView
                    spacing: 60 * pt
                    anchors.fill: parent
                    height: frameRecoveryWords.height
                    ListView 
                    {
                        id: firstListViewRecoveryWords
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        height: frameRecoveryWords.height
                        width: 50 * pt
                        model: modelRecoveryWords
                        delegate: 
                            Text 
                            {
                                text: word
                                color: "#070023"
                                anchors.horizontalCenter: parent.horizontalCenter
                                font 
                                {
                                    pixelSize: 16 * pt
                                    family: "Roboto"
                                    styleName: "Normal"
                                    weight: Font.Normal
                                }
                            }
                    }
        
                    ListView 
                    {
                        id: lastListViewRecoveryWords
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        height: frameRecoveryWords.height
                        width: 50 * pt
                        model: modelRecoveryWords
                        delegate: 
                            Text 
                            {
                                text: word
                                color: "#070023"
                                anchors.horizontalCenter: parent.horizontalCenter
                                font 
                                {
                                    pixelSize: 16 * pt
                                    family: "Roboto"
                                    styleName: "Normal"
                                    weight: Font.Normal
                                }
                            }
                    }
                }
            }
        
            Text 
            {
                id: textBottomMessage
                anchors.top: frameRecoveryWords.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 24 * pt
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                color: "#6F9F00"
                font.pixelSize: 14 * pt
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            RowLayout 
            {
                id: rowButtons
                height: 44 * pt
                anchors.top: textBottomMessage.bottom
                anchors.topMargin: 24 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                Layout.columnSpan: 2
        
                DapButton
                {
                    id: nextButton
                    heightButton:  44 * pt
                    widthButton: 130 * pt
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    textButton: qsTr("Next")
                    existenceImage: false
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton.pixelSize: 18 * pt
                    colorBackgroundButton: "#3E3853"
                }
        
                DapButton
                {
                    id: copyButton
                    heightButton: 44 * pt
                    widthButton: 130 * pt
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    checkable: true
                    textButton: qsTr("Copy")
                    existenceImage: false
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton.pixelSize: 18 * pt
                    colorBackgroundButton: copyButton.checked ? "#EDEFF2" : "#3E3853"
                    colorTextButton: copyButton.checked ? "#3E3853" : "#FFFFFF"
        
                    onClicked: textBottomMessage.text = qsTr("Recovery words copied to clipboard. Keep them in a\nsafe place before proceeding to the next step.")
                }
            }
            
            Rectangle 
            {
                id: frameMethodData
                height: 124 * pt
                color: "transparent"
                anchors.top: rowButtons.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
            }
        }
}
