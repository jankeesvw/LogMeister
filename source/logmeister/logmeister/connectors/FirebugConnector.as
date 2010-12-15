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
	import flash.external.ExternalInterface;

	public class FirebugConnector extends BaseConnector implements ILogMeisterConnector {
		private static const LOG_FUNCTION : String = "console.log";
		private static const INFO_FUNCTION : String = "console.info";
		private static const WARN_FUNCTION : String = "console.warn";
		private static const ERROR_FUNCTION : String = "console.error";

		public function init() : void {
		}

		public function sendDebug(...args : *) : void {
			ExternalInterface.call(LOG_FUNCTION, "DEBUG");
		}

		public function sendInfo(...args : *) : void {
			ExternalInterface.call(INFO_FUNCTION, String(args));
		}

		public function sendNotice(...args : *) : void {
			ExternalInterface.call(INFO_FUNCTION, String(args));
		}

		public function sendWarn(...args : *) : void {
			ExternalInterface.call(WARN_FUNCTION, String(args));
		}

		public function sendError(...args : *) : void {
			ExternalInterface.call(ERROR_FUNCTION, String(args));
		}

		public function sendFatal(...args : *) : void {
			ExternalInterface.call(ERROR_FUNCTION, String(args));
		}

		public function sendCritical(...args : *) : void {
			ExternalInterface.call(WARN_FUNCTION, String(args));
		}

		public function sendStatus(...args : *) : void {
			ExternalInterface.call(INFO_FUNCTION, String(args));
		}
	}
}
