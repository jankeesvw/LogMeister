/*
Copyright 2009 Stephan Bezoen, http://stephan.acidcats.nl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */


package nl.acidcats.yalog {
	import nl.acidcats.yalog.common.Functions;
	import nl.acidcats.yalog.common.Levels;
	import nl.acidcats.yalog.common.MessageData;

	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.getTimer;	

	public class Yalog {

		private static var BUFFER_SIZE : Number = 250;
		private static var theInstance : Yalog;
		private static var bufferSize : Number = Yalog.BUFFER_SIZE;
		private var mSender : LocalConnection;
		private var senderConnected : Boolean = false;
		private var mReceiver : PongConnection;
		private var buffer : Array;
		private var writePointer : Number;
		private var fullCircle : Boolean = false;

		/**
		 * The instance of this class is only used in static functions, so not accessible from the outside
		 * @return singleton instance of yalog.Yalog
		 */
		private static function getInstance() : Yalog {
			if (theInstance == null)
				theInstance = new Yalog();
			return theInstance;
		}

		/*
		 * Constructor; private not allowed in AS3
		 */
		function Yalog() {
			// create send connection
			mSender = new LocalConnection();
			mSender.addEventListener(StatusEvent.STATUS, handleSenderStatus);

			// create buffer for buffering messages while not connected
			buffer = new Array(Yalog.bufferSize);
			writePointer = 0;

			// send a "ping" on the main channel to check for availability of any viewer application		
			ping();
		}

	
		/**
		 *	Send a "ping" on the main channel if a free receive channel is available
		 */
		private function ping() : void {
			if (createReceiver()) {
				try {
					mSender.send(Functions.CHANNEL, Functions.FUNC_PING, mReceiver.getReceiverChannel());
				} catch (e : ArgumentError) {
				}
			}
		}

		/**	
		 *	Create receiver local connection to handle pong from viewer application
		 */
		private function createReceiver() : Boolean {
			mReceiver = new PongConnection();
			mReceiver.addEventListener(StatusEvent.STATUS, handleReceiverStatus);
			mReceiver.addEventListener(PongConnection.EVENT_PONG_RECEIVED, handlePong);
			
			return mReceiver.start();
		}

		/**
		 *	Handle event from receiver connection that a pong was received
		 */
		private function handlePong(e : Event) : void {
			// flag we're connected to viewer
			senderConnected = true;
			
			// dump any buffered messages to the viewer
			dumpData();
		}

		/**
		 *	Set the number of messages to be kept as history.
		 *	Note: this will clear the current buffer, so make sure this is the first thing you do!
		 */
		public static function setBufferSize(inSize : Number) : void {
			Yalog.getInstance().setBufSize(inSize);
		}

		/**
		 *	Send a debug message to Yala
		 *	@param inText: the message
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		public static function debug(inText : String, inSender : String) : void {
			sendToConsole(inText, Levels.DEBUG, inSender);
		}
		/**
	
		 *	Send an informational message to Yala
		 *	@param inText: the message
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		public static function info(inText : String, inSender : String) : void {
			sendToConsole(inText, Levels.INFO, inSender);
		}

		/**
		 *	Send an error message to Yala
		 *	@param inText: the message
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		public static function error(inText : String, inSender : String) : void {
			sendToConsole(inText, Levels.ERROR, inSender);
		}

		/**
		 *	Send a warning message to Yala
		 *	@param inText: the message
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		public static function warn(inText : String, inSender : String) : void {
			sendToConsole(inText, Levels.WARN, inSender);
		}

		/**
		 *	Send a fatal message to Yala
		 *	@param inText: the message
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		public static function fatal(inText : String, inSender : String) : void {
			sendToConsole(inText, Levels.FATAL, inSender);
		}

		/**
		 *	Send a text to Yala with a certain level of importance
		 *	@param inText: the message
		 *	@param inLevel: the level of importance
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		private static function sendToConsole(inText : String, inLevel : Number, inSender : String) : void {
			var md : MessageData = new MessageData(inText, inLevel, getTimer(), inSender);
			
			Yalog.getInstance().handleData(md);
		}

		/**
		 *	Process message data
		 */
		private function handleData(inData : MessageData) : void {
			if (!senderConnected) {
				storeData(inData);
			} else {
				sendData(inData);
			}
		}

		/**
		 *	Send out message on the local connection
		 */
		private function sendData(inData : MessageData) : void {
			inData.channelID = mReceiver.getReceiverChannelID();
			mSender.send(Functions.CHANNEL, Functions.FUNC_WRITELOG, inData);
		}

		/**
		 *	Store message
		 */
		private function storeData(inData : MessageData) : void {
			buffer[writePointer++] = inData;
			
			if (writePointer >= BUFFER_SIZE) {
				fullCircle = true;
				writePointer = 0;
			}
		}

		/**
		 *	Send out all stored messages
		 */
		private function dumpData() : void {
			if (!fullCircle && (writePointer == 0)) return;
			
			sendData(new MessageData("-- START DUMP --", Levels.STATUS, getTimer(), toString()));
			
			if (fullCircle) {
				dumpRange(writePointer, BUFFER_SIZE - 1);
			}
			dumpRange(0, writePointer - 1);

			sendData(new MessageData("-- END DUMP --", Levels.STATUS, getTimer(), toString()));
			
			writePointer = 0;
			fullCircle = false;
		}

		/**
		 *	Send out messages in a consecutive range
		 */
		private function dumpRange(inStart : Number, inEnd : Number) : void {
			for (var i : Number = inStart;i <= inEnd;i++) {
				sendData(MessageData(buffer[i]));
			}
		}

		/**
		 *	Set the buffer size for storing messages
		 */
		private function setBufSize(inSize : Number) : void {
			Yalog.bufferSize = inSize;
			
			buffer = new Array(Yalog.bufferSize);
			writePointer = 0;
			fullCircle = false;
		}

		private function handleReceiverStatus(e : StatusEvent) : void {
		}

		private function handleSenderStatus(e : StatusEvent) : void {
		}

		public function toString() : String {
			return ";yalog.Yalog";
		}
	}
}

