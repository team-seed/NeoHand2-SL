#ifndef GAME_PROCESS_H
#define GAME_PROCESS_H

#include <QObject>
#include <QUrl>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>
#include "soundfx.h"
#include "musicplayer.h"

struct slide {
    int time, left, right;
};

struct note {
    int time, gesture, left, right, type;
    int direction;
    QList<slide> path;
};

struct chart_section {
    double bpm;
    int offset;
    int beats;
    QList<note> notes;
};

class Game_process : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString bpm_range READ bpm_range NOTIFY bpm_rangeChanged)
    Q_PROPERTY(QVariantList chart READ chart NOTIFY chartChanged)

public:
    Game_process() {
        //hit_effect.init(QUrl("qrc:/hit_effect/click.wav"));
        //swipe_effect.init(QUrl("qrc:/hit_effect/swipe.wav"));
        //hold_effect.init(QUrl("qrc:/hit_effect/t1.wav"));
    }

    ~Game_process(){
        //hit_effect.destruct();
        //swipe_effect.destruct();
        //hold_effect.destruct();
    }

    QString bpm_range () {
        return m_bpm_range;
    }

    QVariantList chart() {
        return qml_chart;
    }

    void chart_toList ();

signals:
    void bpm_rangeChanged();
    void chartChanged();

public slots:
    bool song_chart_parse (QString filepath);

    //void hit_play(){hit_effect.play();}
    //void swipe_play(){swipe_effect.play();}
    //void hold_play(){hold_effect.play();}

private:
    musicplayer music_player;
    QList<chart_section> song_chart;
    QList<QList<int>> note_list;
    QString m_bpm_range;
    QVariantList qml_chart;

    //Effect_play hit_effect;
    //Effect_play swipe_effect;
    //Effect_play hold_effect;

    //Array_effect hit_effect;
    //Array_effect swipe_effect;
    //Array_effect hold_effect;
};

#endif // GAME_PROCESS_H
