import SafariServices
import HandyOperators
import UserDefault

final class SafariExtensionViewController: SFSafariExtensionViewController {
	static let shared = SafariExtensionViewController()
	
	@IBOutlet private var tabSizeLabel: NSTextField!
	@IBOutlet private var tabSizeSlider: NSSlider!
	
	@IBAction private func tabSizeChanged(_ sender: Any) {
		DispatchQueue.main.async {
			SafariExtensionHandler.updateActiveTabSizes()
		}
	}
	
	@UserDefault("tabSize")
	@objc public dynamic var tabSize = 4
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		for control in [tabSizeSlider!, tabSizeLabel!] {
			control.bind(
				.value,
				to: self, withKeyPath: #keyPath(tabSize)
			)
		}
	}
}
