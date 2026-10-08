pragma Singleton
import QtQml

QtObject {
    readonly property string baseUrl: "https://cdn.jsdelivr.net/gh/glincker/thesvg@main/public/icons/"


    function urlForMake(make) {
        if (!make)
            return ""

        return baseUrl + encodeURIComponent(make.toLowerCase()) + "/default.svg"
    }
}