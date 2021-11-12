import QtQuick 2.7

Item {
    id: control

    property string caption
    property Component headerComponent

    signal pushPageRequest(var page)
    signal popPageRequest
    signal closeRightPanelRequest
}
