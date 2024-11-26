import QtQuick 2.0
import QtQml 2.12

QtObject {

    // currTheme.

    //Colors Components
    readonly property color mainBackground                : "#2E3138"
    readonly property color secondaryBackground           : "#363A42"

    readonly property color clickableObjects              : "#B4B1BD"
    readonly property color disabledClickableObjects      : "#57565C"
    readonly property color input                         : "#666E7D"
    readonly property color inputActive                   : "#AABCDE"
    readonly property color boxes                         : "#2D3037"
    readonly property color popup                         : "#373A42"
    readonly property color grid                          : "#3E4249"
    readonly property color rowHover                      : "#474B53"
    readonly property color border                        : "#2E2E32"
    readonly property color tokenChangeButton             : "#3C424C"
    readonly property color tokenChangeButtonHover        : "#6F7B8F"
    readonly property color progressBarActive             : "#A2E115"
    readonly property color loadingPanel                  : "#434852"

    readonly property color mainButtonColorNormal0        : "#A361FF"
    readonly property color mainButtonColorNormal1        : "#9580FF"
    readonly property color mainButtonColorHover0         : "#7930DE"
    readonly property color mainButtonColorHover1         : "#7F65FF"
    readonly property color secondaryButtonColor          : "#373A42"

    readonly property color darkGreen                     : "#515A44"
    readonly property color lightGreen2                   : "#788466"
    readonly property color lightGray                     : "#A2A8B2"

    //Colors
    readonly property color white                         : "#ffffff"
    readonly property color gray                          : "#B2B2B2"
    readonly property color green                         : "#84BE00"
    readonly property color greenHover                    : "#6A9900"
    readonly property color orange                        : "#FFCD44"
    readonly property color red                           : "#FF5F5F"
    readonly property color redHover                      : "#CC4C4C"
    readonly property color darkYellow                    : "#E4E111"
    readonly property color lightGreen                    : "#CAFC33"
    readonly property color coral                         : "#10E3C1"
    readonly property color neon                          : "#79FFFA"
    readonly property color lime                          : "#DBFF71"
    readonly property color buttonGray                    : "#666E7D"
    readonly property color сrayola                       : "#87DCE7"

    readonly property color buttonLightGray               : "#AABCDE"

    //Params
    readonly property real frameRadius                    : 12
    readonly property real popupRadius                    : 16
    readonly property real radiusButton                   : 30

    //Text colors
    readonly property color textColor              : "#ffffff" // OK
    readonly property color textColorGray          : "#B4B1BD" // OK
    readonly property color textColorGrayTwo       : "#B2B2B2" // OK
    readonly property color textColorGrayThree     : "#B0AEB9" // OK
    readonly property color placeHolderTextColor   : "#C7C6CE" // OK
    readonly property color textColorYellow        : "#FFCD44" // OK
    readonly property color textColorLightBlue     : "#79FFFA" // OK
    readonly property color textColorLightGreen    : "#CAFC33" // OK
    readonly property color textColorGreen         : "#84BE00" // OK //STOCK
    readonly property color textColorRed           : "#FF5F5F" // OK //STOCK
    readonly property color textColorGreenHovered  : "#73A500" // OK //STOCK
    readonly property color textColorRedHovered    : "#EA2626" // OK //STOCK
    
    //Shadows
    readonly property color shadowColor                   : "#20222A"
    readonly property color reflection                    : "#524D64"
    readonly property color reflectionLight               : "#444253"
    readonly property color networkPanelShadow            : "#08070D6C"
    readonly property real  radiusShadow                  : 8.0
    readonly property real  radiusShadowSmall             : 3.0
    readonly property real  hOffset                       : 5
    readonly property real  vOffset                       : 5
    readonly property color buttonInnerShadow             : "#E7D6FF"
    readonly property color buttonShadow                  : "#2A2C33"

    //Shadows --- no correct
    //---shadowMain---//
    readonly property color shadowMain                    : "#08070D"
    readonly property real  shadowMainVOffset             : 5
    readonly property real  shadowMainHOffset             : 5
    readonly property real  shadowMainRadius              : 10
    readonly property real  shadowMainOpacity             : 0.42
    //---navActiveLinkShadow---//
    readonly property color navActiveLinkShadow           : "#6F657D"
    readonly property real  navActiveLinkShadowVOffset    : 1
    readonly property real  navActiveLinkShadowHOffset    : 1
    readonly property real  navActiveLinkShadowRadius     : 1
    readonly property real  navActiveLinkShadowOpacity    : 0.3
    //---mainButtonShadow---//
    readonly property color mainButtonShadow              : "#0B0A0D"
    readonly property real  mainButtonShadowVOffset       : 2
    readonly property real  mainButtonShadowHOffset       : 2
    readonly property real  mainButtonShadowRadius        : 7
    readonly property real  mainButtonShadowOpacity       : 0.44
    //---innerShadow---//
    readonly property color innerShadow                   : "#1F1F1F"
    readonly property real  innerShadowVOffset            : 1
    readonly property real  innerShadowHOffset            : 1
    readonly property real  innerShadowRadius             : 10
    readonly property real  innerShadowOpacity            : 0.49
    //---blockInnerShadow---//
    readonly property color blockInnerShadow              : "#1F1F1F"
    readonly property real  blockInnerShadowVOffset       : 6
    readonly property real  blockInnerShadowHOffset       : 6
    readonly property real  blockInnerShadowRadius        : 10
    readonly property real  blockInnerShadowOpacity       : 0.72
    //---buttonsShadowDrop---//
    readonly property color buttonsShadowDrop             : "#0B0A0D"
    readonly property real  buttonsShadowDropVOffset      : 2
    readonly property real  buttonsShadowDropHOffset      : 2
    readonly property real  buttonsShadowDropRadius       : 7
    readonly property real  buttonsShadowDropOpacity      : 0.44
    //---buttonsShadowInner---//
    readonly property color buttonsShadowInner            : "#F1E7FF"
    readonly property real  buttonsShadowInnerVOffset     : 1
    readonly property real  buttonsShadowInnerHOffset     : 1
    readonly property real  buttonsShadowInnerRadius      : 4
    readonly property real  buttonsShadowInnerOpacity     : 1
    //---MainBlockShadowDrop---//
    readonly property color mainBlockShadowDrop           : "#6B667E"
    readonly property real  mainBlockShadowDropVOffset    : 1
    readonly property real  mainBlockShadowDropHOffset    : 1
    readonly property real  mainBlockShadowDropRadius     : 0
    readonly property real  mainBlockShadowDropOpacity    : 0.49
    //---MainBlockShadowInner---//
    readonly property color mainBlockShadowInner          : "#08070D"
    readonly property real  mainBlockShadowInnerVOffset   : 3
    readonly property real  mainBlockShadowInnerHOffset   : 3
    readonly property real  mainBlockShadowInnerRadius    : 5
    readonly property real  mainBlockShadowInnerOpacity   : 0.25
    //---modalShadow---//
    readonly property color modalShadow                   : "#08070D"
    readonly property real  modalShadowVOffset            : 5
    readonly property real  modalShadowHOffset            : 5
    readonly property real  modalShadowRadius             : 10
    readonly property real  modalShadowOpacity            : 0.42
    //---notClickableObject---//
    readonly property color notClickableObject            : "#08070D"
    readonly property real  notClickableObjectVOffset     : 5
    readonly property real  notClickableObjectHOffset     : 5
    readonly property real  notClickableObjectRadius      : 10
    readonly property real  notClickableObjectOpacity     : 0.42
    //---comboBoxShadow---//
    readonly property color comboBoxShadow                : "#08070D"
    readonly property real  comboBoxShadowVOffset         : 5
    readonly property real  comboBoxShadowHOffset         : 5
    readonly property real  comboBoxShadowRadius          : 10
    readonly property real  comboBoxShadowOpacity         : 0.42
}
