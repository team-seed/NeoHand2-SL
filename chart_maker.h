#ifndef CHART_MAKER_H
#define CHART_MAKER_H

#include <QObject>
#include <QUrl>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>
#include <QVariant>
#include <QDebug>

// add more headers here if needed, but it should kinda be empty

struct slide {
    int time, left, right;
};

struct note {
    int time, gesture, left, right, type;
    int direction; // for swipe notes
    QList<slide> path; // for hold notes
};

struct chart_section {
    double bpm;
    int offset, beats;
    QList<note> notes;
};

class chart_maker: public QObject {
    Q_OBJECT
    Q_PROPERTY (QVariantList chart READ chart NOTIFY chartChanged)

public:
    //chart_maker();
    //~chart_maker();

    QVariantList chart() { return qml_chart; }
    void chart_toList(); // make a QList chart into a qml-friendly one

signals:
    void chartChanged();

public slots:
    bool song_chart_parse (QString); // parse a json file into a c++ chart

private:
    QList<chart_section> song_chart;
    QList<QList<int>> note_list;
    QVariantList qml_chart;
};

#endif // CHART_MAKER_H
