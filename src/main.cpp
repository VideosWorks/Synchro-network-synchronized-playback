#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "videoobject.h"
#include "seekworker.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("Synchro");
    app.setApplicationName("Synchro");
    app.setApplicationVersion(QString::number(VERSION));
    // libmpv requires LC_NUMERIC to be set to "C"
    std::setlocale(LC_NUMERIC, "C");

    qmlRegisterType<VideoObject>("Synchro.Core", 1, 0, "VideoObject");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
