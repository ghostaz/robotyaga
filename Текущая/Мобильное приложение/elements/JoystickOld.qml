import QtQuick 2.0

Rectangle {
    id: joystick

    property int centerX: width / 2
    property int centerY: height / 2

    property int leftChassisSpeed: 0
    property int rightChassisSpeed: 0
    property bool sync: false

    width: parent.height * 0.25
    height: parent.height * 0.25;
    anchors.bottom: parent.bottom
    anchors.margins: 30
    radius: width * 1.2
    color: "#1c56f3"
    border.color: "black"
    border.width: 2
    visible: true
    anchors.horizontalCenter: parent.horizontalCenter

    Rectangle{
        id: finger
        width: parent.height * 0.4
        height: parent.height * 0.4;
        radius: parent.height * 0.4
        color: "#1c56f3"
        border.color: "black"
        border.width: 2
        anchors.centerIn: parent.Center
        x: parent.centerX - width / 2
        y: parent.centerY - height / 2

    }

    MouseArea{
        anchors.fill: parent
        property int direction: 1
        property int power: 0
        property int leftSpeed: 0
        property int rightSpeed: 0
        onPositionChanged: {
            //statusBar.text = "x: " + mouseX + " y: " + mouseY + " f.x: " + finger.x + " f.y" + finger.y + " p: " + power + " d: " + direction
            if (mouseX < 30) finger.x = 30 - finger.width / 2
            else if (mouseX>parent.width - 30) finger.x = parent.width - 30 - finger.width / 2
            else finger.x = mouseX - finger.width/2

            if (mouseY < 30) finger.y = 30 - finger.height / 2
            else if (mouseY > parent.height - 30) finger.y = parent.height - 30 - finger.height / 2
            else finger.y = mouseY - finger.height / 2

            if (mouseY > (joystick.centerY + finger.height/6)) direction = -1
            else if (mouseY < (joystick.centerY - finger.height/6)) direction = 1
            else direction = 0

            if (direction == 1) power = 100 - (finger.y) * 100 / (joystick.centerY - finger.height/2)
            else power = (finger.y + finger.height - joystick.centerY) * 100 / (joystick.centerY - finger.height/2)

            if (mouseX > joystick.centerX) {
                leftSpeed = 100;
                rightSpeed = 100 - (finger.x + finger.width / 2 - joystick.centerX ) * 100 / joystick.centerX
               }
            else {
                leftSpeed = (finger.x + finger.width / 2) * 100 / joystick.centerX;
                rightSpeed = 100;
            }

            leftChassis.value = leftSpeed / 100 * power / 100 * direction;
            rightChassis.value = rightSpeed / 100 * power / 100 * direction;

            if ((parent.leftChassisSpeed * 1.4 < leftChassis.value * 100) || (leftChassis.value * 100 * 1.4 < parent.leftChassisSpeed)) {
                parent.leftChassisSpeed = leftChassis.value * 100
                parent.sync = true
            }

            if ((parent.rightChassisSpeed * 1.4 < rightChassis.value * 100) || (rightChassis.value * 100 * 1.4 < parent.rightChassisSpeed)) {
                parent.rightChassisSpeed = rightChassis.value * 100
                parent.sync = true
            }

            if (parent.sync) {
                bluetoothManager.setCommand("{\"cmd\":\"MotorPower\",\"req\":1, \"prm\":{\"left\":"+parent.leftChassisSpeed+",\"right\":"+parent.rightChassisSpeed+"}};")
                parent.sync = false
            }
        }
        onReleased: {
            finger.x = joystick.centerX - finger.width / 2
            finger.y = joystick.centerY - finger.height / 2
            leftSpeed = 100;
            rightSpeed = 100;
            leftChassis.value = 0;
            rightChassis.value = 0;
            parent.rightChassisSpeed = 0;
            parent.leftChassisSpeed = 0;
            power = 0;
            //statusBar.text = "j.x: " + joystick.width + " j.y: " + joystick.height + " j.cx: " + joystick.centerX + " j.cy: " + joystick.centerY
            bluetoothManager.setCommand("{\"cmd\":\"MotorPower\",\"req\":1, \"prm\":{\"left\":0,\"right\":0}};")
        }
    }
}
