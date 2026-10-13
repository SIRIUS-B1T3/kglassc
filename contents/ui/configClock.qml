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
    property alias cfg_clockStyle: clockTypeBox.currentIndex
    property alias cfg_analogStyle: analogTypeBox.currentIndex
    property alias cfg_clockFontFamily: fontBox.currentText
    property alias cfg_clockFontScale: clockScaleSlider.value
    property alias cfg_clockIsland: clockIslandSwitch.checked
    property alias cfg_clockShadow: clockShadowSwitch.checked
    property alias cfg_clockCapsuleColor: capsuleColorPicker.chosenColor
    property alias cfg_clockCapsuleOpacity: capsuleOpacitySlider.value
    property alias cfg_clockCapsuleRadius: capsuleRadiusSlider.value
    property alias cfg_clockCustomTextColor: customTextPicker.chosenColor

    // Koordinat ve Boyut Bağlayıcıları (Enjeksiyon Hatalarını Önler)
    property alias cfg_clockCol: clockColStorage.value
    property alias cfg_clockRow: clockRowStorage.value
    property alias cfg_clockSpanX: clockSpanXStorage.value
    property alias cfg_clockSpanY: clockSpanYStorage.value

    SpinBox { id: clockColStorage; visible: false; from: 0; to: 12 }
    SpinBox { id: clockRowStorage; visible: false; from: 0; to: 8 }
    SpinBox { id: clockSpanXStorage; visible: false; from: 1; to: 12 }
    SpinBox { id: clockSpanYStorage; visible: false; from: 1; to: 8 }

    Kirigami.FormLayout {
        anchors.fill: parent

        ComboBox {
            id: clockTypeBox
            Kirigami.FormData.label: "Saat Tarzı:"
            model: ["Modern Dijital", "Analog"]
        }

        ComboBox {
            id: analogTypeBox
            visible: clockTypeBox.currentIndex === 1
            Kirigami.FormData.label: "Kadran Stili:"
            model: ["1: Minimal", "2: Noktalı", "3: Noktalı + 12,3,6,9", "4: Çizgili + Rakamlar"]
        }

        ComboBox {
            id: fontBox
            Kirigami.FormData.label: "Yazı Tipi (Font):"
            model: Qt.fontFamilies()
            currentIndex: Math.max(0, model.indexOf(plasmoid.configuration.clockFontFamily))
        }

        Slider {
            id: clockScaleSlider
            Kirigami.FormData.label: "Yazı Boyut Ölçeği:"
            from: 0.5; to: 2.5; stepSize: 0.05
        }

        CheckBox {
            id: clockIslandSwitch
            Kirigami.FormData.label: "Kapsül / Mini Ada:"
            text: "Kapsülü Aç"
        }

        CheckBox {
            id: clockShadowSwitch
            visible: clockIslandSwitch.checked
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
            visible: clockIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Rengi:"
            labelText: "Saat Kapsül Rengi"
            chosenColor: plasmoid.configuration.clockCapsuleColor
        }

        Slider {
            id: capsuleOpacitySlider
            visible: clockIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Saydamlığı:"
            from: 0.05; to: 1.0; stepSize: 0.05
        }

        Slider {
            id: capsuleRadiusSlider
            visible: clockIslandSwitch.checked
            Kirigami.FormData.label: "Kapsül Yuvarlama:"
            from: 4; to: 50; stepSize: 2
        }

        InteractiveColorPicker {
            id: customTextPicker
            Kirigami.FormData.label: "Yazı Rengi:"
            labelText: "Saat Yazı Rengi"
            chosenColor: plasmoid.configuration.clockCustomTextColor
        }
    }
}