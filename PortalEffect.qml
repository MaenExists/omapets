import QtQuick

// Rick & Morty green swirling portal effect.
// Features pulsating radioactive neon rim, counter-rotating spiral arms,
// glowing white-hot core, and organic particle fluctuations.
Item {
  id: root

  property bool active: false
  property real portalScale: 0

  width: 130
  height: 170

  opacity: portalScale > 0.01 ? 1 : 0
  visible: opacity > 0

  signal opened()
  signal closed()

  function openPortal() {
    active = true
    openAnim.restart()
  }

  function closePortal() {
    closeAnim.restart()
  }

  function burst(holdMs) {
    active = true
    burstTimer.interval = holdMs || 1200
    burstTimer.restart()
    openAnim.restart()
  }

  Timer {
    id: burstTimer
    repeat: false
    onTriggered: root.closePortal()
  }

  ParallelAnimation {
    id: openAnim
    NumberAnimation {
      target: root
      property: "portalScale"
      from: 0.0
      to: 1.0
      duration: 320
      easing.type: Easing.OutBack
      easing.overshoot: 1.3
    }
    onFinished: root.opened()
  }

  ParallelAnimation {
    id: closeAnim
    NumberAnimation {
      target: root
      property: "portalScale"
      from: root.portalScale
      to: 0.0
      duration: 260
      easing.type: Easing.InBack
      easing.overshoot: 1.2
    }
    onFinished: {
      root.active = false
      root.closed()
    }
  }

  Item {
    id: portalVisual
    anchors.centerIn: parent
    width: root.width
    height: root.height
    scale: root.portalScale

    // Glowing pulsating outer corona
    Image {
      id: bg
      anchors.fill: parent
      source: Qt.resolvedUrl("assets/portal_bg.png")
      smooth: true

      SequentialAnimation on opacity {
        loops: Animation.Infinite
        running: root.active
        NumberAnimation { from: 0.82; to: 1.0; duration: 380; easing.type: Easing.InOutQuad }
        NumberAnimation { from: 1.0; to: 0.82; duration: 380; easing.type: Easing.InOutQuad }
      }
    }

    // Fast-spinning main swirl vortex
    Image {
      id: swirl
      anchors.centerIn: parent
      width: Math.min(parent.width, parent.height) * 0.94
      height: width
      source: Qt.resolvedUrl("assets/portal_swirl.png")
      smooth: true

      RotationAnimation on rotation {
        loops: Animation.Infinite
        running: root.active
        from: 0
        to: 360
        duration: 900
      }
    }

    // Counter-rotating secondary swirl layer for dimensional hypnotic depth
    Image {
      id: swirlCounter
      anchors.centerIn: parent
      width: Math.min(parent.width, parent.height) * 0.78
      height: width
      source: Qt.resolvedUrl("assets/portal_swirl.png")
      smooth: true
      opacity: 0.65

      RotationAnimation on rotation {
        loops: Animation.Infinite
        running: root.active
        from: 360
        to: 0
        duration: 1400
      }
    }

    // Bright yellow-white hot core
    Image {
      id: core
      anchors.fill: parent
      source: Qt.resolvedUrl("assets/portal_core.png")
      smooth: true

      SequentialAnimation on scale {
        loops: Animation.Infinite
        running: root.active
        NumberAnimation { from: 0.92; to: 1.12; duration: 280; easing.type: Easing.InOutSine }
        NumberAnimation { from: 1.12; to: 0.92; duration: 280; easing.type: Easing.InOutSine }
      }
    }
  }
}
