import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    minSize = NSSize(width: 800, height: 600)
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    if let screen = NSScreen.main?.visibleFrame {
      let x = screen.midX - windowFrame.width / 2
      let y = screen.midY - windowFrame.height / 2
      setFrame(NSRect(x: x, y: y, width: windowFrame.width, height: windowFrame.height), display: true)
    } else {
      setFrame(windowFrame, display: true)
    }
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
