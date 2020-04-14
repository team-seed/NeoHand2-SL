#ifndef SOUNDFX_HANDLER_H
#define SOUNDFX_HANDLER_H

#include "soundfx.h"

class soundfx_handler: public QObject {

    Q_OBJECT

public:
    soundfx_handler() {
        page.init(QUrl("qrc:/sound_effect/boom.wav"));
        accept.init(QUrl("qrc:/sound_effect/accept.wav"));
        decline.init(QUrl("qrc:/sound_effect/decline.wav"));
        firstlayer.init(QUrl("qrc:/sound_effect/1layer.wav"));
        secondlayer.init(QUrl("qrc:/sound_effect/2layer.wav"));
        dif_change.init(QUrl("qrc:/sound_effect/difficulty.wav"));
    }

    ~soundfx_handler() {
        page.destruct();
        accept.destruct();
        decline.destruct();
        firstlayer.destruct();
        secondlayer.destruct();
        dif_change.destruct();
    }

public slots:
    void play_page() { page.play(); }
    void play_accept() { accept.play(); }
    void play_decline() { decline.play(); }
    void play_firstlayer() { firstlayer.play(); }
    void play_secondlayer() { secondlayer.play(); }
    void play_difficulty() { dif_change.play(); }

private:
    soundfx page;
    soundfx accept;
    soundfx decline;
    soundfx firstlayer;
    soundfx secondlayer;
    soundfx dif_change;
};

#endif // SOUNDFX_HANDLER_H
