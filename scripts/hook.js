var fs = require('fs');
var exec = require('child_process').exec;
var pbx = require('./pbxSettings');
var spawn = require('child_process').spawn;

module.exports = function(context) {

	if (context["opts"]["cordova"]["platforms"].indexOf("ios") != -1) {

		var stream = fs.createReadStream('plugins/ibm-bms-core/scripts/Cartfile').pipe(fs.createWriteStream('platforms/ios/Cartfile'));
		
		stream.on('finish', function() {

			var iosCmd = "sh plugins/ibm-bms-core/scripts/ios.sh";
			var carthageProcess = exec(iosCmd, function() {

				addFrameworksToXcode();

			}).stdout.pipe(process.stdout);
		});
	}

	if (context["opts"]["cordova"]["platforms"].indexOf("android") != -1) {
		
		var droidCmd = "sh plugins/ibm-bms-core/scripts/android.sh";
		var sedProcess = exec(droidCmd).stdout.pipe(process.stdout);
	}
};

/**
 * Add SDK frameworks from Carthage to Xcode projct
 */
function addFrameworksToXcode() {

	var xcodeproj;

	fs.readdir("platforms/ios", function(err, files) {
		
		for (i in files) {
			if (files[i].includes(".xcodeproj")) {
				xcodeproj = files[i];
			}
		};

		var cmd = "plutil -convert xml1 -o platforms/ios/*proj/project.pbxproj platforms/ios/*proj/project.pbxproj";

		var fmProcess = exec(cmd, function() {

			var file = "platforms/ios/" + xcodeproj + "/project.pbxproj";

			replaceText(file, />\s*</g, "><", function(result) {

				for (i = 0; i < pbx.oldText.length; i++) {
					result = result.replace(pbx.oldText[i], pbx.newText[i]);
				}

				saveToFile(file, result);
			});
		});
	})
}

/**
 * Replace text in a file
 * @param  {String} file - The specified file to edit
 * @param  {String} oldText - The old text to replace
 * @param  {String} newText - The new text to replace with
 * @param  {String} message - Debug message
 */
function replaceText(file, oldText, newText, callback) {

	fs.readFile(file, 'utf8', function(err, data) {

		var result = data.replace(oldText, newText);

		fs.writeFile(file, result, 'utf8', function(err) {

			if (err) {
				console.log("Error: " + err);
			}
			else {
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

