import QtQuick
import QtQuick.Effects

// Animated pixel-art sprite renderer.
// Supports both full-color pixel art (e.g. Pickle Rick, Incubator Vat)
// and 1-bit dynamic theme tinting via MultiEffect.
Item {
  id: root

  property string form: "pickle"
  property string anim: "idle"
  // What to try when anim's frames are missing (e.g. "walk" for a climb).
  property string fallbackAnim: "idle"
  property int frameMs: 500
  property bool playing: true
  property color tint: "white"
  property bool colorize: false
  property bool mirrored: false

  property int frame: 0
  // The animation actually shown once fallbacks are applied.
  property string resolvedAnim: anim

  function restart() {
    resolvedAnim = anim
    frame = 0
  }

  function applyFallback() {
    if (image.status !== Image.Error) return
    if (resolvedAnim !== fallbackAnim) resolvedAnim = fallbackAnim
    else if (resolvedAnim !== "idle") resolvedAnim = "idle"
  }

  onAnimChanged: restart()
  onFormChanged: restart()

  Image {
    id: image
    anchors.fill: parent
    source: Qt.resolvedUrl("assets/sprites/" + root.form + "_" + root.resolvedAnim
      + "_" + (root.frame === 0 ? "a" : "b") + ".png")
    // Nearest-neighbour scaling keeps the pixels crisp.
    smooth: false
    mipmap: false
    fillMode: Image.PreserveAspectFit
    mirror: root.mirrored
    visible: !root.colorize

    // Deferred: writing resolvedAnim during the source evaluation that
    // triggered the status change would be a binding loop.
    onStatusChanged: if (status === Image.Error) Qt.callLater(root.applyFallback)
  }

  MultiEffect {
    anchors.fill: image
    source: image
    visible: root.colorize
    colorization: 1
    colorizationColor: root.tint
  }

  Timer {
    interval: root.frameMs
    running: root.playing && root.visible
    repeat: true
    onTriggered: root.frame = root.frame === 0 ? 1 : 0
  }
}
