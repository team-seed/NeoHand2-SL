#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQuickWidget>
#include"Game_process.h"
#include "Game_timer.h"
#include "gesture.h"
#include "input_handler.h"
#include "songselect.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    //insert the qml registers here
    qmlRegisterType<songselect>("custom.songselect", 1, 0, "CustomSongselect");
    qmlRegisterType<Game_process>("custom.game.process", 1, 0, "CustomGameProcess");
    qmlRegisterType<Game_timer>("custom.game.timer", 1, 0, "CustomGameTimer");
    qmlRegisterType<Gesture>("gesture",1,0,"Gesture");

    QApplication app(argc, argv);
    Input_handler *widget = new Input_handler();
    const QUrl url (QStringLiteral("qrc:/main.qml"));

    widget->setSource(url);
    widget->init();
    widget->showFullScreen();

    return app.exec();
}
