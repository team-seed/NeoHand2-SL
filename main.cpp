#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQuickWidget>
#include"Game_process.h"
#include "Game_timer.h"
#include "input_handler.h"
#include "songselect.h"
int main(int argc, char *argv[])
{
    struct ShmPreventer{
        ShmPreventer(){boost::interprocess::shared_memory_object::remove(ShmConfig::shmName);}
        ~ShmPreventer(){boost::interprocess::shared_memory_object::remove(ShmConfig::shmName);}
    }shmPreventer;

    // Create a new segment with given name and size
    boost::interprocess::managed_shared_memory segment(
        boost::interprocess::open_or_create, ShmConfig::shmName, ShmConfig::shmSize);

    // Construct an variable in shared memory
    ShmConfig::Gesture *gesture = segment.construct<ShmConfig::Gesture>(
        ShmConfig::shmbbCenterGestureName)();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    //insert the qml registers here
    qmlRegisterType<songselect>("custom.songselect", 1, 0, "CustomSongselect");
    qmlRegisterType<Game_process>("custom.game.process", 1, 0, "CustomGameProcess");
    qmlRegisterType<Game_timer>("custom.game.timer", 1, 0, "CustomGameTimer");

    QApplication app(argc, argv);
    Input_handler *widget = new Input_handler();
    const QUrl url (QStringLiteral("qrc:/main.qml"));

    widget->setSource(url);
    widget->init(gesture);
    widget->showFullScreen();

    return app.exec();
}
