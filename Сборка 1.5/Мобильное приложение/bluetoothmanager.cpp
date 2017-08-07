#include "bluetoothmanager.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonValue>


BluetoothManager::BluetoothManager(QObject *parent) : QObject(parent),
    m_localDevice(),
    m_btSocket(new QBluetoothSocket(parent))
{
    QBluetoothLocalDevice localDevice;
    requestId = 0;
    timer = new QTimer(this);
    timer->setInterval(150);

    // Check if Bluetooth is available on this device
    if (localDevice.isValid()) {

        // Turn Bluetooth on
        localDevice.powerOn();

        // Make it visible to others
        localDevice.setHostMode(QBluetoothLocalDevice::HostDiscoverable);

        // Get connected devices
        m_remotes = localDevice.connectedDevices();

        qWarning() << "List of devices count" << m_remotes.size() << " Apparently always 0 on Android and iOS";

    }
}

void BluetoothManager::connectToDevice(QString DeviceAdress)
{
    QBluetoothAddress btAddress(DeviceAdress);
    QString uuid("00001101-0000-1000-8000-00805F9B34FB");
    m_btSocket->connectToService(QBluetoothAddress(btAddress), QBluetoothUuid(uuid), QIODevice::ReadWrite);

    connect(m_btSocket, SIGNAL(connected()), this, SLOT(onDeviceConnected()));
    connect(m_btSocket, SIGNAL(disconnected()), this, SLOT(onDeviceDisconnected()));
    connect(m_btSocket, SIGNAL(bytesWritten(qint64)), this, SLOT(onBytesWritten()));
    connect(m_btSocket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
    connect(timer, SIGNAL(timeout()), this, SLOT(onTimeout()));

    timer->start();

}

void BluetoothManager::setCommand(QByteArray command)
{
    if (writeEnable) {
        writeEnable = false;        
        m_btSocket->write(command);
        nextRequest = "";
        lastRequest = command;
    }
}

void BluetoothManager::addRequest(QByteArray command)
{
    requestId = requestId + 1;
    nextRequest = command;
}

void BluetoothManager::motorPower(int left, int right)
{

    QJsonObject Object;
    Object.insert("cmd", QJsonValue("MotorPower"));
    Object.insert("req", QJsonValue(requestId+1));
    QJsonObject Params;
    Params.insert("left", QJsonValue(left));
    Params.insert("right", QJsonValue(right));
    Object.insert("prm", QJsonValue(Params));
    QJsonDocument Command(Object);
    addRequest(Command.toJson(QJsonDocument::Compact)+';');
    //qWarning() << Command.toJson(QJsonDocument::Compact);
}

void BluetoothManager::stop()
{

    QJsonObject Object;
    Object.insert("cmd", QJsonValue("Stop"));
    Object.insert("req", QJsonValue(requestId+1));
    QJsonDocument Command(Object);
    addRequest(Command.toJson(QJsonDocument::Compact)+';');
    //qWarning() << Command.toJson(QJsonDocument::Compact);
}

void BluetoothManager::onDeviceConnected()
{
    qWarning() << "Connected.";
    deviceConnected();
}

void BluetoothManager::onDeviceDisconnected()
{
    qWarning() << "Disconnected.";
    deviceDisconnected();

}

void BluetoothManager::onBytesWritten()
{
    writeEnable = true;
    qWarning() << "bytesWritten";
}

void BluetoothManager::onReadyRead()
{
    qWarning() <<  m_btSocket->readAll();
}

void BluetoothManager::onTimeout()
{
    if (nextRequest != "") setCommand(nextRequest);
}
