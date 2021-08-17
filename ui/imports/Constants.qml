pragma Singleton

import QtQuick 2.13

QtObject {
    readonly property int maxNbDaysToFetch: 30
    readonly property int fetchRangeLast24Hours: 86400
    readonly property int fetchRangeLast2Days: 172800
    readonly property int fetchRangeLast3Days: 259200
    readonly property int fetchRangeLast7Days: 604800

    readonly property string lightThemeName: "light"
    readonly property string darkThemeName: "dark"

    readonly property string zeroAddress: "0x0000000000000000000000000000000000000000"

    readonly property string networkMainnet: "mainnet_rpc"
    readonly property string networkPOA: "poa_rpc"
    readonly property string networkXDai: "xdai_rpc"
    readonly property string networkGoerli: "goerli_rpc"
    readonly property string networkRinkeby: "rinkeby_rpc"
    readonly property string networkRopsten: "testnet_rpc"

    readonly property string eth_prod: "eth.prod"
    readonly property string eth_staging: "eth.staging"
    readonly property string eth_test: "eth.test"
    readonly property string waku_prod: "wakuv2.prod"
    readonly property string waku_test: "wakuv2.test"
}
