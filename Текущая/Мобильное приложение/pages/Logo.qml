import QtQuick 2.7
import QtQuick.Window 2.2

Item {
    anchors.fill: parent
    Image {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
        width: Screen.desktopAvailableWidth * 0.6
        height: width
        source: "../image/ЛогоЭмблема.png"
        PropertyAnimation on opacity {from: 0; to: 1; duration: 750}
    }
}

