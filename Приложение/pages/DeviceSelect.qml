import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtBluetooth 5.7
import QtQuick.Window 2.2


Item {
    visible: true
    id: top

    BluetoothDiscoveryModel{
        id: btModel
        running: true
        discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
        onDeviceDiscovered: console.log("New device: " + device)
        onErrorChanged: {
            switch (btModel.error) {
            case BluetoothDiscoveryModel.PoweredOffError:
                console.log("Error: Bluetooth device not turned on");
                info.text = "Включите Bluetooth";
                break;
            case BluetoothDiscoveryModel.InputOutputError:
                console.log("Error: Bluetooth I/O Error"); break;
            case BluetoothDiscoveryModel.InvalidBluetoothAdapterError:
                console.log("Error: Invalid Bluetooth Adapter Error"); break;
            case BluetoothDiscoveryModel.NoError:
                break;
            default:
                console.log("Error: Unknown Error"); break;
            }
        }
    }

    Image {
        id: logo
        anchors.horizontalCenter: parent.horizontalCenter
        height: Screen.desktopAvailableHeight/9
        fillMode: Image.PreserveAspectFit
        source: "../image/ЛогоМал.png"
    }

    Text {
        id: textSelectDevice
        text: "Выберите устройство:"
        anchors.top: logo.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
        color: "gray"
    }

    ListView {
        id: mainList
        anchors.top: textSelectDevice.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: top.bottom
        width: parent.width
        height: parent.height
        clip: true
        model: btModel
        delegate: ItemDelegate {
            width: parent.width
            highlighted: ListView.isCurrentItem
            onClicked: {
                if (ListView.currentIndex != index) {
                    ListView.currentIndex = index
                    btModel.running = false
                    bluetoothManager.connectToDevice(model.remoteAddress)
                }
            }
            Text {
                text: deviceName
                font.pointSize: 16
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "gray"
            }
        }

    }
    Button {
        anchors.bottom: top.bottom
        width: parent.width
        enabled: ! btModel.running
        onClicked: btModel.running = true
        text: qsTr("Обновить")
    }

}
