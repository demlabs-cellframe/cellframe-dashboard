import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

Item {

}

/*DapRectangleLitAndShaded
{
    id:control

    property alias dapLastActionsView: lastActionsView

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
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16
                font: mainFont.dapFont.bold14
                color: currTheme.white
                text: qsTr("Last actions")
            }
        }

        ListView
        {
            id: lastActionsView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: modelLastActions
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: delegateSection

            delegate: Item {
                width: lastActionsView.width

                height: 50 

                RowLayout
                {
                    anchors.fill: parent
                    anchors.rightMargin: 16
                    anchors.leftMargin: 16
                    spacing: 12

                    ColumnLayout
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 3

                        Text
                        {
                            Layout.fillWidth: true
                            text: network
                            color: currTheme.white
                            font: mainFont.dapFont.regular11
                            elide: Text.ElideRight
                        }

                        Text
                        {
                            Layout.fillWidth: true
//                            text: tx_status === "ACCEPTED" ? status : "Declined"
                            text: getStatusName(tx_status, status)
                            color: currTheme.gray
                            font: mainFont.dapFont.regular12
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 0

                        DapBigText
                        {
                            property string sign: (status === "Sent") ? "- " : "+ "
//                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            height: 20
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: sign + value + " " + token
                            textFont: mainFont.dapFont.regular14

                            width: 160
                        }
                        DapBigText
                        {
//                            visible: fee !== "0.0"
//                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            height: 15
                            textColor: currTheme.gray
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: qsTr("fee: ") + fee + " " + token
                            textFont: mainFont.dapFont.regular12

                            width: 160
                        }
                    }

                    DapToolTipInfo{
                        property string normalIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser.svg"
                        property string hoverIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser_hover.svg"
                        property string disabledIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser_disabled.svg"
                        id: explorerIcon
                        Layout.preferredHeight: 18
                        Layout.preferredWidth: 18
                        contentText: qsTr("Explorer")

                        toolTip.width: text.implicitWidth + 16
                        toolTip.x: -toolTip.width/2 + 8

                        enabled: tx_status === "DECLINED" ? false :
                                    network === "subzero" || network === "Backbone" ||
                                    network === "mileena" || network === "kelvpn-minkowski"  ?
                                    true : false

                        indicatorSrcNormal: tx_status === "DECLINED" ? disabledIcon :
                                                network === "subzero" || network === "Backbone" ||
                                                network === "mileena" || network === "kelvpn-minkowski"  ?
                                                normalIcon : disabledIcon

                        indicatorSrcHover: tx_status === "DECLINED" ? disabledIcon :
                                                                      network === "subzero" || network === "Backbone" ||
                                                                      network === "mileena" || network === "kelvpn-minkowski"  ?
                                                                      hoverIcon : disabledIcon

                        onClicked: Qt.openUrlExternally("https://explorer.cellframe.net/transaction/" + network + "/" + tx_hash)

                    }

//                    Image
//                    {
//                        Layout.preferredHeight: 20
//                        Layout.preferredWidth: 20
//    //                    innerWidth: 20
//    //                    innerHeight: 20

//                        visible: network === "subzero" || network === "Backbone" || network === "mileena" || network === "kelvpn-minkowski"  ? true : false

//                        source: mouseArea.containsMouse? "qrc:/Resources/BlackTheme/icons/other/browser_hover.svg" : "qrc:/Resources/BlackTheme/icons/other/browser.svg"

//                        MouseArea
//                        {
//                            id: mouseArea
//                            anchors.fill: parent
//                            hoverEnabled: true
//                            onClicked: Qt.openUrlExternally("https://explorer.cellframe.net/transaction/" + network + "/" + tx_hash)
//                        }
//                    }
                }

                Rectangle
                {
                    width: parent.width
                    height: 1 
                    color: currTheme.mainBackground
                    anchors.bottom: parent.bottom
                }
            }
        }
    }

    function getStatusName(tx_status, status)
    {
//        return "TEST"
        var st = "TST"

        if (tx_status !== "ACCEPTED")
            st = qsTr("Declined")
        if (status === "Sent")
            st = qsTr("Sent")
        if (status === "Error")
            st = qsTr("Error")
        if (status === "Declined")
            st = qsTr("Declined")
        if (status === "Received")
            st = qsTr("Received")

        console.log("getStatusName", tx_status, status, st)
        return st
    }
}*/
