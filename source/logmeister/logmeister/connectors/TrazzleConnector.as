/*
 *	Log Meister for ActionScript 3.0
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
 *	Version 1.1
 *	
 */
package logmeister.connectors {
	import com.nesium.TrazzleLoggerOnePointTwo;
	import com.nesium.logging.TrazzleLogger;
	import com.nesium.ui.StatusBar;
	import com.nesium.zz_init;
	import com.nesium.zz_monitor;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;

	public class TrazzleConnector extends LogMeisterConnector implements ILogMeisterConnector {

		private var _stage : Stage;
		private var _title : String;
		private var _monitorPerformance : Boolean;
		private var _backwardsCompatible : Boolean;
		private var _trazzleLoggerOnePointTwo : TrazzleLoggerOnePointTwo;

		/**
		 * @param inBackwardsCompatible if set to true, this connector also logs to Trazzle 1.2
		 */
		public function TrazzleConnector(inStage : Stage, inTitle : String,inMonitorPerformance : Boolean = true,inBackwardsCompatible : Boolean = true) {
			_backwardsCompatible = inBackwardsCompatible;
			_monitorPerformance = inMonitorPerformance;
			_stage = inStage;
			_title = inTitle;
		}

		public function init() : void {
			zz_init(_stage, _title);
			if(_monitorPerformance) zz_monitor(true);
			if(_backwardsCompatible) _trazzleLoggerOnePointTwo = new TrazzleLoggerOnePointTwo();
		}

		public function sendDebug(... args) : void {
			send("d " + args);
		}

		public function sendInfo(... args) : void {
			send("i " + args);
		}

		public function sendNotice(... args) : void {
			send("n " + args);
		}

		public function sendWarn(... args) : void {
			send("e " + args);
		}

		public function sendError(... args) : void {
			send("e " + args);
		}

		public function sendFatal(... args) : void {
			send("f " + args);
		}

		public function sendCritical(... args) : void {
			send("c " + args);
		}

		public function sendStatus(... args) : void {
			send("s " + args);
		}

		public static function logDisplayObject(inDisplayObject : DisplayObject,inTransparent : Boolean = true,inFillColor : uint = 0xffffff) : void {
			var bd : BitmapData = new BitmapData(inDisplayObject.width, inDisplayObject.height, inTransparent, inTransparent ? 0x00000000 : inFillColor);
			bd.draw(inDisplayObject);
			TrazzleLogger.instance().logBitmapData(bd);
		}

		private function send(...rest) : void {
			if(_trazzleLoggerOnePointTwo) _trazzleLoggerOnePointTwo.log(rest.toString());
			TrazzleLogger.instance().log(rest.toString(), 3);
		}

		public static function getMenu() : StatusBar {
			return StatusBar.systemStatusBar();
		}
	}
}