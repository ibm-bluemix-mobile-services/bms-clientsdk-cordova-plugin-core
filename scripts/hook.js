var fs = require('fs');
var exec = require('child_process').exec;
const spawn = require('child_process').spawn;

module.exports = function(context) {

	if (directoryExists("platforms/ios")) {

		var carthage = 'github "ibm-bluemix-mobile-services/bms-clientsdk-swift-core"\n\n';
		carthage += 'github "ibm-bluemix-mobile-services/bms-clientsdk-swift-analytics"\n\n';
		carthage += 'github "ibm-bluemix-mobile-services/bms-clientsdk-swift-security"'

		fs.writeFile('platforms/ios/Cartfile', carthage, function() {
			
			var carthageCmd = 'echo Fetching and building frameworks for ios.; cd platforms/ios; carthage update --no-use-binaries; cd ../../;';
			var carthageProcess = exec(carthageCmd).stdout.pipe(process.stdout);
		});
	}

	if (directoryExists("platforms/android")) {
		
		console.log("Updating AndroidManifest.xml to minSdkVersion=15");
		var sedCmd = "cd platforms/android; sed -i '' 's/android:minSdkVersion=\"14\"/android:minSdkVersion=\"15\"/' AndroidManifest.xml; cd ../../";
		var sedProcess = exec(sedCmd);
	}
};

function directoryExists(directory) {
	try {
		fs.statSync(directory);
		return true;
	} 
	catch(e) {
		return false;
	}
}