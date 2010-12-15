/*
 *	LogMeister for ActionScript 3.0
 *	Copyright © 2010 Base42.nl
 *	All rights reserved.
 *	
 *	http://github.com/base42/LogMeister
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the LogMeister nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	LogMeister is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	LogMeister is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with LogMeister.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	Version 1.5
 *	
 */
package logmeister.connectors {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class ServerConnector extends BaseConnector implements ILogMeisterConnector {

		public var serverPath : String;
		public var projectId : String;
		public var logLevels : String;
		public var buildInfo : String;

		/*	
		 * @param inServerPath:String path where to post logs
		 * @param inLogLevels:String list of debug levels. @example fec sends fatal, error and critical
		 * @param inProjectId:String id of the project.
		 * @param inBuildInfo:String the actual build information
		 */
		public function ServerConnector(inServerPath : String, inLogLevels : String, inProjectId : uint, inBuildInfo : String) {
			serverPath = inServerPath;
			projectId = inProjectId.toString();
			logLevels = inLogLevels;
			buildInfo = inBuildInfo;
		}

		public function init() : void {
		}

		public function sendDebug(...args : *) : void {
			sendToServer("debug", args);
		}

		public function sendInfo(...args : *) : void {
			sendToServer("info", args);
		}

		public function sendNotice(...args : *) : void {
			sendToServer("notice", args);
		}

		public function sendWarn(...args : *) : void {
			sendToServer("warning", args);
		}

		public function sendError(...args : *) : void {
			sendToServer("error", args);
		}

		public function sendFatal(...args : *) : void {
			sendToServer("fatal", args);
		}

		public function sendCritical(...args : *) : void {
			sendToServer("critical", args);
		}

		public function sendStatus(...args : *) : void {
			sendToServer("status", args);
		}

		private function sendToServer(level : String, ...args) : void {
			if (logLevels.indexOf(level) == -1) return;

			var loader : URLLoader = new URLLoader();
			var request : URLRequest = new URLRequest(serverPath);

			var errs : Array = new Error().getStackTrace().match(/\[([^\]]+)/gi);
			var leni : uint = errs.length;
			for (var i : uint = 0;i < leni;i++) {
				errs[i] = String(errs[i]).substring(1, String(errs[i]).length);
			}
			
			errs.shift();
			errs.shift();
			errs.shift();
			
			var vars : URLVariables = new URLVariables();
			vars["data[Log][project_id]"] = projectId;
			vars["data[Log][level]"] = level;
			vars["data[Log][stacktrace]"] = errs.join("\n");
			vars["data[Log][build_info]"] = buildInfo;
			vars["data[Log][message]"] = args;
			
			request.data = vars;
			request.method = URLRequestMethod.POST;
			loader.load(request);
		}
	}
}
