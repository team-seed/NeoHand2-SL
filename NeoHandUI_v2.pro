QT       += core gui quick quickwidgets concurrent multimedia

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    ../mediapipe_playground/mediapipe/mediapipe/HandGesture/ShmConfig.cpp \
    gesture_engine.cpp \
    main.cpp \
    chart_maker.cpp

HEADERS += \
    ../mediapipe_playground/mediapipe/mediapipe/HandGesture/ShmConfig.hpp \
    gesture_engine.h \
    chart_maker.h \
    game_clock.h \
    input_handler.h \
    musicplayer.h \
    songselect.h \
    soundfx.h \
    soundfx_handler.h

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES +=

RESOURCES += \
    fonts.qrc \
    images.qrc \
    qml.qrc \
    script.qrc \
    sound_effect.qrc

LIBS += \
    -lrt \
    -lpthread \
    -lopencv_videoio \
