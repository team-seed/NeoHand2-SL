#ifndef GAME_CLOCK_H
#define GAME_CLOCK_H

#include <QObject>
#include <QTime>
#include <QTimer>
#include <QDebug>

#include "musicplayer.h"

class game_clock: public QObject {

    Q_OBJECT
    Q_PROPERTY(int elapsed READ clock NOTIFY clockChanged)
    Q_PROPERTY(int duration_before_start READ dbs NOTIFY dbsChanged)

public:
    game_clock() {
        update_clock.setTimerType(Qt::PreciseTimer);
        update_clock.setInterval(4); // maybe I should set this 2
        QObject::connect(&update_clock, SIGNAL(timeout()), this, SIGNAL(clockChanged()));
        QObject::connect(&m_player, SIGNAL(music_stopped()), this, SIGNAL(game_finished()));

        duration_before_start = 2500;
    }

    int clock() { return (m_time.isNull() ? - duration_before_start : (m_time.elapsed() - duration_before_start)); }
    int dbs () { return duration_before_start; }

public slots:
    void set_song (QString audio_path) { m_player.set_song(audio_path); }

    void game_start () {
        update_clock.start();
        m_time.start();
        QTimer::singleShot(duration_before_start, Qt::PreciseTimer, this, SLOT(song_start()));
    }

    void song_start() { m_player.play_song(); }

    void game_stop () { update_clock.stop(); }

signals:
    void clockChanged();
    void game_finished();
    void dbsChanged();

private:
    musicplayer m_player;
    QTime m_time;
    QTimer update_clock;

    int duration_before_start;

};

#endif // GAME_CLOCK_H
