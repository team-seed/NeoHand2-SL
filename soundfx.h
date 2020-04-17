#ifndef ARRAY_EFFECT_H
#define ARRAY_EFFECT_H

#include <QtConcurrent>
#include <QSoundEffect>
#include <QDebug>

#define EFFECT_POOL_COUNT 30

class soundfx: public QObject, public QRunnable {
    Q_OBJECT

public:
    soundfx() {
        count = 0;
    }

    void init (QUrl url = QUrl("")) {
        for(int i = 0; i < EFFECT_POOL_COUNT; i++){
            sound[i] = new QSoundEffect;
            sound[i] -> setSource(url);
            sound[i] -> setVolume(1.0);
        }
    }

    void play() {
        while(sound[count]->isPlaying()==true)
            ++count %= EFFECT_POOL_COUNT ;

        sound[count] -> play();
        ++count %= EFFECT_POOL_COUNT ;
    }

    void destruct(){
        for(int i = 0; i < EFFECT_POOL_COUNT; i++)
            delete sound[i];
    }

    void run() {}

private:
    int count;
    QSoundEffect *sound[EFFECT_POOL_COUNT];

};

#endif // ARRAY_EFFECT_H
