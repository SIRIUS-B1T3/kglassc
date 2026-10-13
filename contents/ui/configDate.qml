import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Item {
    id: rootItem
    implicitWidth: 460
    implicitHeight: 460

    // KConfigXT Bağlantıları
    property alias cfg_dateFormat: dateFormatBox.currentIndex
    property alias cfg_dateFontFamily: fontBox.currentText
    property alias cfg_dateFontScale: dateScaleSlider.value
    property alias cfg_dateIsland: dateIslandSwitch.checked
    property alias cfg_dateShadow: dateShadowSwitch.checked
    property alias cfg_dateCapsuleColor: capsuleColorPicker.chosenColor
    property alias cfg_dateCapsuleOpacity: capsuleOpacitySlider.value
    property alias cfg_dateCapsuleRadius: capsuleRadiusSlider.value
    property alias cfg_dateCustomTextColor: customTextPicker.chosenColor

    // Koordinat ve Boyut Bağlayıcıları (Enjeksiyon Hatalarını Önler)
    property alias cfg_dateCol: dateColStorage.value
    property alias cfg_dateRow: dateRowStorage.value
    property alias cfg_dateSpanX: dateSpanXStorage.value
    property alias cfg_dateSpanY: dateSpanYStorage.value

    SpinBox { id: dateColStorage; visible: false; from: 0; to: 12 }
    SpinBox { id: dateRowStorage; visible: false; from: 0; to: 8 }
    SpinBox { id: dateSpanXStorage; visible: false; from: 1; to: 12 }
    SpinBox { id: dateSpanYStorage; visible: false; from: 1; to: 8 }

    Kirigami.FormLayout {
        anchors.fill: parent

        ComboBox {
            id: dateFormatBox
            Kirigami.FormData.label: "Tarih Formatı:"
            model: [
                "Çarşamba, 7 Ekim",
                "7 Ekim Çarşamba",
                "07.10.2026",
                "7 Eki, Çar",
                "Çarşamba / 7 Ekim (İki Satır)"
            ]
        }

        ComboBox {
            id: fontBox
            Kirigami.FormData.label: "Yazı Tipi (Font):"
            model: Qt.fontFamilies()
            currentIndex: Math.max(0, model.indexOf(plasmoid.configuration.dateFontFamily))
        }

        Slider {
            id: dateScaleSlider
            Kirigami.FormData.label: "Yazı Boyut Ölçeği:"
            from: 0.5; to: 2.5; stepSize: 0.05
        }

        CheckBox {
            id: dateIslandSwitch
            Kirigami.FormData.label: "Kapsül / Mini Ada:"
            text: "Kapsülü Aç"
        }

        CheckBox {
            id: dateShadowSwitch
            visible: dateIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Derinliği:"
            text: "Bağımsız Kapsül Gölgesi"
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
            visible: dateIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Rengi:"
            labelText: "Tarih Kapsül Rengi"
            chosenColor: plasmoid.configuration.dateCapsuleColor
        }

        Slider {
            id: capsuleOpacitySlider
            visible: dateIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Saydamlığı:"
            from: 0.05; to: 1.0; stepSize: 0.05
        }

        Slider {
            id: capsuleRadiusSlider
            visible: dateIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Yuvarlama:"
            from: 4; to: 50; stepSize: 2
        }

        InteractiveColorPicker {
            id: customTextPicker
            Kirigami.FormData.label: "Yazı Rengi:"
            labelText: "Tarih Yazı Rengi"
            chosenColor: plasmoid.configuration.dateCustomTextColor
        }
    }
}