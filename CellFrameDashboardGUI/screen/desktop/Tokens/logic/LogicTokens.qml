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

    property var modelLastActions:
            [
                {
                    network: "network1",
                    status: "Local",
                    sign: "+",
                    amount: "412.8",
                    name: "token1",
                    date: "Today"
                },
                {
                    network: "network1",
                    status: "Mempool (X Confirms)",
                    sign: "+",
                    amount: "103",
                    name: "token4",
                    date: "July, 22"
                },
                {
                    network: "network3",
                    status: "Canceled",
                    sign: "-",
                    amount: "22.345",
                    name: "token1",
                    date: "December, 21"
                },
                {
                    network: "network1",
                    status: "Successful (X Confirms)",
                    sign: "+",
                    amount: "264.11",
                    name: "token4",
                    date: "December, 20"
                },
                {
                    network: "network4",
                    status: "Local",
                    sign: "-",
                    amount: "666.666",
                    name: "token1",
                    date: "November, 14"
                },
                {
                    network: "network4",
                    status: "Successful (X Confirms)",
                    sign: "-",
                    amount: "932.16",
                    name: "token1",
                    date: "November, 11"
                }
            ]
}
