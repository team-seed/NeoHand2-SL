#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQuickWidget>

#include "input_handler.h"
#include "songselect.h"
#include "chart_maker.h"
#include "soundfx_handler.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    //insert the qml registers here
    qmlRegisterType<soundfx_handler>("custom.soundfx", 1, 0, "CustomSoundFX");
    qmlRegisterType<songselect>("custom.songselect", 1, 0, "CustomSongselect");
    qmlRegisterType<chart_maker>("custom.chart_maker", 1, 0, "CustomChartMaker");

    QApplication app(argc, argv);
    Input_handler *widget = new Input_handler();
    const QUrl url (QStringLiteral("qrc:/main.qml"));

    widget->engine()->rootContext()->setContextProperty("rootPath", QDir::currentPath());

    widget->setSource(url);
    widget->init();
    widget->showFullScreen();

    return app.exec();
}
