#ifndef BLUETOOTHMANAGER_H
#define BLUETOOTHMANAGER_H

#include <QObject>
#include <QVariant>
#include <QBluetoothAddress>
#include <QBluetoothLocalDevice>
#include <QBluetoothSocket>
#include <QTimer>

class BluetoothManager : public QObject
{
    Q_OBJECT

public:
    explicit BluetoothManager(QObject *parent = 0);

private:
    QList<QBluetoothAddress> m_remotes;
    QBluetoothLocalDevice m_localDevice;
    QBluetoothSocket *m_btSocket;
    int requestId; // Количество команд в очереди. Нужно для формирования номера запроса в платформу
    bool writeEnable = true;
    QByteArray nextRequest;
    QByteArray lastRequest;
    QTimer *timer;
    void setCommand(QByteArray command);
    void addRequest(QByteArray command);


signals:
    void deviceConnected();
    void deviceDisconnected();


private slots:
    void onDeviceConnected();
    void onDeviceDisconnected();
    void onBytesWritten();
    void onReadyRead();
    void onTimeout();


public slots:
    void connectToDevice(QString DeviceAdress);
    void motorPower(int left, int right);
    void stop();

};

#endif // BLUETOOTHMANAGER_H
