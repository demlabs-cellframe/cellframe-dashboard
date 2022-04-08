import QtQuick 2.7

Item {
    id: control

    property string name

    property int horizontalAlignment: Qt.AlignLeft
    property Item contentItem

    property real leftMargin: 36 * pt
    property real topMargin: 22 * pt
    property real rightMargin: 36 * pt
    property real bottomMargin: 22 * pt

    implicitWidth: Math.max(contentItem.implicitWidth + leftMargin + rightMargin, textName.implicitWidth + textName.x)
    implicitHeight: nameBackground.height + contentItem.implicitHeight + topMargin + bottomMargin

    onContentItemChanged: {
        contentItem.parent = control;
        contentItem.width = Qt.binding(function(){ return Math.min(contentItem.implicitWidth, control.width - control.leftMargin - control.rightMargin) });
        contentItem.height = Qt.binding(function(){ return Math.min(contentItem.implicitHeight, control.height - control.topMargin - control.bottomMargin) });
        contentItem.x = Qt.binding(function(){
            if (control.horizontalAlignment & Qt.AlignHCenter) {
                return control.leftMargin + (control.width - control.leftMargin - control.rightMargin - contentItem.width) / 2;
            } else /*if (control.horizontalAlignment & Qt.AlignLeft)*/ {
                return control.leftMargin;
            }
        });
        contentItem.y = Qt.binding(function(){
            return nameBackground.height + control.topMargin + (control.height - nameBackground.height - control.topMargin - control.bottomMargin - contentItem.height) / 2;
        });
    }

    Rectangle {
        id: nameBackground

        width: parent.width
        height: 30 * pt

        color: "#3E3853"

        Text {
            id: textName

            x: 15 * pt
            anchors.verticalCenter: parent.verticalCenter
            font:  mainFont.dapFont.medium12
            elide: Text.ElideRight
            color: "#FFFFFF"
            text: control.name
        }
    }

}
