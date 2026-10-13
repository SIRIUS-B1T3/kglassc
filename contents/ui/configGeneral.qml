import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: root

    property alias cfg_editMode: editModeSwitch.checked
    property alias cfg_cardUseGradient: cardUseGradientSwitch.checked
    property alias cfg_cardColor: cardColorBtn.selectedColor
    property alias cfg_cardColor2: cardColor2Btn.selectedColor
    property alias cfg_cardGradientAngle: gradientAngleCombo.currentIndex
    property alias cfg_cardOpacity: cardOpacitySlider.value
    property alias cfg_cardRadius: cardRadiusSlider.value
    property alias cfg_cardBorderWidth: cardBorderWidthSlider.value
    property alias cfg_cardBorderColor: cardBorderColorBtn.selectedColor
    property alias cfg_cardShadow: cardShadowSwitch.checked
    property alias cfg_language: languageCombo.currentValue
    property alias cfg_updateInterval: updateIntervalSpin.value

    ColorDialog {
        id: colorDialog1
        title: i18n("Kart Rengi Seç")
        selectedColor: cardColorBtn.selectedColor
        onAccepted: cardColorBtn.selectedColor = selectedColor
    }

    ColorDialog {
        id: colorDialog2
        title: i18n("İkinci Renk (Gradyan) Seç")
        selectedColor: cardColor2Btn.selectedColor
        onAccepted: cardColor2Btn.selectedColor = selectedColor
    }

    ColorDialog {
        id: borderDialog
        title: i18n("Kenarlık Rengi Seç")
        selectedColor: cardBorderColorBtn.selectedColor
        onAccepted: cardBorderColorBtn.selectedColor = selectedColor
    }

    Kirigami.FormLayout {
        id: formLayout

        // 1. DÜZENLEME KİPİ
        QQC2.CheckBox {
            id: editModeSwitch
            Kirigami.FormData.label: i18n("Düzenleme:")
            text: i18n("Serbest Blok Düzenleme Kipi (Boyutlandırma ve Taşıma)")
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Ana Kart Tasarımı")
        }

        // 2. RENK VE GRADIENT
        QQC2.CheckBox {
            id: cardUseGradientSwitch
            Kirigami.FormData.label: i18n("Renk Geçişi:")
            text: i18n("Gradyan (Gradient) Kullan")
        }

        RowLayout {
            Kirigami.FormData.label: cardUseGradientSwitch.checked ? i18n("1. Renk (Başlangıç):") : i18n("Kart Rengi:")
            spacing: 8

            Rectangle {
                width: 32; height: 32; radius: 4
                color: cardColorBtn.selectedColor
                border.color: Qt.rgba(0, 0, 0, 0.3); border.width: 1
            }

            QQC2.Button {
                id: cardColorBtn
                property color selectedColor: Plasmoid.configuration.cardColor || "#1e293b"
                text: i18n("Renk Seç...")
                onClicked: {
                    colorDialog1.selectedColor = selectedColor
                    colorDialog1.open()
                }
            }
        }

        RowLayout {
            visible: cardUseGradientSwitch.checked
            Kirigami.FormData.label: i18n("2. Renk (Bitiş):")
            spacing: 8

            Rectangle {
                width: 32; height: 32; radius: 4
                color: cardColor2Btn.selectedColor
                border.color: Qt.rgba(0, 0, 0, 0.3); border.width: 1
            }

            QQC2.Button {
                id: cardColor2Btn
                property color selectedColor: Plasmoid.configuration.cardColor2 || "#0f172a"
                text: i18n("Renk Seç...")
                onClicked: {
                    colorDialog2.selectedColor = selectedColor
                    colorDialog2.open()
                }
            }
        }

        QQC2.ComboBox {
            id: gradientAngleCombo
            visible: cardUseGradientSwitch.checked
            Kirigami.FormData.label: i18n("Geçiş Yönü:")
            textRole: "text"
            valueRole: "value"
            model: [
                { "text": i18n("Dikey (Yukarıdan Aşağıya)"), "value": 0 },
                { "text": i18n("Yatay (Soldan Sağa)"), "value": 1 }
            ]
        }

        // 3. OPAKLIK VE KÖŞELER
        RowLayout {
            Kirigami.FormData.label: i18n("Opaklık:")
            QQC2.Slider {
                id: cardOpacitySlider
                from: 0.05
                to: 1.0
                stepSize: 0.05
            }
            QQC2.Label {
                text: Math.round(cardOpacitySlider.value * 100) + "%"
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Köşe Yuvarlaklığı:")
            QQC2.Slider {
                id: cardRadiusSlider
                from: 0
                to: 48
                stepSize: 2
            }
            QQC2.Label {
                text: Math.round(cardRadiusSlider.value) + " px"
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Kenarlık ve Gölge")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Kenarlık Rengi:")
            spacing: 8

            Rectangle {
                width: 32; height: 32; radius: 4
                color: cardBorderColorBtn.selectedColor
                border.color: Qt.rgba(0, 0, 0, 0.3); border.width: 1
            }

            QQC2.Button {
                id: cardBorderColorBtn
                property color selectedColor: Plasmoid.configuration.cardBorderColor || "#ffffff"
                text: i18n("Renk Seç...")
                onClicked: {
                    borderDialog.selectedColor = selectedColor
                    borderDialog.open()
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Kenarlık Kalınlığı:")
            QQC2.Slider {
                id: cardBorderWidthSlider
                from: 0.0
                to: 6.0
                stepSize: 0.5
            }
            QQC2.Label {
                text: cardBorderWidthSlider.value.toFixed(1) + " px"
            }
        }

        QQC2.CheckBox {
            id: cardShadowSwitch
            Kirigami.FormData.label: i18n("Gölge:")
            text: i18n("Kart Altında Yumuşak Gölge Göster")
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Sistem")
        }

        QQC2.ComboBox {
            id: languageCombo
            Kirigami.FormData.label: i18n("Dil:")
            textRole: "text"
            valueRole: "value"
            model: [
                { "text": i18n("Türkçe"), "value": "tr" },
                { "text": i18n("English"), "value": "en" }
            ]
        }

        QQC2.SpinBox {
            id: updateIntervalSpin
            Kirigami.FormData.label: i18n("Yenileme (dk):")
            from: 5
            to: 180
            stepSize: 5
        }
    }
}