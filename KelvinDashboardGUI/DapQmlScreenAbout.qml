import QtQuick 2.9
import QtQml 2.11
import QtQuick.Controls 2.2
import KelvinDashboard 1.0

DapUiQmlScreenAbout {
    id: dapQmlScreenAbout 
    
    textTitle.text: DapServiceController.Brand
    textAbout.text: "KelvinDashboard"
    textVersion.text: "Version " + DapServiceController.Version
    textYear.text: new Date().toLocaleDateString(locale, "dd MMM yyyy")
}
