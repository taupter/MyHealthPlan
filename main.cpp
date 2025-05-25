#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

#ifdef Q_OS_ANDROID
#include <QtSvg> // Because deployment sometimes just forgets to include this lib otherwise
#endif

#include "contactmodel.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Material");

    QGuiApplication app(argc, argv);
    app.setOrganizationName("Taupter");
    app.setOrganizationDomain("taupter.org");
    app.setApplicationName("My Health Plan");

    qmlRegisterType<ContactModel>("Backend", 1, 0, "ContactModel");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
