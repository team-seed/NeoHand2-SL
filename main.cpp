#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQuickWidget>
#include <unistd.h>
#include<sys/types.h>
#include<signal.h>

#include "chart_maker.h"
#include "soundfx_handler.h"
#include "game_clock.h"
//#include "Game_process.h"
//#include "Game_timer.h"
#include "input_handler.h"
#include "songselect.h"


int main(int argc, char *argv[])
{
    pid_t pid;

    pid = fork();
    if(pid == 0){
        char *argv[] = {"/bin/bash","runHandTrackingGPU.sh", NULL};
        // direct to runHandTrackingGPU.sh folder
        chdir("../mediapipe_playground/mediapipe");
        execv("/bin/bash", argv);
        std::cout << "child exec failed\n";
        exit(EXIT_FAILURE);
    }
    else if(pid > 0){
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

        qmlRegisterType <soundfx_handler> ("custom.soundfx", 1, 0, "CustomSoundFX");
        qmlRegisterType <songselect> ("custom.songselect", 1, 0, "CustomSongselect");
        qmlRegisterType <chart_maker> ("custom.chart_maker", 1, 0, "CustomChartMaker");
        qmlRegisterType <game_clock> ("custom.game_clock", 1, 0, "CustomGameClock");

        QApplication app(argc, argv);
        Input_handler *widget = new Input_handler();
        const QUrl url (QStringLiteral("qrc:/main.qml"));

        widget->engine()->rootContext()->setContextProperty("rootPath", QDir::currentPath());

        widget->setSource(url);
        widget->init(gesture);
        widget->showFullScreen();
        qDebug()<<getpid()<<" "<<pid;
        int appRet = app.exec();

        kill(pid,SIGTERM);

        segment.destroy<ShmConfig::Gesture>(ShmConfig::shmbbCenterGestureName);

        return appRet;
    }
    else{
        std::cout << "fork error\n";
    }
}
