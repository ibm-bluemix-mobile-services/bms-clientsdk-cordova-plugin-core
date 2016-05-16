var fs = require('fs');
var exec = require('child_process').exec;

module.exports = function(context) {
	
	var carthage = 'github "ibm-bluemix-mobile-services/bms-clientsdk-swift-core"\n\n';
	carthage += 'github "ibm-bluemix-mobile-services/bms-clientsdk-swift-analytics"\n\n';
	carthage += 'github "ibm-bluemix-mobile-services/bms-clientsdk-swift-security"'

	fs.writeFile('platforms/ios/Cartfile', carthage, function() {
		var cmd = 'echo Fetching and building frameworks for ios.; cd platforms/ios; carthage update --no-use-binaries; cd ../../;';
		var carthageProcess = exec(cmd).stdout.pipe(process.stdout);
	});
};