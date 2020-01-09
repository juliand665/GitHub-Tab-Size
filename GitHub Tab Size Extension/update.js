let rawRule = `
.tab-size[data-tab-size='2'],
.tab-size[data-tab-size='4'],
.tab-size[data-tab-size='8'],
.inline-review-comment,
.gist table.lines,
table.diff-table,
.markdown-body pre,
body > pre {}
`;
// contents changed dynamically

let rule;
function updateTabSize(tabSize) {
	console.log('updating tab size to ' + tabSize);
	document.body.append('tab size updated to ' + tabSize);
	if (rule == undefined) {
		let styleElement = document.createElement('style');
		document.head.appendChild(styleElement);
		let styleSheet = styleElement.sheet;
		
		styleSheet.insertRule(rawRule, 0);
		rule = styleSheet.cssRules[0];
	}
	
	rule.style = `tab-size: ${tabSize} !important`;
}

function handleMessage(event) {
	console.log(event.name);
	switch (event.name) {
		case 'update tab size':
			updateTabSize(event.message.tabSize);
			break;
		default:
			console.log('unrecognized message: ' + event.name);
			break;
	}
}

function setUp() {
	safari.self.addEventListener('message', handleMessage);
	safari.extension.dispatchMessage('ready');
	console.log('set up');
}

if (document.body == null) {
	document.addEventListener('DOMContentLoaded', setUp);
} else {
	setUp();
}
