TEMPLATE = app

QT += qml quick quickcontrols2 quickwidgets svg

CONFIG += c++11

SOURCES += main.cpp \
    contactmodel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android/build.gradle \
    android/build.gradle \
    android/res/values/libs.xml \
    android/res/values/libs.xml \
    android/res/xml/qtprovider_paths.xml \
    android/res/xml/qtprovider_paths.xml \
    backend.js \
    android/AndroidManifest.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += \
    contactmodel.h

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
#    $$PWD/../MyHealthPlan.pro
    $$PWD/android
}
