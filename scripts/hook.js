var fs = require('fs');
var exec = require('child_process').exec;
const spawn = require('child_process').spawn;

module.exports = function(context) {

	var scriptsDir = "plugins/ibm-bms-core/scripts";

	if (directoryExists("platforms/ios")) {

		var stream = fs.createReadStream('plugins/ibm-bms-core/scripts/Cartfile').pipe(fs.createWriteStream('platforms/ios/Cartfile'));
		
		stream.on('finish', function() {

			var iosCmd = "sh plugins/ibm-bms-core/scripts/ios.sh";
			var carthageProcess = exec(iosCmd).stdout.pipe(process.stdout);
		});
	}

	if (directoryExists("platforms/android")) {
		
		var droidCmd = "sh plugins/ibm-bms-core/scripts/android.sh";
		var sedProcess = exec(droidCmd).stdout.pipe(process.stdout);
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