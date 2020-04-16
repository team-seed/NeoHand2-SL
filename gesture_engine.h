#ifndef GESTURE_H
#define GESTURE_H

//#include "../mediapipe/mediapipe/landmarks_to_shm/landmarks_to_shm.h"
#include "../mediapipe_playground/mediapipe/mediapipe/HandGesture/ShmConfig.hpp"
#include <QObject>
#include <QTimer>
#include <QtMath>
#include <QtDebug>
#include <iostream>
#include <QVariantList>
#include <QThread>
constexpr int NO_HAND = -2;
struct gesture_t:ShmConfig::Normalized2DPoint{
    int position;

    gesture_t(Normalized2DPoint n = {0.f,0.f,NO_HAND}, int _position = -1)
        :Normalized2DPoint{n}, position(_position) {}

    gesture_t& operator =(const gesture_t &ges)
    {
        x = ges.x; y =ges.y;  gesture = (ges.gesture > 0 ? 1 : ges.gesture);
        position = ges.position;
        return *this;
    }

    bool operator ==(const gesture_t ges)
    {
        return (x == ges.x && y ==ges.y && gesture == ges.gesture);
    }


};

std::ostream& operator <<(std::ostream& os, const gesture_t &ges);

class Gesture_engine : public QObject
{
    Q_OBJECT

public slots:
    void Get();

    void engine_start() {
        //engine_thread->start();
        tracking_timer.start();
    }

    void engine_stop(){
        //tracking_timer.stop();
        engine_thread->terminate();
    }

signals:
    int swipe_trigger(QVariant,QVariant);
    void click_trigger();
    void click_untrigger();

    void handA_update(QVariant,QVariant,QVariant);
    void handB_update(QVariant,QVariant,QVariant);
public:
    Gesture_engine();

    void init(ShmConfig::Gesture *_shm){
        shm = _shm;
    }
private:
    static void run_engine(){
        system("cd ../mediapipe_playground/mediapipe; ./runHandTrackingGPU.sh");
        return;
    }

    float distance(gesture_t *cur_ges,gesture_t *last_ges);
    void check_gesture();
    void ges_swap();
    void check_hand();
    void normalize();
    void emit_pos0();
    void emit_pos1();

    int hand_num = 0;
    int last_hand_num = 0;

    double x_filter = 0.13f;
    double y_filter = 0.08f;

    double x_threshold = 0.04f;
    double y_threshold = 0.04f;

    gesture_t ges_last[2];
    gesture_t ges_cur[2];

    ShmConfig::Gesture *shm;

    QTimer tracking_timer;

    //QObject *obj;
    QThread *engine_thread= QThread::create(run_engine);
};

#endif // GESTURE_H