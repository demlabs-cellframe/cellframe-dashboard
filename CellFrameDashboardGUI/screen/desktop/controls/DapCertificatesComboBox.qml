import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

DapCustomComboBox
{
    id: sigComboBox

    property string selectedSignature: ""
    property bool isRestoreMode: false
    property alias filteredModel: sigModel
    property int tailFiltered: 2

    ListModel {id: sigModel }

    height: 42
    model: sigModel
    maximumPopupHeight: 240

    backgroundColorShow: currTheme.secondaryBackground
    font: mainFont.dapFont.regular16
    defaultText: qsTr("all signature")

    onCurrentIndexChanged:
    {
        selectedSignature = currentIndex < 0 ? "" : model.get(currentIndex).sign
    }

    ScrollIndicator.vertical:
        ScrollIndicator { }

    Component.onCompleted:
    {
        var count = !isRestoreMode ? certificatesModels.certList.length - tailFiltered : certificatesModels.certList.length
        for(var i = 0; i < count; ++i)
        {
            sigModel.append({
                       "name": certificatesModels.certList[i].name,
                       "sign": certificatesModels.certList[i].sign,
                       "secondname": certificatesModels.certList[i].secondName
                   })
        }

        setCurrentIndex(0)
    }
}
