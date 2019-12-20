import QtQuick 2.0
import QtQuick.Window 2.0

Item {
    id: dapDevice
    
    property string device: undefined
    property int dpi: Screen.pixelDensity * 25.4
    
    function dp(x){
        if(dpi < 120) {
            device = " desktop"
            return x; // Для обычного монитора компьютера
        } else {
            device = "mobile"
            return x*(dpi/160);
        }
    }
}
