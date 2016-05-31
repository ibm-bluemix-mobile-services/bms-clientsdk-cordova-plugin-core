var oldText = [];
var newText = [];

// TODO: use variables for hex IDs

oldText.push("</array><key>isa</key><string>PBXFrameworksBuildPhase</string>");
newText.push("<string>FE997D931CF7802600F4EDDB</string><string>FE997D941CF7802600F4EDDB</string><string>FE997D951CF7802600F4EDDB</string></array><key>isa</key><string>PBXFrameworksBuildPhase</string>");

oldText.push("<key>COPY_PHASE_STRIP</key><string>NO</string>");
newText.push("<key>COPY_PHASE_STRIP</key><string>NO</string><key>FRAMEWORK_SEARCH_PATHS</key><array><string>$(inherited)</string><string>$(PROJECT_DIR)/Carthage/Build/iOS</string></array>");

oldText.push("<key>COPY_PHASE_STRIP</key><string>YES</string>");
newText.push("<key>COPY_PHASE_STRIP</key><string>YES</string><key>FRAMEWORK_SEARCH_PATHS</key><array><string>$(inherited)</string><string>$(PROJECT_DIR)/Carthage/Build/iOS</string></array>");

oldText.push("<key>LastUpgradeCheck</key><string>510</string>");
newText.push("<key>LastSwiftUpdateCheck</key><string>0720</string><key>LastUpgradeCheck</key><string>510</string>");

oldText.push("<string>PBXProject</string>");
newText.push("<string>PBXProject</string><key>knownRegions</key><array><string>en</string></array>");

oldText.push("<array/><key>isa</key><string>PBXGroup</string><key>name</key><string>Frameworks</string>");
newText.push("<array><string>FE997D901CF7802600F4EDDB</string><string>FE997D911CF7802600F4EDDB</string><string>FE997D921CF7802600F4EDDB</string></array><key>isa</key><string>PBXGroup</string><key>name</key><string>Frameworks</string>");

oldText.push("<key>name</key><string>Bridging-Header.h</string>");
newText.push("");

oldText.push("<string>ibm-bms-core/CDVBMSLogger.swift</string><key>sourceTree</key><string>&lt;group&gt;</string></dict>");
newText.push("<string>ibm-bms-core/CDVBMSLogger.swift</string><key>sourceTree</key><string>&lt;group&gt;</string></dict>\
		<key>FE997D901CF7802600F4EDDB</key>\
		<dict>\
			<key>isa</key>\
			<string>PBXFileReference</string>\
			<key>lastKnownFileType</key>\
			<string>wrapper.framework</string>\
			<key>name</key>\
			<string>BMSAnalytics.framework</string>\
			<key>path</key>\
			<string>Carthage/Build/iOS/BMSAnalytics.framework</string>\
			<key>sourceTree</key>\
			<string>&lt;group&gt;</string>\
		</dict>\
		<key>FE997D911CF7802600F4EDDB</key>\
		<dict>\
			<key>isa</key>\
			<string>PBXFileReference</string>\
			<key>lastKnownFileType</key>\
			<string>wrapper.framework</string>\
			<key>name</key>\
			<string>BMSAnalyticsAPI.framework</string>\
			<key>path</key>\
			<string>Carthage/Build/iOS/BMSAnalyticsAPI.framework</string>\
			<key>sourceTree</key>\
			<string>&lt;group&gt;</string>\
		</dict>\
		<key>FE997D921CF7802600F4EDDB</key>\
		<dict>\
			<key>isa</key>\
			<string>PBXFileReference</string>\
			<key>lastKnownFileType</key>\
			<string>wrapper.framework</string>\
			<key>name</key>\
			<string>BMSCore.framework</string>\
			<key>path</key>\
			<string>Carthage/Build/iOS/BMSCore.framework</string>\
			<key>sourceTree</key>\
			<string>&lt;group&gt;</string>\
		</dict>\
		<key>FE997D931CF7802600F4EDDB</key>\
		<dict>\
			<key>fileRef</key>\
			<string>FE997D901CF7802600F4EDDB</string>\
			<key>isa</key>\
			<string>PBXBuildFile</string>\
		</dict>\
		<key>FE997D941CF7802600F4EDDB</key>\
		<dict>\
			<key>fileRef</key>\
			<string>FE997D911CF7802600F4EDDB</string>\
			<key>isa</key>\
			<string>PBXBuildFile</string>\
		</dict>\
		<key>FE997D951CF7802600F4EDDB</key>\
		<dict>\
			<key>fileRef</key>\
			<string>FE997D921CF7802600F4EDDB</string>\
			<key>isa</key>\
			<string>PBXBuildFile</string>\
		</dict>\
		<key>FE997D981CF7978500F4EDDB</key>\
		<dict>\
			<key>buildActionMask</key>\
			<string>2147483647</string>\
			<key>files</key>\
			<array/>\
			<key>inputPaths</key>\
			<array>\
				<string>$(SRCROOT)/Carthage/Build/iOS/BMSCore.framework</string>\
				<string>$(SRCROOT)/Carthage/Build/iOS/BMSAnalytics.framework</string>\
				<string>$(SRCROOT)/Carthage/Build/iOS/BMSAnalyticsAPI.framework</string>\
			</array>\
			<key>isa</key>\
			<string>PBXShellScriptBuildPhase</string>\
			<key>outputPaths</key>\
			<array/>\
			<key>runOnlyForDeploymentPostprocessing</key>\
			<string>0</string>\
			<key>shellPath</key>\
			<string>/bin/sh</string>\
			<key>shellScript</key>\
			<string>/usr/local/bin/carthage copy-frameworks</string>\
		</dict>");

oldText.push("</array><key>buildRules</key>");
newText.push("<string>FE997D981CF7978500F4EDDB</string></array><key>buildRules</key>");

module.exports = {
	oldText: oldText,
	newText: newText
}