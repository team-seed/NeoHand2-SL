#ifndef SONGSELECT_H
#define SONGSELECT_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QDir>
#include <QDirIterator>
#include <QJsonObject>
#include <QJsonDocument>
#include <QList>
#include <QDebug>
#include <QFile>

#include "musicplayer.h"
//#include "soundfx.h"

class songselect : public QObject {

    Q_OBJECT
    Q_PROPERTY(QVariantList content READ readContent NOTIFY contentChanged)

public:
    songselect () {
        reload_song_meta();
    }

    //~songselect() {}

    void reload_song_meta() {
        songs_path = QDir::currentPath() + "/songs/";
        QStringList content_list = QDir(songs_path).entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
        //m_content = content_list.join("\n");
        QString tmp = songs_path + content_list[0] + "/meta.json";

        songs_meta.clear();
        foreach (QString path, content_list) {
            QString str = songs_path + path;
            if (!song_meta_parse(str)) {
                qDebug() << "failed on parsing " + str;
            }
        }

        m_content = songs_meta;
        emit contentChanged();
    }

    QVariantList readContent() {
        return m_content;
    }

signals:
    void contentChanged();

public slots:
    void playPreview(QString path, int time) {
        music_player.play_bgm(QUrl(path), true, time);
    }

    void stopPreview() {
        music_player.stop_bgm();
    }

private:
    bool song_meta_parse (QString& filepath) {
        QVariantList list;
        list.append(filepath);

        QFile file(filepath + "/meta.json");
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qDebug() << "Error: JSON read failed.";
            return false;
        }

        QJsonParseError jsonError;
        QJsonDocument jsonDocument = QJsonDocument::fromJson(file.readAll(), &jsonError);

        if (!jsonDocument.isNull() && (jsonError.error == QJsonParseError::NoError)) {
            if (jsonDocument.isObject()) {
                QJsonObject obj = jsonDocument.object();

                if (obj.contains("ARTIST")) {
                    QJsonValue value = obj.value("ARTIST");
                    if (value.isString()) {
                        list.append(value.toString());
                    }
                }
                else list.append("");

                if (obj.contains("TITLE")) {
                    QJsonValue value = obj.value("TITLE");
                    if (value.isString()) {
                        list.append(value.toString());
                    }
                }
                else list.append("");

                if (obj.contains("GENRE")) {
                    QJsonValue value = obj.value("GENRE");
                    if (value.isString()) {
                        list.append(value.toString());
                    }
                }
                else list.append("");

                if (obj.contains("PREVIEW")) {
                    QJsonValue value = obj.value("PREVIEW");
                    if (value.isDouble()) {
                        list.append(value.toVariant().toInt());
                    }
                }
                else list.append(0);

                if (obj.contains("COLOR")) {
                    QJsonValue value = obj.value("COLOR");
                    if (value.isString()) {
                        list.append(value.toString());
                    }
                }
                else list.append("#222222");

                if (obj.contains("BASIC")) {
                    QJsonValue value = obj.value("BASIC");
                    if (value.isDouble()) {
                        list.append(value.toVariant().toInt());
                    }
                }
                else list.append(-1);

                if (obj.contains("EXPERT")) {
                    QJsonValue value = obj.value("EXPERT");
                    if (value.isDouble()) {
                        list.append(value.toVariant().toInt());
                    }
                }
                else list.append(-1);

                if (obj.contains("PREVIEW_BPM")) {
                    QJsonValue value = obj.value("PREVIEW_BPM");
                    if (value.isDouble()) {
                        list.append(value.toVariant().toDouble());
                    }
                }
                else list.append(60);
            }
        }

        if (list.size()!=9)
            return false;

        songs_meta.insert(0, list);
        file.close();
        return true;
    }

    QVariantList m_content;
    QString songs_path = "";
    QVariantList songs_meta;

    musicplayer music_player;
};

#endif // SONGSELECT_H
