import QtQuick
import qs.Commons
import qs.Ui

// Bar button: Pickle Rick's face / Incubator vat in the top bar.
// Left click opens the garage lab, middle click is a quick interaction/burp.
BarWidget {
  id: root
  moduleName: "maen.omapets"

  readonly property var petService: bar && bar.shell
    ? bar.shell.serviceFor(moduleName)
    : null

  // Panel lifecycle forwarding, required by the bar's popout switching.
  readonly property bool opened: panelLoader.item
    ? panelLoader.item.opened === true
    : false
  readonly property bool popoutSwitchClosing: panelLoader.item
    ? panelLoader.item.popoutSwitchClosing === true
    : false
  readonly property real openPanelIndicatorWidth: content.implicitWidth
  readonly property real openPanelIndicatorHeight: content.implicitHeight

  readonly property bool serviceReady: !!petService && petService.initialized === true

  function injectPanel() {
    var target = panelLoader.item
    if (!target) return
    if ("bar" in target) target.bar = root.bar
    if ("settings" in target) target.settings = root.settings
    if ("anchorItem" in target) target.anchorItem = button
    if ("hostWidget" in target) target.hostWidget = root
    if ("petService" in target) target.petService = root.petService
  }

  function open() { if (panelLoader.item) panelLoader.item.open() }
  function close() { if (panelLoader.item) panelLoader.item.close() }
  function toggle() { if (panelLoader.item) panelLoader.item.toggle() }
  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onBarChanged: Qt.callLater(injectPanel)
  onSettingsChanged: Qt.callLater(injectPanel)
  onPetServiceChanged: Qt.callLater(injectPanel)
  Component.onCompleted: Qt.callLater(injectPanel)

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: root.injectPanel()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    labelVisible: false
    hasVisualContent: true
    dimmed: !root.serviceReady
    tooltipText: root.serviceReady ? root.petService.moodLabel : "OmaPets (Pickle Rick)"
    fixedWidth: root.vertical ? -1 : Math.round(content.implicitWidth + scaledHorizontalMargin * 2)
    fixedHeight: root.vertical ? Math.round(content.implicitHeight + scaledVerticalPadding * 2) : -1

    onPressed: function(buttonCode) {
      if (buttonCode === Qt.LeftButton) root.toggle()
      else if (buttonCode === Qt.MiddleButton && root.serviceReady) root.petService.petThePet()
    }

    Item {
      id: content
      anchors.centerIn: parent
      implicitWidth: Style.bar.iconCanvas
      implicitHeight: Style.bar.iconCanvas

      PetSprite {
        anchors.fill: parent
        form: root.serviceReady ? root.petService.form : "pickle"
        anim: root.serviceReady ? root.petService.stateAnim : "idle"
        colorize: false
        frameMs: root.serviceReady
          && root.petService.mood !== "happy" && root.petService.mood !== "incubator"
          && root.petService.mood !== "sleeping"
          ? 350 : 900
        tint: button.foreground
      }
    }
  }
}
