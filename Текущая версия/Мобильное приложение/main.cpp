#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQuick/QQuickView>

#include "bluetoothmanager.h"


int main(int argc, char *argv[])
{

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQuickView view;

    BluetoothManager bluetoothManager;
    view.rootContext()->setContextProperty("bluetoothManager", QVariant::fromValue(&bluetoothManager));

    view.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);

    view.show();
    return app.exec();

}

