import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: "Genel & Kart"
        icon: "preferences-desktop-theme"
        source: "configGeneral.qml"
    }
    ConfigCategory {
        name: "Saat Bloğu"
        icon: "preferences-system-time"
        source: "configClock.qml"
    }
    ConfigCategory {
        name: "Tarih Bloğu"
        icon: "view-calendar"
        source: "configDate.qml"
    }
    ConfigCategory {
        name: "Hava Durumu"
        icon: "weather-clouds"
        source: "configWeather.qml"
    }
}