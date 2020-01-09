import Cocoa
import SafariServices.SFSafariApplication

final class ViewController: NSViewController {
	@IBAction func openSafariExtensionPreferences(_ sender: Any?) {
		SFSafariApplication.showPreferencesForExtension(
			withIdentifier: "juliand665.GitHub-Tab-Size-Extension"
		) { error in
			if let error = error {
				DispatchQueue.main.async {
					NSApp.presentError(error)
				}
			}
		}
	}
}

final class Window: NSWindow {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		isMovableByWindowBackground = true
	}
}

final class PassThroughImageView: NSImageView {
	override var mouseDownCanMoveWindow: Bool { true }
}
