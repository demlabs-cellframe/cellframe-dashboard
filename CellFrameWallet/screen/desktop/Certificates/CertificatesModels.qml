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

    property int selectedAccessKeyType: 0

    property alias createCertificateOptional: createCertificateOptional


    readonly property var signatureKeyToViewName: ({
                                               "sig_dil": qsTr("Crystal-Dilithium"),
                                               "sig_bliss": qsTr("Bliss"),
                                               "sig_picnic": qsTr("Picnic"),
                                               "sig_falcon": qsTr("Falcon")
                                           })


    readonly property var metadataKeyToViewKey: ({
                                             "a0_creation_date": qsTr("Date of creation"),
                                             "a1_expiration_date": qsTr("Expiration date"),
                                             "a2_domain": qsTr("Domain"),
                                             "a3_organization": qsTr("Organization"),
                                             "a4_fullname": qsTr("Full name"),
                                             "a5_email": qsTr("Email")
                                           })


    ListModel {
        id: accessKeyType
        property int selectedIndex: 0
        //selected certificate with private and public key
        readonly property bool bothTypeCertificateSelected: selectedIndex === 1 || (selectedIndex === 2 && selectedAccessKeyType == 1)

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
    }


    ListModel {
        id: createCertificateOptional
        //вообще эти ключи нужно вынести в общее перечисление
        //creation_date default key
        ListElement { placeHolderText: qsTr("Domain"); key: "a2_domain"; data: ""; inputFieldMask: "";  }
        ListElement { placeHolderText: qsTr("Expiration date"); key: "a1_expiration_date"; data: ""; inputFieldMask: "99.99.9999"; }
        ListElement { placeHolderText: qsTr("Organization"); key: "a3_organization"; data: ""; inputFieldMask: ""; }
        ListElement { placeHolderText: qsTr("Full name"); key: "a4_fullname"; data: ""; inputFieldMask: ""; }
        ListElement { placeHolderText: qsTr("Email"); key: "a5_email"; data: ""; inputFieldMask: ""; }

        function dataClear(){
            for (var i = 0; i < count; ++i)
                setProperty(i, "data", "")
        }

        function getDataToJson(){
            var result = { a0_creation_date: Qt.formatDateTime(new Date(), "dd.MM.yyyy") }
            for (var i = 0; i < count; ++i) {
                var item = get(i)
                if (item.data !== "") {
                    result[item.key] = item.data
                }
            }

            return result
        }
    }  //createCertificateOptional


    ListModel {
        id: certificates

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
        property int accessKeyTypeIndex: DapCertificateType.Public  //from DapCertificateType::accessKeyType

        function update() {
            print("FindDelegateModel update", findString, accessKeyTypeIndex)
            if (findString !== "") {                             //find by name and accessKeyTypeIndex
                var fstr = findString.toLocaleLowerCase()

                predicate = function (obj) {
                    return obj.completeBaseName.toLowerCase().indexOf(fstr) >= 0
                           && (obj.accessKeyType === accessKeyTypeIndex || accessKeyTypeIndex === DapCertificateType.Both)
                }
                renew()
                return;
            } else {                                            //find only by accessKeyTypeIndex
                if (accessKeyTypeIndex === DapCertificateType.Both)
                    predicate = function(obj) { return true; }
                else
                {
                    predicate = function (obj) {
                        return obj.accessKeyType === accessKeyTypeIndex
                    }
                }
                renew()
                return;
            }
        }  //update

    }  //certificatesFind



}  //
