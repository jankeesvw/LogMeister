/*
 *	LogMeister for ActionScript 3.0
 *	Copyright © 2011 Base42.nl
 *	All rights reserved.
 *	
 *	http://github.com/base42/LogMeister
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *	
 *	Logmeister version 1.7
 *	
 */
package logmeister {
	import logmeister.connectors.ILogMeisterConnector;

	import flash.utils.getQualifiedClassName;

	public class LogMeister {

		public static const VERSION : String = "Version 1.7";
		private static var loggers : Array = new Array();

		/*
		 * Add an Array of loggers for examples see the connectors package
		 */
		public static function addLoggers(loggers : Array) : void {
			for each (var logger : ILogMeisterConnector in loggers) {
				addLogger(logger);
			}
		}

		/*
		 * Add a logger connector (@see ILogMeisterConnector), a logger cannot be added twice
		 */
		public static function addLogger(inLogger : ILogMeisterConnector) : void {
			
			for each (var logger : ILogMeisterConnector in loggers) {
				if(getQualifiedClassName(logger) == getQualifiedClassName(inLogger)) {
					// ignore double added loggers
					return;
				}
			}

			inLogger.init();
			loggers.push(inLogger);
		}

		/*
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
