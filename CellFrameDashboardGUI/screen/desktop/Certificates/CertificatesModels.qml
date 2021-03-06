import QtQuick 2.0
import DapCertificateManager.Commands 1.0
import "parts"
import "models"



Item {
    id: root
    property alias accessKeyType: accessKeyType
    property alias certificates: certificates
    property alias certificatesFind: certificatesFind
    property alias certificateInfo: certificateInfo

    property alias signatureType: signatureType
    property alias createCertificateOptional: createCertificateOptional


    readonly property var signatureKeyToViewName: ({
                                               "sig_dil": qsTr("Crystal-Dylithium"),
                                               "sig_bliss": qsTr("Bliss"),
                                               "sig_picnic": qsTr("Picnic"),
                                               "sig_tesla": qsTr("Tesla")
                                           })


    readonly property var metadataKeyToViewKey: ({
                                               "creation_date": qsTr("Date of creation"),
                                               "expiration_date": qsTr("Expiration date"),
                                               "domain": qsTr("Domain"),
                                               "organization": qsTr("Organization"),
                                               "fullname": qsTr("Full name"),
                                               "email": qsTr("Email"),
                                               "description": qsTr("Description")
                                           })


    ListModel {
        id: accessKeyType
        property int selectedIndex: 0
        //selected certificate with private and public key
        readonly property bool bothTypeCertificateSelected: selectedIndex === 2

        ListElement { name: qsTr("Public certificates"); type: "public"; selected: true }
        ListElement { name: qsTr("Private certificates"); type: "private"; selected: false }
        ListElement { name: qsTr("Both"); type: "both"; selected: false }

        function setSelectedIndex(index){
            selectedIndex = index
            for (var i = 0; i < count; ++i)
                 setProperty(i, "selected", index === i)
        }
    }


    ListModel {
        id: certificateInfo
        //format key, keyView, value
        //keys: [certName, certSignatureType]     -  required
        //      [creation_date, domain, expiration_date, organization, fullname, email, description]   - optional

    }


    ListModel {
        id: createCertificateOptional
        //вообще эти ключи нужно вынести в общее перечисление
        //creation_date default key
        ListElement { placeHolderText: qsTr("Domain"); key: "domain"; data: ""; inputFieldMask: "";  }
        ListElement { placeHolderText: qsTr("Expiration date"); key: "expiration_date"; data: ""; inputFieldMask: "99.99.9999"; }
        ListElement { placeHolderText: qsTr("Organization"); key: "organization"; data: ""; inputFieldMask: ""; }
        ListElement { placeHolderText: qsTr("Full name"); key: "fullname"; data: ""; inputFieldMask: ""; }
        ListElement { placeHolderText: qsTr("Email"); key: "email"; data: ""; inputFieldMask: ""; }
        ListElement { placeHolderText: qsTr("Description"); key: "description"; data: ""; inputFieldMask: ""; }

        function dataClear(){
            for (var i = 0; i < count; ++i)
                setProperty(i, "data", "")
        }

        function getDataToJson(){
            var result = { creation_date: Qt.formatDateTime(new Date(), "dd.MM.yyyy") }
            for (var i = 0; i < count; ++i) {
                var item = get(i)
                if (item.data !== "") {
                    result[item.key] = item.data
                }
            }

            return result
        }
    }  //createCertificateOptional



    ListModel {        //this common model
        id: signatureType
        ListElement {  name: "Crystal-Dylithium"; signature: "sig_dil"; isRecomended: true  }
        ListElement {  name: "Bliss"; signature: "sig_bliss"; isRecomended: false  }
        ListElement {  name: "Picnic"; signature: "sig_picnic"; isRecomended: false  }
        ListElement {  name: "Tesla"; signature: "sig_tesla"; isRecomended: false  }
    }


    ListModel {
        id: certificates
        //format "fileName", "completeBaseName", "filePath", "dirType", "accessKeyType"

        property int selectedIndex: -1
        readonly property bool isSelected: selectedIndex >= 0

        function prependFromObject(obj) {
            obj.selected = false
            insert(0, obj)
        }

        function appendFromObject(obj) {
            obj.selected = false
            append(obj)
        }

        function clearSelected() {
            if (selectedIndex >= 0) {
                setProperty(selectedIndex, "selected", false)
                selectedIndex = -1
            }
        }

        function setSelectedIndex(index){
            selectedIndex = index
            for (var i = 0; i < count; ++i)
                 setProperty(i, "selected", index === i)
        }

        function parseFromCertList(certList){
            clearSelected()
            clear()
            for (var i = 0; i < certList.length; ++i) {
                certList[i].selected = false
                //utils.beatifulerJSON(certList[i], "certList[%1]".arg(i))  //for test
                append(certList[i])
            }
        }


        function removeByProperty(propertyName, value){
            for (var i = 0; i < count; ++i) {
                var item = get(i)
                if (item && typeof item[propertyName] !== "undefined")
                     if (item[propertyName] === value) {
                         remove(i)
                         return true
                     }
            }
            return false
        }

    }  //certificates


    //find over certificate model
    FindDelegateModel {
        id: certificatesFind
        model: certificates

        property string findString: ""
        property int accessKeyTypeIndex: 0            //from DapCertificateType::accessKeyType

        function update() {
            //console.info("update()", accessKeyTypeIndex, findString, items.count)
            if (findString !== "") {                             //find by name and accessKeyTypeIndex
                var fstr = findString.toLocaleLowerCase()

                predicate = function (obj) {
                    return obj.fileName.toLowerCase().indexOf(fstr) >= 0
                           && obj.accessKeyType === accessKeyTypeIndex
                }
                renew()
                return;
            } else {                                            //find only by accessKeyTypeIndex
                predicate = function (obj) {
                    return  obj.accessKeyType === accessKeyTypeIndex
                }
                renew()
                return;
            }

            //without find -> all items visible in view
            //   predicate = function(obj) { return true; }
            //   renew()

        }  //update

    }  //certificatesFind



}  //
