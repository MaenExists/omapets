import QtQuick
import QtQuick.Effects

// Animated sprite renderer.
// Supports multi-frame fluid animation cycles (Codex Pet Pickle Rick)
// as well as classic 2-frame retro pixel art with 1-bit dynamic theme tinting.
Item {
  id: root

  property string form: "pickle"
  property string anim: "idle"
  // What to try when anim's frames are missing (e.g. "walk" for a climb).
  property string fallbackAnim: "idle"
  property int frameMs: 0
  property bool playing: true
  property color tint: "white"
  property bool colorize: false
  property bool mirrored: false

  property int frame: 0
  // The animation actually shown once fallbacks are applied.
  property string resolvedAnim: anim

  readonly property var pickleAnimConfig: ({
    idle:      { count: 7, interval: 140 },
    walk:      { count: 8, interval: 100 },
    walk_left: { count: 8, interval: 100 },
    climb:     { count: 4, interval: 130 },
    jump:      { count: 5, interval: 100 },
    fall:      { count: 4, interval: 120 },
    stunned:   { count: 8, interval: 140 },
    eat:       { count: 6, interval: 140 },
    wash:      { count: 6, interval: 140 },
    sleep:     { count: 4, interval: 400 }
  })

  readonly property bool useWalkLeft: root.form === "pickle" && root.resolvedAnim === "walk" && root.mirrored
  readonly property string actualAnimName: useWalkLeft ? "walk_left" : root.resolvedAnim
  readonly property bool actualMirror: useWalkLeft ? false : root.mirrored

  readonly property var currentAnimConfig: {
    if (form === "pickle" && pickleAnimConfig[actualAnimName]) {
      return pickleAnimConfig[actualAnimName]
    }
    return { count: 2, interval: frameMs > 0 ? frameMs : 500 }
  }

  readonly property int frameCount: currentAnimConfig.count || 2
  readonly property int effectiveInterval: frameMs > 0 ? frameMs : (currentAnimConfig.interval || 500)

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
    source: {
      if (root.frameCount > 2) {
        return Qt.resolvedUrl("assets/sprites/" + root.form + "_" + root.actualAnimName
          + "_" + root.frame + ".png")
      }
      return Qt.resolvedUrl("assets/sprites/" + root.form + "_" + root.actualAnimName
        + "_" + (root.frame === 0 ? "a" : "b") + ".png")
    }
    // High-resolution rendered sprites use bilinear smoothing and mipmapping;
    // retro pixel art uses nearest-neighbour to preserve sharp pixels.
    smooth: root.form === "pickle"
    mipmap: root.form === "pickle"
    fillMode: Image.PreserveAspectFit
    mirror: root.actualMirror
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
    interval: root.effectiveInterval
    running: root.playing && root.visible
    repeat: true
    onTriggered: {
      if (root.frameCount <= 1) return
      root.frame = (root.frame + 1) % root.frameCount
    }
  }
}

