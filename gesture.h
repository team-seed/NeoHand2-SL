#ifndef GESTURE_H
#define GESTURE_H

//#include "../mediapipe/mediapipe/landmarks_to_shm/landmarks_to_shm.h"
#include "../mediapipe_playground/mediapipe/mediapipe/HandGesture/ShmConfig.hpp"
#include <boost/interprocess/managed_shared_memory.hpp>
#include <QObject>
#include <QTimer>
#include <QtMath>
#include <QtDebug>

#include <iostream>

struct gesture_t{
    float x, y;
    int id;

    gesture_t(float _x = 0.f, float _y = 0.f,int _id = -1)
        :x(_x), y(_y), id(_id){}

    gesture_t& operator =(const gesture_t &ges)
    {
        x = ges.x; y = ges.y; id = ges.id;
        return *this;
    }

    gesture_t operator -(const gesture_t &ges) const
    {
        return gesture_t(x-ges.x, y-ges.y, id);
    }
};

std::ostream& operator <<(std::ostream& os, const gesture_t &ges);

class Gesture : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int hand_pos READ pos NOTIFY posChanged )

public slots:
    //get x,y,id
    void Get();

    void start() {
        tracking_timer.start();
    }

signals:
    void up_swipe();
    void down_swipe();
    void left_swipe();
    void right_swipe();
    void trigger();
    void untrigger();

    void posChanged();

public:
    Gesture();

    //click or hold
    void check_type();
    //swipe
    void check_movement();

    void normalize();
    int pos();

    //數值更新寫在 GET() 開頭
    int cur_gest;

    float upperbound = 0.87f;
    float lowerbound = 0.13f;
    float ceiling = 0.08f;
    float floor = 0.92f;
    int position, last_position;
    int height, last_height;
    gesture_t ges_last;
    gesture_t ges_cur;

#ifdef SECOND_HAND
    gesture_t ges_last_second;
    gesture_t ges_cur_second;
#endif

    QTimer tracking_timer;
};

#endif // GESTURE_H
