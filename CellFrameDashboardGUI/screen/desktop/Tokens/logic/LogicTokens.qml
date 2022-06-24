import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12

QtObject
{
    property int selectTokenIndex: -1
    property int selectNetworkIndex: -1

    function unselectToken()
    {
        selectTokenIndex = -1
        selectNetworkIndex = -1
    }

    property var tokenModel:
        [
        {
            name: "network1",
            address: "12345",
            tokens:
                [
                {
                    name: "token1",
                    balance: "100"
                },
                {
                    name: "token2",
                    balance: "100"},
                {
                    name: "token3",
                    balance: "100"
                }
            ]
        },
        {
            name: "network2",
            address: "12345",
            tokens:
                [
                {
                    name: "token1",
                    balance: "100"
                },
                {
                    name: "token2",
                    balance: "100"},
                {
                    name: "token3",
                    balance: "100"
                }
            ]
        },
        {
            name: "network3",
            address: "12345",
            tokens:
                [
                {
                    name: "token1",
                    balance: "100"
                },
                {
                    name: "token2",
                    balance: "100"},
                {
                    name: "token3",
                    balance: "100"
                }
            ]
        }
    ]
}
