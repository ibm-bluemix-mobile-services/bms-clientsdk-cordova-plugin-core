var fs = require('fs');
var exec = require('child_process').exec;
var replace = require('./replacements');

module.exports = function(context) {

	var scriptsDir = "plugins/ibm-bms-core/scripts";

	if (directoryExists("platforms/ios")) {

		var stream = fs.createReadStream('plugins/ibm-bms-core/scripts/Cartfile').pipe(fs.createWriteStream('platforms/ios/Cartfile'));
		
		stream.on('finish', function() {

			var iosCmd = "sh plugins/ibm-bms-core/scripts/ios.sh";
			var carthageProcess = exec(iosCmd, function() {

				addFrameworksToXcode();

			}).stdout.pipe(process.stdout);
		});
	}

	if (directoryExists("platforms/android")) {
		
		var droidCmd = "sh plugins/ibm-bms-core/scripts/android.sh";
		var sedProcess = exec(droidCmd).stdout.pipe(process.stdout);
	}
};

/**
 * Check if directory exists
 * 
 * @param  {String} directory - The directory to check whether valid
 */
function directoryExists(directory) {
	try {
		fs.statSync(directory);
		return true;
	} 
	catch(e) {
		return false;
	}
}

/**
 * Add SDK frameworks from Carthage to Xcode projct
 */
function addFrameworksToXcode() {

	var cmd = "plutil -convert xml1 -o platforms/ios/*proj/project.pbxproj platforms/ios/*proj/project.pbxproj";

	exec(cmd, function() {

		var file = "platforms/ios/HelloCordova.xcodeproj/project.pbxproj";

		var message = "Removing all whitespace";
		replaceText(file, />\s*</g, "><", message, function(result) {

			console.log("Configuring Xcode to use SDK Frameworks");

			for (i = 0; i < replace.oldText.length; i++) {

				result = result.replace(replace.oldText[i], replace.newText[i]);
			}

			saveToFile(file, result);
		});
	});
}

/**
 * Replace text in a file
 * @param  {String} file - The specified file to edit
 * @param  {String} oldText - The old text to replace
 * @param  {String} newText - The new text to replace with
 * @param  {String} message - Debug message
 */
function replaceText(file, oldText, newText, message, callback) {

	fs.readFile(file, 'utf8', function(err, data) {

		var result = data.replace(oldText, newText);

		fs.writeFile(file, result, 'utf8', function(err) {

			if (err) {
				console.log("Error: " + err);
			}
			else {
				console.log(message);
				callback && callback(result);
			}
		});
	});
}

/**
 * Save text to file
 * @param  {String} file - Path to file
 * @param  {String} text - New text to save
 */
function saveToFile(file, text) {

	fs.writeFile(file, text, 'utf8', function(err) {

		if (err) {
			console.log("Error: " + err);
		}
	});
}

