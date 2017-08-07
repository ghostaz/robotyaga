import QtQuick 2.0

Rectangle {

    id: joystick

    property int centerX: width / 2
    property int centerY: height / 2
    property int leftChassisSpeed: 0
    property int rightChassisSpeed: 0
    property bool sync: false

    width: parent.width * 0.6
    height: parent.width * 0.6;
    anchors.bottom: parent.bottom
    anchors.margins: 30
    radius: width * 1.2
    //color: "#1c56f3"
    //border.color: "black"
    //border.width: 2
    visible: true
    anchors.horizontalCenter: parent.horizontalCenter

    Image {
        id: joystickImage
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
        width: parent.width
        height: width
        source: "../image/ЛогоЭмблема.png"
        opacity: 0.8
    }

    Rectangle{
        id: finger
        width: parent.height * 0.1
        height: parent.height * 0.1;
        radius: parent.height * 0.1
        //color: "grey"
        //border.color: "black"
        //border.width: 2
        anchors.centerIn: parent.Center
        x: parent.centerX - width / 2
        y: parent.centerY - height / 2
        Image {
            id: fingerImage
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            width: parent.width * 4
            height: width
            source: "../image/Стрелки.png"
            opacity: 1
        }
    }

    MouseArea{
        anchors.fill: parent
        property int direction: 1
        property int power: 0
        property int leftSpeed: 0
        property int rightSpeed: 0
        property int mouseXnew: 0
        property int mouseYnew: 0
        property int angle: 0
        property int fingerRadius: 0


        onPositionChanged: {

            // Переведем координаты пальца в другую систему счисления, центр которой центр джойстика
            mouseXnew = mouseX - joystick.centerX;
            mouseYnew = -1 * (mouseY - joystick.centerY);

            // Определим мощность как отдаление от центра. Вычисляется как гипотенуза. А потом вычисляется процент от радиуса
            fingerRadius = Math.min(Math.sqrt(mouseXnew * mouseXnew + mouseYnew * mouseYnew), height/2);
            power = fingerRadius * 100 / (height/2);

            // Соотношением сторон и функцией арктангентса вычисляем угол напрявления
            angle = Math.atan2(mouseYnew, mouseXnew) * (180 / Math.PI);

            // Если угол отрицательный то это движение назад
            if (angle < 0) direction = -1; else direction = 1;

            // Отрисуем крожочек под пальцем зная гипотенузу и угол (переводим в радианы). Плюс еще надо перевести обратно в систему координат юнита QT
            finger.x = fingerRadius * Math.cos(angle * Math.PI / 180) + joystick.centerX - finger.height/2;
            finger.y = -1 * fingerRadius * Math.sin(angle * Math.PI / 180) + joystick.centerY - finger.height/2;

            // Повернем логотип
            joystickImage.rotation = - angle + 90

            // Вычислим соотношение мощностей  двигателей по углу. Всего 180 градусов. Соответственно процент угла с каждой стороны это соотношение мощностей
            angle = Math.abs(angle);

            leftSpeed = (180-angle) * 100 / Math.max(angle, 180 - angle);
            rightSpeed = angle * 100 / Math.max(angle, 180 - angle);

            // А теперь вычислим мощность гусениц с учетом общей мощности и напрявления в процентах до 100
            leftSpeed = leftSpeed / 100 * power * direction;
            rightSpeed = rightSpeed / 100 * power * direction;

            // Выведем скорость гусениц
            leftChassis.value = leftSpeed / 100 * direction;
            rightChassis.value = rightSpeed / 100 * direction;

            //statusBar.text = "x: " + mouseX + " y: " + mouseY + " xn: " + mouseXnew + " yn: " + mouseYnew + " p: " + power + " a: " + angle;

            if ((Math.abs(parent.leftChassisSpeed) * 1.4 < Math.abs(leftSpeed)) || (Math.abs(leftSpeed) * 1.4 < Math.abs(parent.leftChassisSpeed))) {
                parent.leftChassisSpeed = leftSpeed;
                parent.sync = true;
            }

            if ((Math.abs(parent.rightChassisSpeed) * 1.4 < Math.abs(rightSpeed)) || (Math.abs(rightSpeed) * 1.4 < Math.abs(parent.rightChassisSpeed))) {
                parent.rightChassisSpeed = rightSpeed
                parent.sync = true
            }

            if (parent.sync) {
                //bluetoothManager.setCommand("{\"cmd\":\"MotorPower\",\"req\":1, \"prm\":{\"left\":"+parent.leftChassisSpeed+",\"right\":"+parent.rightChassisSpeed+"}};")
                bluetoothManager.motorPower(parent.leftChassisSpeed, parent.rightChassisSpeed);
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
            power = 0;
            joystickImage.rotation = 0
            //statusBar.text = "j.x: " + joystick.width + " j.y: " + joystick.height + " j.cx: " + joystick.centerX + " j.cy: " + joystick.centerY
            //bluetoothManager.setCommand("{\"cmd\":\"Stop\",\"req\":1};")
            bluetoothManager.stop();
        }
    }
}
