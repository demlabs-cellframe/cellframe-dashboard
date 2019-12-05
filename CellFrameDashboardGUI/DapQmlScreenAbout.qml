
DapUiQmlScreenAbout {
    id: dapQmlScreenAbout 
    
    textTitle.text: dapServiceController.Brand
    textAbout.text: "CellFrameDashboard"
    textVersion.text: "Version " + dapServiceController.Version
    textYear.text: new Date().toLocaleDateString(locale, "dd MMM yyyy")
}
