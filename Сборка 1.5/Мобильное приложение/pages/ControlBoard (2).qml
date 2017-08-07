import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import "../elements"

Item {
    id: controlPanel
    property bool changeOfWidth: false
    property bool changeOfHeight: false
    property bool newOrientation: false
    property bool portraitOrientation: width < height

    onWidthChanged: {changeOfWidth = true; newOrientation = (changeOfWidth && changeOfHeight)}
    onHeightChanged: {changeOfHeight = true; newOrientation = (changeOfWidth && changeOfHeight)}

    onNewOrientationChanged: {
        if (newOrientation) {
            changeOfWidth = false;
            changeOfHeight = false;

            if (width > height) {
                // landscape
                console.log("landscape")
                portraitOrientation = false
                upOrLeft.anchors.top = controlPanel.top
                upOrLeft.width = controlPanel.width/2
                upOrLeft.height = controlPanel.height
                upOrLeft.anchors.left = controlPanel.left

                downOrRight.anchors.top = controlPanel.top
                downOrRight.width = controlPanel.width/2
                downOrRight.height = controlPanel.height
                downOrRight.anchors.right = controlPanel.right

                logoLeft.visible = false
                logoRight.visible = true

            } else {
                // portrait
                console.log("portrait")
                portraitOrientation = true
                upOrLeft.anchors.top = controlPanel.top
                upOrLeft.width = controlPanel.width
                upOrLeft.height = controlPanel.height * 0.6
                upOrLeft.anchors.centerIn = controlPanel.Center

                downOrRight.anchors.top = upOrLeft.bottom
                downOrRight.width = controlPanel.width
                downOrRight.height = controlPanel.height * 0.4
                downOrRight.anchors.centerIn = controlPanel.Center

                logoLeft.visible = true
                logoRight.visible = false
            }
        }
    }

    Connections{
        target: bluetoothManager
        onDeviceDisconnected:{signalState.source = "../image/Нет связи с роботом.png" }
    }

    Connections{
        target: bluetoothManager
        onDeviceConnected:{signalState.source = "../image/Связь с роботом Зеленый.png" }
    }

    Item {
        id: upOrLeft

        Image {
            id: logoLeft
            anchors.horizontalCenter: parent.horizontalCenter
            height: Screen.desktopAvailableHeight / 9
            fillMode: Image.PreserveAspectFit
            source: "../image/ЛогоМал.png"
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: logoLeft.bottom
            width: parent.width*0.8
            height: parent.height*0.8
            fillMode: Image.PreserveAspectFit
            source: "../image/ВидСверху.png"
            Image {
                id: batteryIcon
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: parent.paintedHeight * 0.25
                anchors.leftMargin: width * 0.05
                width: parent.height * 0.3
                fillMode: Image.PreserveAspectFit
                source: "../image/Аккумулятор5.png"
                rotation: -90
            }

            Image {
                id: signalState
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: batteryIcon.bottom
                anchors.topMargin: parent.paintedHeight * 0.1
                anchors.leftMargin: width * 0.04
                width: parent.height * 0.2
                fillMode: Image.PreserveAspectFit
                source: "../image/Связь с роботом Зеленый.png"
            }

            //            Row {
            //                anchors.horizontalCenter: parent.horizontalCenter
            //                anchors.bottom: parent.bottom
            //                spacing: 173
            ProgressBar {
                id: leftChassis
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: -height + parent.paintedWidth*0.06
                value: 0
                rotation:  -90
            }
            ProgressBar {
                id: rightChassis
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: -height + parent.paintedWidth*0.06
                value: 0
                rotation:  -90
            }
            //}
        }
    }

    Item {
        id: downOrRight

        Image {
            id: logoRight
            anchors.horizontalCenter: parent.horizontalCenter
            height: Screen.desktopAvailableWidth / 9
            fillMode: Image.PreserveAspectFit
            source: "../image/ЛогоМал.png"
        }

        Item {
            width: parent.width
            height: parent.height * 0.2
            Image {
                visible: false
                anchors.right: parent.right
                anchors.rightMargin: height / 2
                anchors.topMargin: height / 2
                height: if (portraitOrientation) Screen.desktopAvailableWidth * 0.1; else Screen.desktopAvailableHeight * 0.1;
                width: height
                fillMode: Image.PreserveAspectFit
                source: "../image/Настройки.png"
            }
        }

        Joystick {

        }
    }
}




