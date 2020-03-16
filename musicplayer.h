#ifndef PLAYER_H
#define PLAYER_H
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QQmlContext>
using namespace::std;

class musicplayer:public QObject{
    Q_OBJECT
public:
    musicplayer(){
        QObject::connect(&music, SIGNAL(mediaStatusChanged(QMediaPlayer::MediaStatus)), this, SLOT(checkstate(QMediaPlayer::MediaStatus)));
    }
    int currentstate(){
        return music.state();
    }
public slots:
    void displayErrorMessage()
    {
        qDebug()<<music.errorString();
    }

    void set_song(QUrl url = QUrl(""), bool loop = false, int start = 0) {
        if(!plist.isEmpty())
            plist.clear();
        plist.addMedia(url);
        if(loop)
            plist.setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
        music.setPlaylist(&plist);
        music.setVolume(100);
        music.setPosition(start);
    }

    void play_song() {
        music.play();
        connect(&music,QOverload<QMediaPlayer::Error>::of(&QMediaPlayer::error),
                this,&musicplayer::displayErrorMessage);
    }

    void stop_song() {
        music.stop();
    }

    void play_bgm(QUrl url = QUrl(""), bool loop = false, int start = 0){
        if(!plist.isEmpty())
            plist.clear();
        plist.addMedia(url);
        if(loop)
            plist.setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
        music.setPlaylist(&plist);
        music.setVolume(100);
        music.setPosition(start);
        music.play();
        connect(&music,QOverload<QMediaPlayer::Error>::of(&QMediaPlayer::error),
                this,&musicplayer::displayErrorMessage);
    }

    void stop_bgm() {
        music.stop();
    }

    void checkstate(QMediaPlayer::MediaStatus status){
        if(status == QMediaPlayer::EndOfMedia)
            emit music_stopped();
    }

signals:
    void music_stopped();

private:
    QUrl url;
    bool loop;
    int start;
    QMediaPlaylist plist;
    QMediaPlayer music;
};
#endif // PLAYER_H