/**-------------------------------------------------------
 * Private class for handling "pong" call on local connection from viewer application
 */

import nl.acidcats.yalog.common.Functions;

import flash.events.Event;
import flash.net.LocalConnection;


dynamic class PongConnection extends LocalConnection {

	public static var EVENT_PONG_RECEIVED : String = "onPongReceived";
	private var mChannelID : Number;
	private var mReceiverChannel : String;

	/**
	 * Constructor
	 */
	public function PongConnection() {
		// allow connection from anywhere
		allowDomain("*");
		allowInsecureDomain("*");
	}


	/**
	 * Start the connection by finding a free channel and connecting on in
	 * @return true if a free channel was found and connecting was successful, otherwise false
	 */
	public function start() : Boolean {
		var receiverConnected : Boolean = false;
		mChannelID = 0;

		// loop available channels, try to connect
		do {
			mChannelID++;
			mReceiverChannel = Functions.CHANNEL_PING + mChannelID;
			
			try {
				receiverConnected = true;
				connect(mReceiverChannel);
			} catch (e : ArgumentError) {
				receiverConnected = false;
			}
		} while (!receiverConnected && (mChannelID < Functions.MAX_CHANNEL_COUNT));
		
		if (receiverConnected) {
			this[Functions.FUNC_PONG] = handlePong;
		}
		
		return receiverConnected;
	}


	/**
	 * @return the full name of the receiver channel
	 */
	public function getReceiverChannel() : String {
		return mReceiverChannel;
	}


	/**
	 * @return the ID of the receiver channel
	 */
	public function getReceiverChannelID() : Number {
		return mChannelID;
	}


	/**
	 * Handle call from a viewer application via local connection 
	 */
	private function handlePong() : void {
		this.close();
		
		dispatchEvent(new Event(EVENT_PONG_RECEIVED));
	}
}
