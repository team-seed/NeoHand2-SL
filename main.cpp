#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQuickWidget>

#include "input_handler.h"
#include "songselect.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    //insert the qml registers here
    qmlRegisterType<songselect>("custom.songselect", 1, 0, "CustomSongselect");

    QApplication app(argc, argv);
    Input_handler *widget = new Input_handler();
    const QUrl url (QStringLiteral("qrc:/main.qml"));

    widget->setSource(url);
    widget->init();
    widget->showFullScreen();

    return app.exec();
}
