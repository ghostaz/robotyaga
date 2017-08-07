import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2

Item {
    id: mainWindow
    visible: true

    Connections{
        target: bluetoothManager
        onDeviceConnected:{loader.setSource("pages/ControlBoard.qml")}
    }

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered:
        {
            loader.setSource("pages/DeviceSelect.qml")
            stop()
        }
    }

    Loader{
        id: loader
        anchors.fill: parent
        source: "pages/Logo.qml"
    }
}
