#include "chart_maker.h"

bool chart_maker::song_chart_parse (QString filepath) {
    QString range;
    //qDebug() << filepath;
    QFile file(filepath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Error: JSON read failed.";
        return false;
    }

    QJsonParseError jsonError;
    QJsonDocument jsonDocument = QJsonDocument::fromJson(file.readAll(), &jsonError);

    if (jsonDocument.isNull())
        qDebug() << "could not read data.";

    // parsing the selected chart
    if (!jsonDocument.isNull() && (jsonError.error == QJsonParseError::NoError)) {
        if (jsonDocument.isObject()) {
            QJsonObject obj = jsonDocument.object();

            if (obj.contains("BPM_RANGE")) {
                QJsonValue value = obj.value("BPM_RANGE");
                if (value.isString()) {
                    range = value.toString();
                }
            }

            if (obj.contains("SECTION")) {
                QJsonValue value = obj.value("SECTION");
                if (value.isArray()) {
                    QJsonArray arr = value.toArray();
                    int arrsize = arr.size();
                    for (int i = 0; i < arrsize; i++) {
                        if (arr.at(i).isObject()) {
                            QJsonObject section = arr.at(i).toObject();
                            chart_section data;
                            data.notes.clear();

                            if (section.contains("BPM")) {
                                QJsonValue v = section.value("BPM");
                                if (v.isDouble()) {
                                    data.bpm = v.toDouble();
                                }
                            }

                            if (section.contains("OFFSET")) {
                                QJsonValue v = section.value("OFFSET");
                                if (v.isDouble()) {
                                    data.offset = v.toVariant().toInt();
                                }
                            }

                            if (section.contains("BEATS")) {
                                QJsonValue v = section.value("BEATS");
                                if (v.isDouble()) {
                                    data.beats = v.toVariant().toInt();
                                }
                            }

                            if (section.contains("NOTES")) {
                                QJsonValue v = section.value("NOTES");
                                if (v.isArray()) {
                                    QJsonArray a = v.toArray();
                                    int size = a.size();
                                    for (int j = 0; j < size; j++) {
                                        note tmp_note;
                                        tmp_note.path.clear();

                                        if (a.at(j).isString()) {
                                            QString str = a.at(j).toString();
                                            QStringList strlist = str.split(QRegExp("[,]"), QString::SkipEmptyParts);

                                            if (strlist.size() == 5) {
                                                tmp_note.time = strlist[0].toInt();
                                                tmp_note.gesture = strlist[1].toInt();
                                                tmp_note.left = strlist[2].toInt();
                                                tmp_note.right = strlist[3].toInt();

                                                QStringList slider = strlist[4].split(QRegExp("[|]"), QString::SkipEmptyParts);
                                                tmp_note.type = slider[0].toInt();
                                                if (tmp_note.type == 1 && slider.size() > 1) {
                                                    for (int k = 1; k < slider.size(); k++) {
                                                        QStringList sliderpath = slider[k].split(QRegExp("[:]"), QString::SkipEmptyParts);
                                                        slide s;
                                                        if (sliderpath.size() == 3) {
                                                            s.time = sliderpath[0].toInt();
                                                            s.left = sliderpath[1].toInt();
                                                            s.right = sliderpath[2].toInt();
                                                        }

                                                        tmp_note.path.append(s);
                                                    }
                                                }
                                                if (tmp_note.type == 2 && slider.size() == 2) {
                                                    tmp_note.direction = slider[1].toInt();
                                                }
                                            }
                                        }

                                        data.notes.append(tmp_note);
                                    }
                                }
                            }

                            song_chart.append(data);
                        }
                    }
                }
            }
        }
    }

    // updating the parsed qml chart
    chart_toList();
    emit chartChanged();

    file.close();
    return true;
}

void chart_maker::chart_toList() {

}
