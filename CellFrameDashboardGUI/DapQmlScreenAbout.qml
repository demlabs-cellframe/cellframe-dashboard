import QtQuick 2.9
import QtQml 2.3
import QtQuick.Controls 2.2
import CellFrameDashboard 1.0

DapUiQmlScreenAbout {
    id: dapQmlScreenAbout 
    
    textTitle.text: dapServiceController.Brand
    textAbout.text: "CellFrameDashboard"
    textVersion.text: "Version " + dapServiceController.Version
    textYear.text: new Date().toLocaleDateString(locale, "dd MMM yyyy")
}
