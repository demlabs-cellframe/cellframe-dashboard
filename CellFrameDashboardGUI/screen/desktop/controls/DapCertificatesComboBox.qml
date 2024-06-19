import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"

DapCustomComboBox
{
    id: sigComboBox

    property string selectedSignature: ""
    property bool isRestoreMode: false
    property alias filteredModel: sigModel

    ListModel {id: sigModel }

    height: 42
    model: sigModel

    backgroundColorShow: currTheme.secondaryBackground
    font: mainFont.dapFont.regular16
    defaultText: qsTr("all signature")

    onCurrentIndexChanged:
    {
        selectedSignature = currentIndex < 0 ? "" : model.get(currentIndex).sign
    }

    Component.onCompleted:
    {
        for(var i=0; i<certListModel.size; ++i)
        {
            if(!isRestoreMode && i>1) break;
            sigModel.append({
                       "name": certListModel.get(i).name,
                       "sign": certListModel.get(i).sign,
                       "secondname": certListModel.get(i).secondName
                   })
        }
    }
}
