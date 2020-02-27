import QtQuick 2.0
import "qrc:/"

Item
{
    ///@details dapMainFontTheme ID of item with all project fonts
    property alias dapMainFontTheme: dapFontsObjects

    //Add Font Loader
    DapFont
    {
        id: dapFonts
        dapFontPath: "qrc:/res/fonts/"
        dapFontNames: ["roboto_black.ttf",
                    "roboto_light.ttf",
                    "roboto_medium.ttf",
                    "roboto_regular.ttf",
                    "roboto_thin.ttf"]
    }
    //Create fonts
    QtObject
    {

        id: dapFontsObjects

        ///@details dapFontRobotoBlack14 Font of Roboto font family (black, 14pt)
        property font dapFontRobotoBlack14:                 Qt.font({
                                                                        family: dapFonts.dapProjectFonts[0].name,
                                                                        bold: false,
                                                                        italic: false,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoBlackCustom Font of Roboto font family (black, without parameters)
        property font dapFontRobotoBlackCustom:             Qt.font({   family: dapFonts.dapProjectFonts[0].name })

        ///@details dapFontRobotoBlackItalic14 Font of Roboto font family (black-italic, 14pt)
        property font dapFontRobotoBlackItalic14:           Qt.font({
                                                                        family: dapFonts.dapProjectFonts[0].name,
                                                                        bold: false,
                                                                        italic: true,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoBlackItalicCustom Font of Roboto font family (black-italic, without parameters)
        property font dapFontRobotoBlackItalicCustom:       Qt.font({
                                                                        family: dapFonts.dapProjectFonts[0].name,
                                                                        italic: true
                                                                    })

        ///@details dapFontRobotoBold14 Font of Roboto font family (bold, 14pt)
        property font dapFontRobotoBold14:                  Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: true,
                                                                        italic: false,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoBoldCustom Font of Roboto font family (bold, without parameters)
        property font dapFontRobotoBoldCustom:              Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: true
                                                                    })

        ///@detalis dapFontRobotoBoldItalic14 Font of Roboto font family (bold-italic, 14pt)
        property font dapFontRobotoBoldItalic14:            Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: true,
                                                                        italic: true,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoBoldItalicCustom Font of Roboto font family (bold-italic, without parameters)
        property font dapFontRobotoBoldItalicCustom:        Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: true,
                                                                        italic: true
                                                                    })

        ///@details dapFontRobotoLight14 Font of Roboto font family (light, 14pt)
        property font dapFontRobotoLight14:                 Qt.font({
                                                                        family: dapFonts.dapProjectFonts[1].name,
                                                                        bold: false,
                                                                        italic: false,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoLightCustom Font of Roboto font family (light, without parameters)
        property font dapFontRobotoLightCustom:             Qt.font({   family: dapFonts.dapProjectFonts[1].name })

        ///@details dapFontRobotoLightItalic14 Font of Roboto font family (light-italic, 14pt)
        property font dapFontRobotoLightItalic14:           Qt.font({
                                                                        family: dapFonts.dapProjectFonts[1].name,
                                                                        bold: false,
                                                                        italic: true,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoLightItalicCustom Font of Roboto font family (light-italic, without parameters)
        property font dapFontRobotoLightItalicCustom:       Qt.font({
                                                                        family: dapFonts.dapProjectFonts[1].name,
                                                                        italic: true
                                                                    })
        ///@details dapFontRobotoMedium14 Font of Roboto font family (medium, 14pt)
        property font dapFontRobotoMedium14:                Qt.font({
                                                                        family: dapFonts.dapProjectFonts[2].name,
                                                                        bold: false,
                                                                        italic: false,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoMediumCustom Font of Roboto font family (medium, without parameters)
        property font dapFontRobotoMediumCustom:            Qt.font({   family: dapFonts.dapProjectFonts[2].name })

        ///@details dapFontRobotoMediumItalic14 Font of Roboto font family (medium-italic, 14pt)
        property font dapFontRobotoMediumItalic14:          Qt.font({
                                                                        family: dapFonts.dapProjectFonts[2].name,
                                                                        bold: false,
                                                                        italic: true,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoMediumItalicCustom Font of Roboto font family (medium-italic, without parameters)
        property font dapFontRobotoMediumItalicCustom:      Qt.font({
                                                                        family: dapFonts.dapProjectFonts[2].name,
                                                                        italic: true
                                                                    })

        ///@details dapFontRobotoItalic14 Font of Roboto font family (italic, 14pt)
        property font dapFontRobotoItalic14:                Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: false,
                                                                        italic: true,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoItalicCustom Font of Roboto font family (italic, without parameters)
        property font dapFontRobotoItalicCustom:            Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        italic: true
                                                                    })

        ///@details dapFontRobotoRegular14 Font of Roboto font family (regular, 14pt)
        property font dapFontRobotoRegular14:               Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: false,
                                                                        italic: false,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoRegular12 Font of Roboto font family (regular, 12pt)
        property font dapFontRobotoRegular12:               Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: false,
                                                                        italic: false,
                                                                        pixelSize: 12
                                                                    })

        ///@details dapFontRobotoRegular16 Font of Roboto font family (regular, 16pt)
        property font dapFontRobotoRegular16:               Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: false,
                                                                        italic: false,
                                                                        pixelSize: 16
                                                                    })

        ///@details dapFontRobotoRegular18 Font of Roboto font family (regular, 18pt)
        property font dapFontRobotoRegular18:               Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: false,
                                                                        italic: false,
                                                                        pixelSize: 18
                                                                    })

        ///@details dapFontRobotoRegularCustom Font of Roboto font family (regular, without parameters)
        property font dapFontRobotoRegularCustom:           Qt.font({ family: dapFonts.dapProjectFonts[3].name })

        ///@details dapFontRobotoThin14 Font of Roboto font family (thin, 14pt)
        property font dapFontRobotoThin14:                  Qt.font({
                                                                        family: dapFonts.dapProjectFonts[4].name,
                                                                        bold: false,
                                                                        italic: false,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoThinCustom Font of Roboto font family (thin, without parameters)
        property font dapFontRobotoThinCustom:              Qt.font({   family: dapFonts.dapProjectFonts[4].name })

        ///@details dapFontRobotoThinItalic14 Font of Roboto font family (thin-italic, 14pt)
        property font dapFontRobotoThinItalic14:            Qt.font({
                                                                        family: dapFonts.dapProjectFonts[4].name,
                                                                        bold: false,
                                                                        italic: true,
                                                                        pixelSize: 14
                                                                    })

        ///@details dapFontRobotoThinItalicCustom Font of Roboto font family (thin-italic, without parameters)
        property font dapFontRobotoThinItalicCustom:        Qt.font({
                                                                        family: dapFonts.dapProjectFonts[4].name,
                                                                        italic: true
                                                                    })

        ///@details dapFontRobotoRegular11 Font of Roboto font family (regular, 11pt)
        property font dapFontRobotoRegular11:               Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: false,
                                                                        italic: false,
                                                                        pixelSize: 11
                                                                    })

        ///@details dapFontRobotoRegular10 Font of Roboto font family (regular, 10pt)
        property font dapFontRobotoRegular10:               Qt.font({
                                                                        family: dapFonts.dapProjectFonts[3].name,
                                                                        bold: false,
                                                                        italic: false,
                                                                        pixelSize: 10
                                                                    })
    }
}
