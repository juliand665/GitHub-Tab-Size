import SafariServices
import UserDefault

final class SafariExtensionHandler: SFSafariExtensionHandler {
	@UserDefault("tabSize")
	private static var tabSize = 4
	
	public static func updateActiveTabSizes() {
		NSLog("updating active tab sizes")
		_tabSize.loadValue()
		forEachActivePage(updateTabSize(for:))
	}
	
	public static func updateAllTabSizes() {
		NSLog("updating all tab sizes")
		_tabSize.loadValue()
		forEachPage(updateTabSize(for:))
	}
	
	private static func updateTabSize(for page: SFSafariPage) {
		NSLog("sending tab size update to \(page)")
		page.dispatchMessageToScript(
			withName: "update tab size",
			userInfo: ["tabSize": tabSize]
		)
	}
	
	override func messageReceived(
		withName messageName: String,
		from page: SFSafariPage,
		userInfo: [String : Any]?
	) {
		NSLog("received message \(messageName)")
		switch messageName {
		case "ready":
			Self.updateTabSize(for: page)
		default:
			NSLog("unrecognized message received from extension: \(messageName)")
		}
	}
	
	override func toolbarItemClicked(in window: SFSafariWindow) {
		// This method will be called when your toolbar item is clicked.
		NSLog("The extension's toolbar item was clicked")
	}
	
	override func validateToolbarItem(
		in window: SFSafariWindow,
		validationHandler: @escaping ((Bool, String) -> Void)
	) {
		// This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
		validationHandler(true, "")
	}
	
	override func popoverViewController() -> SFSafariExtensionViewController {
		SafariExtensionViewController.shared
	}
	
	override func popoverDidClose(in window: SFSafariWindow) {
		Self.updateAllTabSizes()
	}
	
	private static func forEachActivePage(_ action: @escaping (SFSafariPage) -> Void) {
		SFSafariApplication.getAllWindows { windows in
			windows.forEach { window in
				window.getActiveTab { tab in
					tab?.getPagesWithCompletionHandler { pages in
						pages?.forEach(action)
					}
				}
			}
		}
	}
	
	private static func forEachPage(_ action: @escaping (SFSafariPage) -> Void) {
		SFSafariApplication.getAllWindows { windows in
			windows.forEach { window in
				window.getAllTabs { tabs in
					tabs.forEach { tab in
						tab.getPagesWithCompletionHandler { pages in
							pages?.forEach(action)
						}
					}
				}
			}
		}
	}
}
