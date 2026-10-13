import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Item {
    id: rootItem
    implicitWidth: 460
    implicitHeight: 480

    // --- KENDİ KCONFIG BAĞLANTILARI ---
    property alias cfg_weatherLayoutType: layoutTypeBox.currentIndex
    property alias cfg_weatherDynamicColor: dynamicColorSwitch.checked
    property alias cfg_selectedLocationLabel: selectedLocText.text
    property alias cfg_selectedLat: latStorage.text
    property alias cfg_selectedLon: lonStorage.text
    property alias cfg_updateInterval: intervalSpin.value
    property alias cfg_weatherFontFamily: fontBox.currentText
    property alias cfg_weatherFontScale: weatherScaleSlider.value
    property alias cfg_weatherIsland: weatherIslandSwitch.checked
    property alias cfg_weatherShadow: weatherShadowSwitch.checked
    property alias cfg_weatherCapsuleColor: capsuleColorPicker.chosenColor
    property alias cfg_weatherCapsuleOpacity: capsuleOpacitySlider.value
    property alias cfg_weatherCapsuleRadius: capsuleRadiusSlider.value
    property alias cfg_weatherCustomTextColor: customTextPicker.chosenColor

    // --- DİĞER GRUPLARDAN GELEN ENJEKSİYONLARI YUTAN ALANLAR ---
    property var cfg_editMode
    property var cfg_language
    property var cfg_cardRadius
    property var cfg_cardOpacity
    property var cfg_cardColor
    property var cfg_cardBorderColor
    property var cfg_cardBorderWidth
    property var cfg_cardShadow

    property var cfg_clockStyle
    property var cfg_analogStyle
    property var cfg_clockFontFamily
    property var cfg_clockFontScale
    property var cfg_clockIsland
    property var cfg_clockShadow
    property var cfg_clockCapsuleColor
    property var cfg_clockCapsuleOpacity
    property var cfg_clockCapsuleRadius
    property var cfg_clockCustomTextColor
    property var cfg_clockCol
    property var cfg_clockRow
    property var cfg_clockSpanX
    property var cfg_clockSpanY

    property var cfg_dateFormat
    property var cfg_dateFontFamily
    property var cfg_dateFontScale
    property var cfg_dateIsland
    property var cfg_dateShadow
    property var cfg_dateCapsuleColor
    property var cfg_dateCapsuleOpacity
    property var cfg_dateCapsuleRadius
    property var cfg_dateCustomTextColor
    property var cfg_dateCol
    property var cfg_dateRow
    property var cfg_dateSpanX
    property var cfg_dateSpanY

    property var cfg_weatherCol
    property var cfg_weatherRow
    property var cfg_weatherSpanX
    property var cfg_weatherSpanY

    ListModel { id: searchResultsModel }

    function searchLocation(query) {
        if (!query || query.length < 2) {
            searchResultsModel.clear();
            return;
        }
        var url = "https://geocoding-api.open-meteo.com/v1/search?name=" + 
                  encodeURIComponent(query) + "&count=5&language=tr&format=json";
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                searchResultsModel.clear();
                var res = JSON.parse(xhr.responseText);
                if (res.results) {
                    for (var i = 0; i < res.results.length; i++) {
                        var item = res.results[i];
                        var parts = [];
                        if (item.country) parts.push(item.country);
                        if (item.admin1) parts.push(item.admin1);
                        if (item.name && item.name !== item.admin1) parts.push(item.name);
                        searchResultsModel.append({
                            fullLabel: parts.join(", "),
                            lat: item.latitude,
                            lon: item.longitude
                        });
                    }
                }
            }
        };
        xhr.send();
    }

    TextField { id: latStorage; visible: false }
    TextField { id: lonStorage; visible: false }

    Kirigami.FormLayout {
        anchors.fill: parent

        ComboBox {
            id: layoutTypeBox
            Kirigami.FormData.label: "Hava Kartı Dizilimi:"
            model: [
                "Klasik (Küçük İkon, Ortalı)",
                "Modern (Sol Üst Büyük İkon & Sağ Derece)"
            ]
            currentIndex: plasmoid.configuration.weatherLayoutType
        }

        ColumnLayout {
            Kirigami.FormData.label: "Konum Arama:"
            Layout.fillWidth: true
            spacing: 4

            TextField {
                id: searchInput
                Layout.fillWidth: true
                placeholderText: "Şehir veya ilçe yazın..."
                onTextChanged: searchTimer.restart()
            }

            Timer {
                id: searchTimer
                interval: 400
                running: false
                repeat: false
                onTriggered: searchLocation(searchInput.text)
            }

            ListView {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(contentHeight, 130)
                model: searchResultsModel
                visible: count > 0
                clip: true

                delegate: ItemDelegate {
                    width: ListView.view.width
                    text: model.fullLabel
                    onClicked: {
                        selectedLocText.text = model.fullLabel;
                        latStorage.text = model.lat.toString();
                        lonStorage.text = model.lon.toString();
                        searchResultsModel.clear();
                        searchInput.text = "";
                    }
                }
            }

            Label {
                id: selectedLocText
                font.weight: Font.DemiBold
                color: Kirigami.Theme.highlightColor
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }

        ComboBox {
            id: fontBox
            Kirigami.FormData.label: "Yazı Tipi (Font):"
            model: Qt.fontFamilies()
            currentIndex: Math.max(0, model.indexOf(plasmoid.configuration.weatherFontFamily))
        }

        Slider {
            id: weatherScaleSlider
            Kirigami.FormData.label: "Yazı Boyut Ölçeği:"
            from: 0.5; to: 2.2; stepSize: 0.05
        }

        CheckBox {
            id: weatherIslandSwitch
            Kirigami.FormData.label: "Kapsül / Mini Ada:"
            text: "Kapsülü Aç"
        }

        CheckBox {
            id: weatherShadowSwitch
            visible: weatherIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Derinliği:"
            text: "Bağımsız Kapsül Gölgesi"
        }

        CheckBox {
            id: dynamicColorSwitch
            visible: weatherIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Rengi Modu:"
            text: "Hava Durumuna Göre Otomatik Renk"
        }

        component InteractiveColorPicker: RowLayout {
            property string labelText
            property color chosenColor: "#ffffff"
            spacing: 8
            Button { text: "🎨 Seç"; Layout.preferredWidth: 70; onClicked: dlg.open() }
            Rectangle { width: 28; height: 28; radius: 6; color: chosenColor; border.color: "#888888"; border.width: 1 }
            Label { text: chosenColor.toString(); font.family: "Monospace" }
            ColorDialog { id: dlg; title: labelText; selectedColor: chosenColor; onAccepted: chosenColor = selectedColor }
        }

        InteractiveColorPicker {
            id: capsuleColorPicker
            visible: weatherIslandSwitch.checked && !dynamicColorSwitch.checked
            Kirigami.FormData.label: "Özel Kapsül Rengi:"
            labelText: "Hava Durumu Kapsül Rengi"
            chosenColor: plasmoid.configuration.weatherCapsuleColor
        }

        Slider {
            id: capsuleOpacitySlider
            visible: weatherIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Saydamlığı:"
            from: 0.05; to: 1.0; stepSize: 0.05
        }

        Slider {
            id: capsuleRadiusSlider
            visible: weatherIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Yuvarlama:"
            from: 4; to: 50; stepSize: 2
        }

        InteractiveColorPicker {
            id: customTextPicker
            Kirigami.FormData.label: "Yazı Rengi:"
            labelText: "Hava Yazı Rengi"
            chosenColor: plasmoid.configuration.weatherCustomTextColor
        }

        SpinBox {
            id: intervalSpin
            Kirigami.FormData.label: "Güncelleme Sıklığı (Dk):"
            from: 5; to: 180; stepSize: 5
        }
    }
}