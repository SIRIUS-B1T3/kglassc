import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: "NoBackground"

    implicitWidth: 380
    implicitHeight: 240

    // 12 Sütun x 8 Satır Mikro Izgara Matrisi
    readonly property int gridCols: 12
    readonly property int gridRows: 8
    readonly property real marginOffset: 12
    readonly property real cellWidth: (root.width - (marginOffset * 2)) / gridCols
    readonly property real cellHeight: (root.height - (marginOffset * 2)) / gridRows

    property string currentTemp: "--°C"
    property int currentWeatherCode: 0
    property bool isCurrentDay: true
    property string weatherIconSource: Qt.resolvedUrl("../icons/weather-few-clouds.svg")
    property string humidityIconSource: Qt.resolvedUrl("../icons/humidity.svg")
    property string windIconSource: Qt.resolvedUrl("../icons/wind.svg")
    property string windSpeed: "--"
    property string humidity: "--"
    property var currentTime: new Date()
    property var dailyForecast: []

    // Sinodik Ay Evresi Hesaplayıcı
    function getMoonPhaseIcon() {
        var base = Qt.resolvedUrl("../icons/");
        var refNewMoon = new Date(Date.UTC(2024, 0, 11, 11, 57, 0)).getTime();
        var now = currentTime.getTime();
        var diffDays = (now - refNewMoon) / (1000 * 60 * 60 * 24);
        var synodicMonth = 29.53058770576;
        var phase = (diffDays % synodicMonth);
        if (phase < 0) phase += synodicMonth;

        if (phase < 1.5 || phase >= 28.0) return base + "moon-new.svg";
        if (phase >= 1.5 && phase < 6.5)  return base + "moon-crescent.svg";
        if (phase >= 6.5 && phase < 9.5)  return base + "moon-quarter.svg";
        if (phase >= 9.5 && phase < 13.5) return base + "moon-gibbous.svg";
        if (phase >= 13.5 && phase < 16.5) return base + "moon-full.svg";
        if (phase >= 16.5 && phase < 20.5) return base + "moon-gibbous.svg";
        if (phase >= 20.5 && phase < 23.5) return base + "moon-quarter.svg";
        return base + "moon-crescent.svg";
    }

    // Gündüz / Gece Uyumlu Otomatik Kapsül Rengi
    function getWeatherCodeColor(code) {
        if (!isCurrentDay) {
            if (code === 0 || code === 1 || code === 2) return "#1e1b4b";
            if (code === 3) return "#1e293b";
            if (code >= 45 && code <= 48) return "#334155";
            if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) return "#0f172a";
            if ((code >= 71 && code <= 77) || code === 85 || code === 86) return "#1e293b";
            if (code >= 95) return "#3b0764";
            return "#1e1b4b";
        }
        if (code === 0) return "#fde047";
        if (code === 1 || code === 2) return "#7dd3fc";
        if (code === 3) return "#94a3b8";
        if (code >= 45 && code <= 48) return "#cbd5e1";
        if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) return "#38bdf8";
        if ((code >= 71 && code <= 77) || code === 85 || code === 86) return "#e0f2fe";
        if (code >= 95) return "#c084fc";
        return "#fde047";
    }

    function getCleanCityName() {
        var raw = Plasmoid.configuration.selectedLocationLabel || "Ankara";
        var parts = raw.split(",");
        if (parts.length > 2) return parts[parts.length - 1].trim();
        if (parts.length === 2) return parts[0].trim();
        return raw;
    }

    function getLocalizedDate() {
        var isEn = Plasmoid.configuration.language === "en";
        var daysTR = ["Pazar", "Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi"];
        var daysEN = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        var daysShortTR = ["Paz", "Pzt", "Sal", "Çar", "Per", "Cum", "Cts"];
        var daysShortEN = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

        var monthsTR = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
        var monthsEN = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var monthsShortTR = ["Oca", "Şub", "Mar", "Nis", "May", "Haz", "Tem", "Ağu", "Eyl", "Eki", "Kas", "Ara"];
        var monthsShortEN = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

        var d = currentTime.getDay();
        var m = currentTime.getMonth();
        var dayNum = currentTime.getDate();
        var year = currentTime.getFullYear();
        var padDay = dayNum < 10 ? "0" + dayNum : dayNum;
        var padMonth = (m + 1) < 10 ? "0" + (m + 1) : (m + 1);

        var dayName = isEn ? daysEN[d] : daysTR[d];
        var dayShort = isEn ? daysShortEN[d] : daysShortTR[d];
        var monthName = isEn ? monthsEN[m] : monthsTR[m];
        var monthShort = isEn ? monthsShortEN[m] : monthsShortTR[m];

        switch(Plasmoid.configuration.dateFormat) {
            case 1: return dayNum + " " + monthName + " " + dayName;
            case 2: return padDay + "." + padMonth + "." + year;
            case 3: return dayNum + " " + monthShort + ", " + dayShort;
            case 4: return dayName + "\n" + dayNum + " " + monthName;
            case 0:
            default: return dayName + ", " + dayNum + " " + monthName;
        }
    }

    function mapToLocalSvgIcon(code, isDay) {
        var base = Qt.resolvedUrl("../icons/");
        var day = (isDay === undefined) ? true : Boolean(isDay);

        if (code === 0) return day ? (base + "weather-clear.svg") : getMoonPhaseIcon();
        if (code === 1 || code === 2) return day ? (base + "weather-few-clouds.svg") : (base + "weather-few-clouds-night.svg");
        if (code === 3) return base + "weather-overcast.svg";
        if (code >= 45 && code <= 48) return base + "weather-fog.svg";
        if ((code >= 71 && code <= 77) || code === 85 || code === 86) return base + "weather-snow.svg";
        if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) return base + "weather-showers.svg";
        if (code >= 95) return base + "weather-storm.svg";
        return day ? (base + "weather-few-clouds.svg") : (base + "weather-few-clouds-night.svg");
    }

    function getDayNameFromDateStr(dateStr) {
        if (!dateStr) return "";
        var parts = dateStr.split("-");
        var d = new Date(Date.UTC(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2])));
        var daysTR = ["Paz", "Pzt", "Sal", "Çar", "Per", "Cum", "Cts"];
        var daysEN = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        return Plasmoid.configuration.language === "en" ? daysEN[d.getUTCDay()] : daysTR[d.getUTCDay()];
    }

    function fetchWeatherData() {
        var lat = Plasmoid.configuration.selectedLat;
        var lon = Plasmoid.configuration.selectedLon;
        if (!lat || !lon) return;

        var weatherUrl = "https://api.open-meteo.com/v1/forecast?latitude=" + 
                         lat + "&longitude=" + lon + "&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code,is_day&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto";

        var wXhr = new XMLHttpRequest();
        wXhr.open("GET", weatherUrl);
        wXhr.onreadystatechange = function() {
            if (wXhr.readyState === XMLHttpRequest.DONE && wXhr.status === 200) {
                var res = JSON.parse(wXhr.responseText);
                if (res.current) {
                    isCurrentDay = (res.current.is_day === 1);
                    currentWeatherCode = res.current.weather_code;
                    currentTemp = Math.round(res.current.temperature_2m) + "°C";
                    weatherIconSource = mapToLocalSvgIcon(res.current.weather_code, isCurrentDay);
                    humidity = "%" + res.current.relative_humidity_2m;
                    windSpeed = Math.round(res.current.wind_speed_10m) + " km/h";
                }
                if (res.daily && res.daily.time) {
                    var upcoming = [];
                    for (var i = 1; i < Math.min(4, res.daily.time.length); i++) {
                        upcoming.push({
                            day: getDayNameFromDateStr(res.daily.time[i]),
                            max: Math.round(res.daily.temperature_2m_max[i]) + "°C",
                            icon: mapToLocalSvgIcon(res.daily.weather_code[i], true)
                        });
                    }
                    dailyForecast = upcoming;
                }
            }
        };
        wXhr.send();
    }

    Component.onCompleted: fetchWeatherData()

    Connections {
        target: Plasmoid.configuration
        function onSelectedLatChanged() { fetchWeatherData() }
        function onSelectedLonChanged() { fetchWeatherData() }
    }

    fullRepresentation: Item {
        anchors.fill: parent

        // Ana Kart Cam Efekti
        Item {
            id: glassContainer
            anchors.fill: parent

            Rectangle {
                id: glassBase
                anchors.fill: parent
                radius: Plasmoid.configuration.cardRadius

                gradient: Gradient {
                    orientation: (Plasmoid.configuration.cardGradientAngle === 1) ? Gradient.Horizontal : Gradient.Vertical

                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(Plasmoid.configuration.cardColor.r, Plasmoid.configuration.cardColor.g, Plasmoid.configuration.cardColor.b, Plasmoid.configuration.cardOpacity)
                    }
                    GradientStop {
                        position: 1.0
                        color: {
                            if (Plasmoid.configuration.cardUseGradient && Plasmoid.configuration.cardColor2 !== undefined) {
                                return Qt.rgba(Plasmoid.configuration.cardColor2.r, Plasmoid.configuration.cardColor2.g, Plasmoid.configuration.cardColor2.b, Plasmoid.configuration.cardOpacity);
                            }
                            return Qt.rgba(Plasmoid.configuration.cardColor.r, Plasmoid.configuration.cardColor.g, Plasmoid.configuration.cardColor.b, Plasmoid.configuration.cardOpacity);
                        }
                    }
                }

                border.color: Qt.rgba(Plasmoid.configuration.cardBorderColor.r, Plasmoid.configuration.cardBorderColor.g, Plasmoid.configuration.cardBorderColor.b, 0.6)
                border.width: Plasmoid.configuration.cardBorderWidth
            }

            MultiEffect {
                source: glassBase
                anchors.fill: glassBase
                blurEnabled: true
                blur: 0.85
                blurMax: 48
                shadowEnabled: Plasmoid.configuration.cardShadow
                shadowColor: Qt.rgba(0, 0, 0, 0.22)
                shadowBlur: 0.7
                shadowVerticalOffset: 6
            }
        }

        // 12x8 Izgara Kılavuzu
        Grid {
            anchors.fill: parent
            anchors.margins: root.marginOffset
            columns: root.gridCols
            rows: root.gridRows
            visible: Plasmoid.configuration.editMode
            opacity: 0.25
            z: 1

            Repeater {
                model: root.gridCols * root.gridRows
                Rectangle {
                    width: root.cellWidth
                    height: root.cellHeight
                    color: "transparent"
                    border.color: "#3b82f6"
                    border.width: 0.5
                }
            }
        }

        // ==============================================================
        // TİTREMESİZ (GLITCH-FREE), SERBEST VE KALICI BLOK KAPSAYICISI
        // ==============================================================
        component GridBlockContainer: Item {
            id: blockContainer

            required property string blockPrefix
            required property bool isIsland
            required property bool enableShadow
            required property color capsuleColor
            required property real capsuleOpacity
            required property int capsuleRadius
            required property color activeTextColor

            property int liveCol: Plasmoid.configuration[blockPrefix + "Col"]
            property int liveRow: Plasmoid.configuration[blockPrefix + "Row"]
            property int liveSpanX: Plasmoid.configuration[blockPrefix + "SpanX"]
            property int liveSpanY: Plasmoid.configuration[blockPrefix + "SpanY"]

            x: root.marginOffset + liveCol * root.cellWidth
            y: root.marginOffset + liveRow * root.cellHeight
            width: liveSpanX * root.cellWidth
            height: liveSpanY * root.cellHeight
            clip: false

            Behavior on x { enabled: !Plasmoid.configuration.editMode; NumberAnimation { duration: 90; easing.type: Easing.OutQuad } }
            Behavior on y { enabled: !Plasmoid.configuration.editMode; NumberAnimation { duration: 90; easing.type: Easing.OutQuad } }
            Behavior on width { enabled: !Plasmoid.configuration.editMode; NumberAnimation { duration: 90; easing.type: Easing.OutQuad } }
            Behavior on height { enabled: !Plasmoid.configuration.editMode; NumberAnimation { duration: 90; easing.type: Easing.OutQuad } }

            Rectangle {
                id: innerCapsule
                anchors.fill: parent
                anchors.margins: 3
                visible: blockContainer.isIsland
                radius: blockContainer.capsuleRadius
                color: Qt.rgba(blockContainer.capsuleColor.r, blockContainer.capsuleColor.g, blockContainer.capsuleColor.b, blockContainer.capsuleOpacity)
                border.color: Qt.rgba(1, 1, 1, 0.4)
                border.width: 1.2
            }

            MultiEffect {
                source: innerCapsule
                anchors.fill: innerCapsule
                visible: blockContainer.isIsland && blockContainer.enableShadow
                shadowEnabled: true
                shadowColor: Qt.rgba(0, 0, 0, 0.18)
                shadowBlur: 0.5
                shadowVerticalOffset: 4
            }

            Rectangle {
                anchors.fill: parent
                visible: Plasmoid.configuration.editMode
                color: Qt.rgba(0.23, 0.51, 0.96, 0.08)
                border.color: "#3b82f6"
                border.width: 1.5
                radius: 6
                z: 10
            }

            MouseArea {
                anchors.fill: parent
                enabled: Plasmoid.configuration.editMode
                z: 20
                property real startRootX: 0
                property real startRootY: 0
                property int originCol: 0
                property int originRow: 0

                onPressed: function(mouse) {
                    var pt = mapToItem(root, mouse.x, mouse.y);
                    startRootX = pt.x;
                    startRootY = pt.y;
                    originCol = blockContainer.liveCol;
                    originRow = blockContainer.liveRow;
                    blockContainer.z = 50;
                }
                onPositionChanged: function(mouse) {
                    var pt = mapToItem(root, mouse.x, mouse.y);
                    var diffCol = Math.round((pt.x - startRootX) / root.cellWidth);
                    var diffRow = Math.round((pt.y - startRootY) / root.cellHeight);
                    var nextCol = Math.max(0, Math.min(root.gridCols - 1, originCol + diffCol));
                    var nextRow = Math.max(0, Math.min(root.gridRows - 1, originRow + diffRow));

                    if (blockContainer.liveCol !== nextCol) blockContainer.liveCol = nextCol;
                    if (blockContainer.liveRow !== nextRow) blockContainer.liveRow = nextRow;
                }
                onReleased: {
                    blockContainer.z = (blockPrefix === "weather" ? 15 : (blockPrefix === "clock" ? 5 : 8));
                    Plasmoid.configuration[blockPrefix + "Col"] = blockContainer.liveCol;
                    Plasmoid.configuration[blockPrefix + "Row"] = blockContainer.liveRow;
                }
            }

            Rectangle {
                visible: Plasmoid.configuration.editMode
                width: 18; height: 18; radius: 9
                color: "#3b82f6"; border.color: "#ffffff"; border.width: 2
                anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: -4
                z: 100

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.SizeFDiagCursor
                    preventStealing: true

                    property real startRootX: 0
                    property real startRootY: 0
                    property int startSpanX: 0
                    property int startSpanY: 0

                    onPressed: function(mouse) {
                        var pt = mapToItem(root, mouse.x, mouse.y);
                        startRootX = pt.x;
                        startRootY = pt.y;
                        startSpanX = blockContainer.liveSpanX;
                        startSpanY = blockContainer.liveSpanY;
                        blockContainer.z = 50;
                    }
                    onPositionChanged: function(mouse) {
                        var pt = mapToItem(root, mouse.x, mouse.y);
                        var addCols = Math.round((pt.x - startRootX) / root.cellWidth);
                        var addRows = Math.round((pt.y - startRootY) / root.cellHeight);

                        var nextSpanX = Math.max(1, Math.min(root.gridCols, startSpanX + addCols));
                        var nextSpanY = Math.max(1, Math.min(root.gridRows, startSpanY + addRows));

                        if (blockContainer.liveSpanX !== nextSpanX) blockContainer.liveSpanX = nextSpanX;
                        if (blockContainer.liveRow !== nextSpanY) blockContainer.liveRow = nextSpanY;
                    }
                    onReleased: {
                        blockContainer.z = (blockPrefix === "weather" ? 15 : (blockPrefix === "clock" ? 5 : 8));
                        Plasmoid.configuration[blockPrefix + "SpanX"] = blockContainer.liveSpanX;
                        Plasmoid.configuration[blockPrefix + "SpanY"] = blockContainer.liveSpanY;
                    }
                }
            }
        }

        // ==========================================
        // 1. BLOK: SAAT (Z: 5)
        // ==========================================
        GridBlockContainer {
            id: clockGridItem
            z: 5
            blockPrefix: "clock"
            isIsland: Plasmoid.configuration.clockIsland
            enableShadow: Plasmoid.configuration.clockShadow
            capsuleColor: Plasmoid.configuration.clockCapsuleColor
            capsuleOpacity: Plasmoid.configuration.clockCapsuleOpacity
            capsuleRadius: Plasmoid.configuration.clockCapsuleRadius
            activeTextColor: Plasmoid.configuration.clockCustomTextColor

            Item {
                anchors.fill: parent
                anchors.margins: 6
                clip: true

                Text {
                    anchors.centerIn: parent
                    visible: Plasmoid.configuration.clockStyle === 0
                    text: Qt.formatTime(root.currentTime, "hh:mm")
                    font.weight: Font.Light
                    font.family: Plasmoid.configuration.clockFontFamily
                    color: clockGridItem.activeTextColor
                    font.pixelSize: Math.min(parent.height * 0.75, parent.width * 0.38) * Plasmoid.configuration.clockFontScale
                }

                Item {
                    anchors.centerIn: parent
                    visible: Plasmoid.configuration.clockStyle === 1
                    width: Math.min(parent.width, parent.height) * 0.92
                    height: width

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "transparent"
                        border.color: Qt.rgba(clockGridItem.activeTextColor.r, clockGridItem.activeTextColor.g, clockGridItem.activeTextColor.b, 0.2)
                        border.width: 1.5

                        Repeater {
                            model: 12
                            Item {
                                width: parent.width; height: parent.height
                                rotation: index * 30

                                Rectangle {
                                    anchors.top: parent.top; anchors.topMargin: 3
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: 2.5; height: 2.5; radius: 1.25
                                    color: clockGridItem.activeTextColor
                                    visible: (Plasmoid.configuration.analogStyle === 1) || (Plasmoid.configuration.analogStyle === 2 && index % 3 !== 0)
                                }
                                Rectangle {
                                    anchors.top: parent.top; anchors.topMargin: 2
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: 1.5; height: 5
                                    color: clockGridItem.activeTextColor
                                    visible: Plasmoid.configuration.analogStyle === 3
                                }
                                Text {
                                    anchors.top: parent.top
                                    anchors.topMargin: Plasmoid.configuration.analogStyle === 3 ? 7 : 2
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: index === 0 ? "12" : index
                                    color: clockGridItem.activeTextColor
                                    font.pixelSize: Math.max(7, parent.height * (Plasmoid.configuration.analogStyle === 3 ? 0.085 : 0.11))
                                    font.family: Plasmoid.configuration.clockFontFamily
                                    font.weight: Font.DemiBold
                                    rotation: -index * 30
                                    visible: (Plasmoid.configuration.analogStyle === 2 && index % 3 === 0) || (Plasmoid.configuration.analogStyle === 3)
                                }
                            }
                        }

                        Rectangle {
                            width: 3.5; height: parent.height * 0.28; radius: 2
                            color: clockGridItem.activeTextColor
                            x: parent.width / 2 - width / 2; y: parent.height / 2 - height
                            transformOrigin: Item.Bottom
                            rotation: (root.currentTime.getHours() % 12 + root.currentTime.getMinutes() / 60) * 30
                        }
                        Rectangle {
                            width: 2; height: parent.height * 0.38; radius: 1
                            color: clockGridItem.activeTextColor
                            x: parent.width / 2 - width / 2; y: parent.height / 2 - height
                            transformOrigin: Item.Bottom
                            rotation: root.currentTime.getMinutes() * 6
                        }
                        Rectangle { width: 5; height: 5; radius: 2.5; color: clockGridItem.activeTextColor; anchors.centerIn: parent }
                    }
                }
            }
        }

        // ==========================================
        // 2. BLOK: TARİH (Z: 8)
        // ==========================================
        GridBlockContainer {
            id: dateGridItem
            z: 8
            blockPrefix: "date"
            isIsland: Plasmoid.configuration.dateIsland
            enableShadow: Plasmoid.configuration.dateShadow
            capsuleColor: Plasmoid.configuration.dateCapsuleColor
            capsuleOpacity: Plasmoid.configuration.dateCapsuleOpacity
            capsuleRadius: Plasmoid.configuration.dateCapsuleRadius
            activeTextColor: Plasmoid.configuration.dateCustomTextColor

            Item {
                anchors.fill: parent
                anchors.margins: 4
                clip: true

                Text {
                    anchors.centerIn: parent
                    width: parent.width
                    text: root.getLocalizedDate()
                    font.weight: Font.DemiBold
                    font.family: Plasmoid.configuration.dateFontFamily
                    color: dateGridItem.activeTextColor
                    font.pixelSize: 14 * Plasmoid.configuration.dateFontScale
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                }
            }
        }

        // ==========================================
        // 3. BLOK: HAVA DURUMU (Z: 15)
        // ==========================================
        GridBlockContainer {
            id: weatherGridItem
            z: 15
            blockPrefix: "weather"
            // BAŞLANGIÇTA KAPSÜL KAPALI
            isIsland: (Plasmoid.configuration.weatherIsland !== undefined) ? Plasmoid.configuration.weatherIsland : false
            enableShadow: Plasmoid.configuration.weatherShadow

            capsuleColor: Plasmoid.configuration.weatherDynamicColor 
                          ? root.getWeatherCodeColor(root.currentWeatherCode)
                          : Plasmoid.configuration.weatherCapsuleColor

            capsuleOpacity: Plasmoid.configuration.weatherCapsuleOpacity
            capsuleRadius: Plasmoid.configuration.weatherCapsuleRadius

            activeTextColor: (weatherGridItem.isIsland && Plasmoid.configuration.weatherDynamicColor && !root.isCurrentDay)
                             ? "#f8fafc"
                             : Plasmoid.configuration.weatherCustomTextColor

            readonly property bool isWide: width > height * 1.35
            readonly property bool isNightAutoSky: Plasmoid.configuration.weatherDynamicColor && !root.isCurrentDay && (root.currentWeatherCode <= 2)

            Item {
                anchors.fill: parent
                anchors.margins: weatherGridItem.isIsland ? Math.max(6, weatherGridItem.capsuleRadius * 0.3) : 6
                clip: true

                // ==============================================================
                // DİNAMİK ATMOSFER EFEKTLERİ (YILDIZ + YAĞMUR + KAR + GÜNEŞ + SİS)
                // ==============================================================
                Item {
                    anchors.fill: parent
                    z: 0
                    clip: true

                    // 1. GÜNEŞLİ / AÇIK HAVA EFEKTİ (Gündüz & Kod 0: Nefes Alan Işık Hale/Işınları)
                    Item {
                        id: sunnyLayer
                        anchors.fill: parent
                        readonly property bool isSunny: Plasmoid.configuration.weatherDynamicColor && root.isCurrentDay && (root.currentWeatherCode === 0)
                        visible: isSunny

                        // Merkezden yayılan sıcak altın rengi ışık halesi
                        Rectangle {
                            anchors.centerIn: parent
                            width: Math.min(parent.width, parent.height) * 1.4
                            height: width
                            radius: width / 2
                            color: "transparent"
                            border.color: "#fef08a"
                            border.width: 1.5
                            opacity: 0.25

                            SequentialAnimation on scale {
                                loops: Animation.Infinite
                                running: sunnyLayer.isSunny
                                NumberAnimation { from: 0.85; to: 1.15; duration: 3200; easing.type: Easing.InOutSine }
                                NumberAnimation { from: 1.15; to: 0.85; duration: 3200; easing.type: Easing.InOutSine }
                            }
                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                running: sunnyLayer.isSunny
                                NumberAnimation { from: 0.15; to: 0.40; duration: 2500; easing.type: Easing.InOutQuad }
                                NumberAnimation { from: 0.40; to: 0.15; duration: 2500; easing.type: Easing.InOutQuad }
                            }
                        }

                        // Yavaşça dönen güneş ışık parçacıkları
                        Repeater {
                            model: 6
                            Rectangle {
                                property real angle: index * 60
                                width: 2.5; height: 2.5; radius: 1.25
                                color: "#fef08a"
                                opacity: 0.45
                                x: (parent.width / 2) + Math.cos(angle * Math.PI / 180) * (parent.height * 0.38)
                                y: (parent.height / 2) + Math.sin(angle * Math.PI / 180) * (parent.height * 0.38)

                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    running: sunnyLayer.isSunny
                                    NumberAnimation { to: 0.1; duration: 1500 + index * 200 }
                                    NumberAnimation { to: 0.6; duration: 1500 + index * 200 }
                                }
                            }
                        }
                    }

                    // 2. SİSLİ / PUSLU HAVA EFEKTİ (Kod 45-48: Yatay Yavaş Süzülen Sis Dalgaları)
                    Item {
                        id: fogLayer
                        anchors.fill: parent
                        readonly property bool isFoggy: Plasmoid.configuration.weatherDynamicColor && (root.currentWeatherCode >= 45 && root.currentWeatherCode <= 48)
                        visible: isFoggy

                        Repeater {
                            model: [
                                { ry: 0.22, h: 10, d: 7000, maxOp: 0.28 },
                                { ry: 0.48, h: 14, d: 9500, maxOp: 0.35 },
                                { ry: 0.74, h: 12, d: 8200, maxOp: 0.25 }
                            ]
                            Rectangle {
                                y: modelData.ry * parent.height
                                width: parent.width * 1.6
                                height: modelData.h
                                radius: 8
                                color: Qt.rgba(1, 1, 1, modelData.maxOp)

                                NumberAnimation on x {
                                    loops: Animation.Infinite
                                    running: fogLayer.isFoggy
                                    from: -parent.width * 0.6
                                    to: parent.width * 0.1
                                    duration: modelData.d
                                }
                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    running: fogLayer.isFoggy
                                    NumberAnimation { from: 0.1; to: modelData.maxOp; duration: modelData.d / 2; easing.type: Easing.InOutQuad }
                                    NumberAnimation { from: modelData.maxOp; to: 0.1; duration: modelData.d / 2; easing.type: Easing.InOutQuad }
                                }
                            }
                        }
                    }

                    // 3. Gece Açık Havada: Yıldızlar
                    Item {
                        anchors.fill: parent
                        visible: weatherGridItem.isNightAutoSky

                        Repeater {
                            model: [
                                { rx: 0.18, ry: 0.14, s: 2.0, op: 0.7 },
                                { rx: 0.82, ry: 0.18, s: 2.5, op: 0.9 },
                                { rx: 0.48, ry: 0.28, s: 1.5, op: 0.6 },
                                { rx: 0.12, ry: 0.52, s: 2.2, op: 0.8 },
                                { rx: 0.78, ry: 0.58, s: 1.8, op: 0.65 },
                                { rx: 0.32, ry: 0.72, s: 2.4, op: 0.85 },
                                { rx: 0.88, ry: 0.82, s: 1.5, op: 0.5 }
                            ]
                            Rectangle {
                                x: modelData.rx * parent.width
                                y: modelData.ry * parent.height
                                width: modelData.s; height: modelData.s
                                radius: modelData.s / 2
                                color: weatherGridItem.isIsland ? "#ffffff" : "#475569"
                                opacity: modelData.op

                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    running: weatherGridItem.isNightAutoSky
                                    NumberAnimation { to: 0.2; duration: 1200 + index * 250; easing.type: Easing.InOutQuad }
                                    NumberAnimation { to: modelData.op; duration: 1200 + index * 250; easing.type: Easing.InOutQuad }
                                }
                            }
                        }
                    }

                    // 4. Yağmurlu Havada: Yağmur Damlaları
                    Item {
                        id: rainLayer
                        anchors.fill: parent
                        readonly property bool isRaining: Plasmoid.configuration.weatherDynamicColor && 
                                                          ((root.currentWeatherCode >= 51 && root.currentWeatherCode <= 67) || 
                                                           (root.currentWeatherCode >= 80 && root.currentWeatherCode <= 82) || 
                                                           root.currentWeatherCode >= 95)
                        visible: isRaining

                        Repeater {
                            model: 12
                            Rectangle {
                                x: (index * (parent.width / 11)) + (Math.random() * 8)
                                width: 1.5
                                height: 10 + (index % 4) * 3
                                radius: 0.75
                                color: weatherGridItem.isIsland ? "#ffffff" : "#3b82f6"
                                opacity: 0.35 + (index % 3) * 0.15
                                rotation: 14

                                NumberAnimation on y {
                                    loops: Animation.Infinite
                                    running: rainLayer.isRaining
                                    from: -20
                                    to: rainLayer.height + 20
                                    duration: 650 + (index * 60)
                                }
                            }
                        }
                    }

                    // 5. Karlı Havada: Kar Taneleri
                    Item {
                        id: snowLayer
                        anchors.fill: parent
                        readonly property bool isSnowing: Plasmoid.configuration.weatherDynamicColor && 
                                                          ((root.currentWeatherCode >= 71 && root.currentWeatherCode <= 77) ||
                                                           root.currentWeatherCode === 85 || root.currentWeatherCode === 86)
                        visible: isSnowing

                        Repeater {
                            model: 10
                            Rectangle {
                                property real startX: (index * (parent.width / 9))
                                x: startX
                                width: 3 + (index % 3) * 1.5
                                height: width
                                radius: width / 2
                                color: weatherGridItem.isIsland ? "#ffffff" : "#94a3b8"
                                opacity: 0.5 + (index % 3) * 0.2

                                NumberAnimation on y {
                                    loops: Animation.Infinite
                                    running: snowLayer.isSnowing
                                    from: -15
                                    to: snowLayer.height + 15
                                    duration: 2400 + (index * 280)
                                }

                                SequentialAnimation on x {
                                    loops: Animation.Infinite
                                    running: snowLayer.isSnowing
                                    NumberAnimation { to: startX + 6; duration: 900 + (index * 150); easing.type: Easing.InOutSine }
                                    NumberAnimation { to: startX - 6; duration: 900 + (index * 150); easing.type: Easing.InOutSine }
                                }
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    enabled: !Plasmoid.configuration.editMode
                    z: 30
                    onClicked: {
                        var lat = Plasmoid.configuration.selectedLat;
                        var lon = Plasmoid.configuration.selectedLon;
                        Qt.openUrlExternally("https://open-meteo.com/en/docs?latitude=" + lat + "&longitude=" + lon);
                    }
                }

                // DİKEY KART DÜZENİ
                ColumnLayout {
                    anchors.fill: parent
                    visible: !weatherGridItem.isWide
                    spacing: 4
                    z: 10

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.max(54, weatherGridItem.height * 0.38)
                        spacing: 6

                        Image {
                            source: root.weatherIconSource
                            sourceSize.width: 160; sourceSize.height: 160
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: Math.min(weatherGridItem.width * 0.38, weatherGridItem.height * 0.35)
                            Layout.preferredHeight: Layout.preferredWidth
                            Layout.alignment: Qt.AlignVCenter
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 0

                            Text {
                                text: root.currentTemp
                                font.weight: Font.Bold
                                color: weatherGridItem.activeTextColor
                                font.family: Plasmoid.configuration.weatherFontFamily
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: Math.min(42, weatherGridItem.height * 0.28) * Plasmoid.configuration.weatherFontScale
                                fontSizeMode: Text.Fit
                                minimumPixelSize: 18
                            }
                            Text {
                                text: root.getCleanCityName()
                                font.pixelSize: Math.max(10, 12 * Plasmoid.configuration.weatherFontScale)
                                color: Qt.rgba(weatherGridItem.activeTextColor.r, weatherGridItem.activeTextColor.g, weatherGridItem.activeTextColor.b, 0.85)
                                font.family: Plasmoid.configuration.weatherFontFamily
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                            }
                        }
                    }

                    // Rozetler
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        visible: weatherGridItem.height > 115
                        spacing: 6

                        Rectangle {
                            radius: 10
                            color: (weatherGridItem.isIsland && weatherGridItem.isNightAutoSky) ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.08)
                            implicitWidth: nemRow.width + 12
                            implicitHeight: nemRow.height + 6
                            RowLayout {
                                id: nemRow
                                anchors.centerIn: parent
                                spacing: 4
                                Image {
                                    source: root.humidityIconSource
                                    sourceSize.width: 24; sourceSize.height: 24
                                    Layout.preferredWidth: 12; Layout.preferredHeight: 12
                                }
                                Text {
                                    text: root.humidity
                                    font.pixelSize: 10 * Plasmoid.configuration.weatherFontScale
                                    font.weight: Font.Medium
                                    color: weatherGridItem.activeTextColor
                                    font.family: Plasmoid.configuration.weatherFontFamily
                                }
                            }
                        }

                        Rectangle {
                            radius: 10
                            color: (weatherGridItem.isIsland && weatherGridItem.isNightAutoSky) ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.08)
                            implicitWidth: ruzgarRow.width + 12
                            implicitHeight: ruzgarRow.height + 6
                            RowLayout {
                                id: ruzgarRow
                                anchors.centerIn: parent
                                spacing: 4
                                Image {
                                    source: root.windIconSource
                                    sourceSize.width: 24; sourceSize.height: 24
                                    Layout.preferredWidth: 12; Layout.preferredHeight: 12
                                }
                                Text {
                                    text: root.windSpeed
                                    font.pixelSize: 10 * Plasmoid.configuration.weatherFontScale
                                    font.weight: Font.Medium
                                    color: weatherGridItem.activeTextColor
                                    font.family: Plasmoid.configuration.weatherFontFamily
                                }
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }

                    // 3 Günlük Tahminler
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        visible: weatherGridItem.height > 140
                        spacing: 4

                        Repeater {
                            model: root.dailyForecast
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 48
                                Layout.minimumWidth: 32
                                radius: 8
                                color: (weatherGridItem.isIsland && weatherGridItem.isNightAutoSky) ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(0, 0, 0, 0.08)

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 2
                                    Text {
                                        text: modelData.day
                                        color: weatherGridItem.activeTextColor
                                        font.pixelSize: Math.max(9, 10 * Plasmoid.configuration.weatherFontScale)
                                        font.weight: Font.Medium
                                        font.family: Plasmoid.configuration.weatherFontFamily
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Image {
                                        source: modelData.icon
                                        sourceSize.width: 48; sourceSize.height: 48
                                        Layout.preferredWidth: 18; Layout.preferredHeight: 18
                                        fillMode: Image.PreserveAspectFit
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        text: modelData.max
                                        color: weatherGridItem.activeTextColor
                                        font.pixelSize: Math.max(10, 11 * Plasmoid.configuration.weatherFontScale)
                                        font.weight: Font.Bold
                                        font.family: Plasmoid.configuration.weatherFontFamily
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }
                        }
                    }
                }

                // YATAY KART DÜZENİ
                RowLayout {
                    anchors.fill: parent
                    visible: weatherGridItem.isWide
                    spacing: 10
                    z: 10

                    RowLayout {
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 8
                        Image {
                            source: root.weatherIconSource
                            sourceSize.width: 140; sourceSize.height: 140
                            Layout.preferredWidth: Math.min(48, weatherGridItem.height * 0.58)
                            Layout.preferredHeight: Layout.preferredWidth
                        }
                        ColumnLayout {
                            spacing: -1
                            Text {
                                text: root.currentTemp
                                font.pixelSize: Math.min(28, weatherGridItem.height * 0.40) * Plasmoid.configuration.weatherFontScale
                                font.weight: Font.Bold
                                color: weatherGridItem.activeTextColor
                                font.family: Plasmoid.configuration.weatherFontFamily
                            }
                            Text {
                                text: root.getCleanCityName()
                                font.pixelSize: 11 * Plasmoid.configuration.weatherFontScale
                                color: Qt.rgba(weatherGridItem.activeTextColor.r, weatherGridItem.activeTextColor.g, weatherGridItem.activeTextColor.b, 0.8)
                                font.family: Plasmoid.configuration.weatherFontFamily
                            }
                        }
                    }

                    ColumnLayout {
                        visible: weatherGridItem.width > 200
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 3
                        RowLayout {
                            spacing: 4
                            Image { source: root.humidityIconSource; Layout.preferredWidth: 12; Layout.preferredHeight: 12 }
                            Text { text: root.humidity; font.pixelSize: 10 * Plasmoid.configuration.weatherFontScale; color: weatherGridItem.activeTextColor }
                        }
                        RowLayout {
                            spacing: 4
                            Image { source: root.windIconSource; Layout.preferredWidth: 12; Layout.preferredHeight: 12 }
                            Text { text: root.windSpeed; font.pixelSize: 10 * Plasmoid.configuration.weatherFontScale; color: weatherGridItem.activeTextColor }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        visible: weatherGridItem.width > 260
                        spacing: 4

                        Repeater {
                            model: root.dailyForecast
                            Rectangle {
                                Layout.preferredWidth: 36
                                Layout.preferredHeight: 44
                                radius: 8
                                color: (weatherGridItem.isIsland && weatherGridItem.isNightAutoSky) ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(0, 0, 0, 0.06)
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 1
                                    Text { text: modelData.day; color: weatherGridItem.activeTextColor; font.pixelSize: 8 * Plasmoid.configuration.weatherFontScale; Layout.alignment: Qt.AlignHCenter }
                                    Image { source: modelData.icon; Layout.preferredWidth: 14; Layout.preferredHeight: 14; Layout.alignment: Qt.AlignHCenter }
                                    Text { text: modelData.max; color: weatherGridItem.activeTextColor; font.pixelSize: 9 * Plasmoid.configuration.weatherFontScale; font.weight: Font.Bold; Layout.alignment: Qt.AlignHCenter }
                                }
                            }
                        }
                    }
                }
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: root.currentTime = new Date()
        }

        Timer {
            interval: (Plasmoid.configuration.updateInterval || 15) * 60 * 1000
            running: true
            repeat: true
            onTriggered: fetchWeatherData()
        }
    }
}