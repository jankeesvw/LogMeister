/*
 *	Log Meister for ActionScript 3.0
 *	Copyright © 2010 Base42.nl
 *	All rights reserved.
 *	
 *	http://github.com/jankeesvw/LogMeister
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
 *	- Neither the name of the Log Meister nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Log Meister is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Log Meister is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Log Meister.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	Version 1.0
 *	
 */
package {
	import logmeister.connectors.ILogMeisterConnector;

	import flash.utils.getQualifiedClassName;

	public class LogMeister {

		private static var loggers : Array = new Array();

		/**
		 * Add an Array of loggers for examples see the connectors package
		 */
		public static function addLoggers(loggers : Array) : void {
			for each (var logger : ILogMeisterConnector in loggers) {
				addLogger(logger);
			}
		}

		/**
		 * Internally used to add a logger, a logger cannot be added twice
		 */
		public static function addLogger(inLogger : ILogMeisterConnector) : void {
			
			for each (var logger : ILogMeisterConnector in loggers) {
				if(getQualifiedClassName(logger) == getQualifiedClassName(inLogger)) {
					throw new Error("LogMeister: You can't add the same logger twice");
					return;
				}
			}

			inLogger.init();
			loggers.push(inLogger);
		}

		/**
		 * Clear the list of active Loggers, after this statement you will not recieve any debug messages
		 */
		public static function clearLoggers() : void {
			loggers = new Array();	
		}

		NSLogMeister static function debug(... args) : void {
			for each (var logger : ILogMeisterConnector in loggers) {
				logger.sendDebug(args); 
			}
		}

		NSLogMeister static function info(... args) : void {
			for each (var logger : ILogMeisterConnector in loggers) {
				logger.sendInfo(args); 
			}
		}

		NSLogMeister static function notice(... args) : void {
			for each (var logger : ILogMeisterConnector in loggers) {
				logger.sendNotice(args); 
			}
		}

		NSLogMeister static function warn(... args) : void {
			for each (var logger : ILogMeisterConnector in loggers) {
				logger.sendWarn(args); 
			}
		}

		NSLogMeister static function error(... args) : void {
			for each (var logger : ILogMeisterConnector in loggers) {
				logger.sendError(args); 
			}
		}

		NSLogMeister static function fatal(... args) : void {
			for each (var logger : ILogMeisterConnector in loggers) {
				logger.sendFatal(args); 
			}
		}

		NSLogMeister static function critical(... args) : void {
			for each (var logger : ILogMeisterConnector in loggers) {
				logger.sendCritical(args); 
			}
		}

		NSLogMeister static function status(... args) : void {
			for each (var logger : ILogMeisterConnector in loggers) {
				logger.sendStatus(args); 
			}
		}
	}
}
