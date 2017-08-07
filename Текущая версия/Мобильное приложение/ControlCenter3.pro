QT += qml quick bluetooth quickcontrols2

CONFIG += c++11

SOURCES += main.cpp \
    bluetoothmanager.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    bluetoothmanager.h

DISTFILES += \
    Logo.qml \
    DeviceSelect.qml \
    pages/DeviceSelect.qml \
    pages/Logo.qml \
    pages/ControlBoard.qml \
    elements/JoystickOld.qml \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
