#include "gesture.h"
#include <boost/interprocess/shared_memory_object.hpp>
Gesture::Gesture(){
    tracking_timer.setTimerType(Qt::PreciseTimer);
    tracking_timer.setInterval(4);
    QObject::connect(&tracking_timer, SIGNAL(timeout()), this, SLOT(Get()));

    ges_cur = gesture_t(0, 0, -1);
    ges_last = gesture_t(0, 0, -1);
}

int Gesture::pos() {
    return position;
}

void Gesture::normalize(){
    if ((ges_cur.x > upperbound) || (ges_cur.x < lowerbound))
        position = -1;
    else
        position = qMin(15, qFloor((ges_cur.x - lowerbound) * 16 / (upperbound - lowerbound)));

    if ((ges_cur.y > floor) || (ges_cur.y < ceiling))
        height = -1;
    else
        height = qMin(15, qFloor((ges_cur.y - ceiling) * 16 / (floor - ceiling)));
}

void Gesture::Get(){
    ges_last = ges_cur;
    // Create a new segment with given name and size
    boost::interprocess::managed_shared_memory segment(
        boost::interprocess::open_or_create, ShmConfig::shmName, ShmConfig::shmSize);

    // Construct an variable in shared memory
    ShmConfig::Gesture *ges = segment.find<ShmConfig::Gesture>(
        ShmConfig::shmbbCenterGestureName).first;

    ges_cur = {ges[0].lm.x, ges[0].lm.x, ges[0].gesture};

    last_position = position;
    last_height = height;

    normalize();
    emit posChanged();

    check_type();
    check_movement();

}
void Gesture::check_type(){
    //手勢改變
    if (ges_cur.id != ges_last.id) {
        if (ges_cur.id == -1 && cur_gest != -1) {
            cur_gest = -1;
            emit untrigger();
        }
        //ges1 介於0~10
        else if (0 <= ges_cur.id && ges_cur.id < 10 && cur_gest != 0) {
            cur_gest = 0;
            emit trigger();
        }
    }
}


void Gesture::check_movement(){

    if (position != -1 && last_position != -1 && position != last_position) {
        int x = position - last_position;
        if (x > 0) emit right_swipe();
        else emit left_swipe();
    }

    if (height != -1 && last_height != -1 && height != last_height) {
        int y = height - last_height;
        if (y > 0) emit down_swipe();
        else emit up_swipe();
    }
}

std::ostream& operator <<(std::ostream& os, const gesture_t &ges)
{
    os << "gesture: " << ges.x << " " << ges.y << " " << ges.id << "\n";
    return os;
}

