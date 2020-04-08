Number.prototype.numberFormat = function(c, d, t){
var n = this,
    c = isNaN(c = Math.abs(c)) ? 2 : c,
    d = d == undefined ? "." : d,
    t = t == undefined ? "," : t,
    s = n < 0 ? "-" : "",
    i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
    j = (j = i.length) > 3 ? j % 3 : 0;
   return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
 };

function long(obj) {return obj + 50 > meta__.width}

var component
var obj

function generateArrow(dir) {
    if (component == null)
        component = Qt.createComponent("Arrow.qml");

    if (component.status == Component.Ready) {
        var dynamicObject
        if (dir == "right")
            dynamicObject = component.createObject(game_screen_side_right)
        else
            dynamicObject = component.createObject(game_screen_side_left)

        if (dynamicObject == null) {
            console.log("err on creating")
            console.log(component.errorString())
            return false
        }

        if (dir == "right") {
            dynamicObject.x = -parent.width
        }
        else {
            dynamicObject.mirror = true
            dynamicObject.x = parent.width//screen.width * 0.375
        }

        //dynamicObject.height = parent.height
        dynamicObject.y = 0
        obj = dynamicObject
    }
    else {
        console.log("error loading")
        console.log(component.errorString())
        return false
    }
    arrowmove (dir)
    return true
}

function arrowmove (dir) {
    obj.state = (dir == "right") ? "MOVER" : "MOVEL"
}

function destroyArrow(time) {
    obj.destroy(time)
}
