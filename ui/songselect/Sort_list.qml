import QtQuick 2.0

ListModel {
    id: list_model

    ListElement { sortfunc: "Artist"; path: "sorting_options_artist"; lv: 0}
    ListElement { sortfunc: "Title"; path: "sorting_options_title"; lv: 0}
    ListElement { sortfunc: "Level"; path: "sorting_options_lv1"; lv: 1}
    ListElement { sortfunc: "Level"; path: "sorting_options_lv2"; lv: 2}
    ListElement { sortfunc: "Level"; path: "sorting_options_lv3"; lv: 3}
    ListElement { sortfunc: "Level"; path: "sorting_options_lv4"; lv: 4}
    ListElement { sortfunc: "Level"; path: "sorting_options_lv5"; lv: 5}
    ListElement { sortfunc: "Level"; path: "sorting_options_lv6"; lv: 6}
    ListElement { sortfunc: "Level"; path: "sorting_options_lv7"; lv: 7}
    ListElement { sortfunc: "Level"; path: "sorting_options_lv8"; lv: 8}
    ListElement { sortfunc: "Level"; path: "sorting_options_lv9"; lv: 9}
    ListElement { sortfunc: "Level"; path: "sorting_options_lv10"; lv: 10}

    function get_level_index (input) {
        for(var i = 0; i < list_model.count; i ++){
            if (list_model.get(i).lv === input) return i
        }
    }
}
