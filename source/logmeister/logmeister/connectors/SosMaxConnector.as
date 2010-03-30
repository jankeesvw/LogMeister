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
 *	Thanks to Eric-Paul Lecluse for the help on this connector 
 *	
 */
package logmeister.connectors {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.XMLSocket;
	import flash.system.Capabilities;
	import flash.utils.Timer;

	public class SosMaxConnector extends LogMeisterConnector implements ILogMeisterConnector {

		private var socket : XMLSocket;
		private var _stack : Array;
		private var _timer : Timer;
		private var _debugger : Boolean;
		private var _isConnected : Boolean;

		public function init() : void {
			socket = new XMLSocket();
			socket.addEventListener(Event.CONNECT, handleOnConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            
			_stack = [];
			_timer = new Timer(2000);
			_timer.addEventListener(TimerEvent.TIMER, tryToReconnect);

			connect();
		}

		public function sendDebug(...args) : void {
			sendSOSMessage(String(args), getSender(), "temp");
		}

		public function sendInfo(...args) : void {
			sendSOSMessage(String(args), getSender(), "info");
		}

		public function sendNotice(...args) : void {
			sendSOSMessage(String(args), getSender(), "error");
		}

		public function sendWarn(...args) : void {
			sendSOSMessage(String(args), getSender(), "warn");
		}

		public function sendError(...args) : void {
			sendSOSMessage(String(args), getSender(), "error");
		}

		public function sendFatal(...args) : void {
			sendSOSMessage(String(args), getSender(), "fatal");
		}

		public function sendCritical(...args) : void {
			sendSOSMessage(String(args), getSender(), "error");
		}

		public function sendStatus(...args) : void {
			sendSOSMessage(String(args), getSender(), "info");
		}

		private function connect() : void {
			try {
				socket.connect("localhost", 4444);
			} catch (error : SecurityError) {
				trace("SecurityError in SOSAppender: " + error);
			}
		}

		private function tryToReconnect(event : TimerEvent) : void {
			_timer.removeEventListener(TimerEvent.TIMER, tryToReconnect);
			connect();
		}

		private function onError(event : Event) : void {
			// ignore errors.
			// they only occur when the SOS viewer is not running.
			_timer.start();
		}

		private function handleOnConnect(event : Event) : void {
			_debugger = Capabilities.isDebugger;
			_isConnected = true;
			_timer.stop();

			while (_stack.length) {
				var m : Message = _stack.shift() as Message;
				sendSOSMessage(m.message, m.origin, m.key);
			}
		}    

		private function sendSOSMessage(inMessage : String, inOrigin : String, inKey : String = "debug") : void {
			if (_isConnected) {
				try {
					socket.send("!SOS<showMessage key='" + inKey + "'>" + inMessage.replace(/&/g, "&amp;").replace(/\>/gi, "&gt;").replace(/\</gi, "&lt;") + " \t\t :" + inOrigin + "</showMessage>");
				} catch (e : Error) {
					// ignore error
					trace("no debugger found");
				}
			} else {
				_stack.push(new Message(inMessage, inOrigin, inKey));
				while (_stack.length > 200) {
					_stack.shift();
				}
			}
		}
	}
}


class Message {

	public var key : String;
	public var origin : String;
	public var message : String;

	public function Message(inMessage : String, inOrigin : String, inKey : String) {
		message = inMessage;
		origin = inOrigin;
		key = inKey;
	}
}
