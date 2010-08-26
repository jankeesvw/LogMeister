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
 *	Version 1.4
 *	
 */
package logmeister.connectors {
	import nl.demonsters.debugger.MonsterDebugger;

	import flash.display.DisplayObject;

	public class MonsterDebuggerConnector extends BaseConnector implements ILogMeisterConnector {

		private var _stage : DisplayObject;
		private static const color_debug : uint = 0xa6e22e;
		private static const color_info : uint = 0x66d9ef;
		private static const color_notice : uint = 0xae81ff;
		private static const color_warning : uint = 0xfd971f;
		private static const color_error : uint = 0xFF0A0A;
		private static const color_fatal : uint = 0xFF8000;
		private static const color_critical : uint = 0xf92672;
		private static const color_status : uint = 0x33FF00;

		public function MonsterDebuggerConnector(inStage : DisplayObject) {
			_stage = inStage;
		}

		public function init() : void {
			new MonsterDebugger(_stage);
		}

		public function sendDebug(...args) : void {
			MonsterDebugger.trace(getSender(), args[0][0], color_debug);
		}

		public function sendInfo(...args) : void {
			MonsterDebugger.trace(getSender(), args[0][0][0], color_info);
		}

		public function sendNotice(...args) : void {
			MonsterDebugger.trace(getSender(), args[0][0][0], color_notice);
		}

		public function sendWarn(...args) : void {
			MonsterDebugger.trace(getSender(), args[0][0][0], color_warning);
		}

		public function sendError(...args) : void {
			MonsterDebugger.trace(getSender(), args[0][0][0], color_error);
		}

		public function sendFatal(...args) : void {
			MonsterDebugger.trace(getSender(), args[0][0][0], color_fatal);
		}

		public function sendCritical(...args) : void {
			MonsterDebugger.trace(getSender(), args[0][0][0], color_critical);
		}

		public function sendStatus(...args) : void {
			MonsterDebugger.trace(getSender(), args[0][0][0], color_status);
		}
	}
}
