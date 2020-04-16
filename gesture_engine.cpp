#include "gesture_engine.h"
#include <boost/interprocess/managed_shared_memory.hpp>
#include <boost/interprocess/sync/scoped_lock.hpp>

Gesture_engine::Gesture_engine()
{
    tracking_timer.setTimerType(Qt::PreciseTimer);
    tracking_timer.setInterval(4);
    QObject::connect(&tracking_timer, SIGNAL(timeout()), this, SLOT(Get()));
}

void Gesture_engine::emit_pos0() {
    emit handA_update(ges_cur[1].x,ges_cur[0].y,ges_cur[0].gesture);
}
void Gesture_engine::emit_pos1() {
    emit handB_update(ges_cur[1].x,ges_cur[1].y,ges_cur[1].gesture);
}

void Gesture_engine::check_hand() {

    int cur[] = {0, 0, 1, 1};
    int last[] = {0, 1, 0, 1};
    float min_dis = 10000000;
    int min_index = -1;
    int count = ( hand_num ==1 ) ? 2 : 4;

    for(int i=0; i < count; i++){
        if(ges_last[last[i]].gesture != NO_HAND){
            float d = distance(&ges_cur[cur[i]], &ges_last[last[i]]);
            min_index = d < min_dis ? i : min_index;
            min_dis = d < min_dis ? d : min_dis;
        }
    }

    if(min_index == 1 || min_index == 2){
        ges_swap();
        if(hand_num == 1)   ges_cur[0].gesture = NO_HAND;
    }
    else{
        if(hand_num == 1)   ges_cur[1].gesture = NO_HAND;
    }

}

void Gesture_engine::normalize(){
    for(int i= 0 ; i < 2 ; i++){
        if( ges_cur[i].gesture !=- 1 ){
            if ((ges_cur[i].x > (1 - x_filter)) || (ges_cur[i].x < x_filter))
                ges_cur[i].position = NO_HAND;
            else{
                ges_cur[i].x = ges_cur[i].x * ( 1 / ( 1 - 2*x_filter) );
            }

            if ((ges_cur[i].y > (1 - y_filter)) || (ges_cur[i].y < y_filter))
                ges_cur[i].position = NO_HAND;
            else
                ges_cur[i].y = ges_cur[i].y * ( 1 / ( 1 - 2*y_filter) );
        }
    }
    emit handA_update(ges_cur[0].x, ges_cur[0].y, ges_cur[0].gesture);
    emit handB_update(ges_cur[1].x, ges_cur[1].y, ges_cur[1].gesture);

}

void Gesture_engine::Get(){
    ges_last[0] = ges_cur[0];
    ges_last[1] = ges_cur[1];
    last_hand_num = hand_num;
    {
        // lock start
        boost::interprocess::scoped_lock<boost::interprocess::interprocess_mutex> lock(shm->mutex);
        if(!shm->gestureUpdate){
            shm->condEmpty.wait(lock);
        }
        hand_num = shm->outputHandNum;
        for(int i= 0 ; i <hand_num ; i++)
            ges_cur[i] = boost::move(shm->lm[i]);

        // Notify the other process that the buffer is empty
        shm->condFull.notify_one();
        shm->gestureUpdate = false;
        // lock end
     }

    check_hand();
    normalize();

    check_gesture();
}



void Gesture_engine::check_gesture(){

    for(int i= 0 ; i <2 ; i++){

        if ( ges_cur[i].gesture != ges_last[i].gesture ) {
            if (ges_cur[i].gesture == 1){
                //qDebug()<< i <<": trigger";
                emit click_trigger();
            }
            else if(ges_last[i].gesture == 1){
                //qDebug()<< i <<": untrigger";
                emit click_untrigger();
            }
        }

        if (ges_cur[i].gesture != NO_HAND && ges_last[i].gesture != NO_HAND ){
            float x = ges_cur[i].x - ges_last[i].x ;
            float y = ges_cur[i].y - ges_last[i].y ;

            if(x > x_threshold){
                //qDebug()<< i <<": swipe x" << ges_cur[i].gesture;
                emit swipe_trigger(3,ges_cur[i].position);
            }
            else if( x < -x_threshold){
                //qDebug()<< i <<": swipe x" << ges_cur[i].gesture;
                emit swipe_trigger(2,ges_cur[i].position);
            }


            if( y > y_threshold){
                //qDebug()<< i <<": swipe y" << ges_cur[i].gesture;
                emit swipe_trigger(0,ges_cur[i].position);
            }
            else if(y < -y_threshold){
                //qDebug()<< i <<": swipe y" << ges_cur[i].gesture;
                emit swipe_trigger(1,ges_cur[i].position);
            }
        }
    }

    //emit posChanged();
}

float Gesture_engine::distance(gesture_t *cur_ges,gesture_t *last_ges){
    return qSqrt(qPow(cur_ges->x - last_ges->x, 2) +qPow(cur_ges->y - last_ges->y, 2)) ;
}

void Gesture_engine::ges_swap(){
    gesture_t tmp;
    tmp = ges_cur[0];
    ges_cur[0] = ges_cur[1];
    ges_cur[1] = tmp;
}

std::ostream& operator <<(std::ostream& os, const gesture_t &ges)
{
    //os << "gesture: " << ges.x << " " << ges.y << " " << ges.id << "\n";
    return os;
}


