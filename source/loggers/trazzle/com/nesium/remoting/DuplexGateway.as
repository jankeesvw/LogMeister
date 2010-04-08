//
//  DuplexGateway.as
//
//  Created by Marc Bauer on 2009-02-20.
//  Copyright (c) 2009 nesiumdotcom. All rights reserved.
//

package com.nesium.remoting
{

	import com.nesium.logging.zz;
	import com.nesium.remoting.RemoteService;
	import com.nesium.remoting.types.AMFActionMessage;
	import com.nesium.remoting.types.AMFMessageBody;
	import com.nesium.remoting.types.AMFMessageHeader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.ObjectEncoding;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	use namespace zz;
	
	public class DuplexGateway
	{
	
		//*****************************************************************************************
		//*                                  Protected Properties                                 *
		//*****************************************************************************************
		protected var m_remoteHost:String;
		protected var m_port:int;
		protected var m_services:Object;
		protected var m_remoteServices:Object;
		protected var m_socket:Socket;
		protected var m_state:int = 0;
		protected var m_nextMessageSize:Number;
		protected var m_invocationCount:int = 1;
		protected var m_queuedInvocations:Array;
		protected var m_pendingInvocations:Array;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function DuplexGateway(remoteHost:String, port:int)
		{
			m_services = {};
			m_remoteServices = {};
			m_remoteHost = remoteHost;
			m_queuedInvocations = [];
			m_pendingInvocations = [];
			m_port = port;
		}
		
		
		
		public function connectToRemote():void
		{
			m_socket = new Socket();
			Security.loadPolicyFile('xmlsocket://' + m_remoteHost + ':' + m_port);
			m_socket.addEventListener(Event.CONNECT, socket_didConnect);
			m_socket.addEventListener(Event.CLOSE, socket_didDisconnect);
			m_socket.addEventListener(IOErrorEvent.IO_ERROR, socket_ioError);
			m_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityError);
			m_socket.addEventListener(ProgressEvent.SOCKET_DATA, socket_data);
			m_socket.connect(m_remoteHost, m_port);
		}
		
		public function disconnect():void
		{
			m_socket.close();
			m_socket.removeEventListener(Event.CONNECT, socket_didConnect);
			m_socket.removeEventListener(Event.CLOSE, socket_didDisconnect);
			m_socket.removeEventListener(IOErrorEvent.IO_ERROR, socket_ioError);
			m_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityError);
			m_socket.removeEventListener(ProgressEvent.SOCKET_DATA, socket_data);
			m_socket = null;
		}
		
		public function registerServiceWithName(service:Object, name:String):void
		{
			m_services[name] = service;
		}
		
		public function unregisterServiceWithName(name:String):void
		{
			m_services[name] = null;
		}
		
		public function remoteServiceWithName(name:String):RemoteService
		{
			if (!m_remoteServices[name])
			{
				m_remoteServices[name] = new RemoteService(this, name);
			}
			return m_remoteServices[name];
		}
		
		public function isConnected():Boolean
		{
			return m_socket.connected;
		}
		
		public function invokeRemoteService(serviceName:String, methodName:String, 
			...arguments:Array):InvocationResult
		{			
			var am:AMFActionMessage = new AMFActionMessage();
			var body:AMFMessageBody = new AMFMessageBody();
			body.targetURI = serviceName + '.' + methodName;
			body.responseURI = '/' + m_invocationCount;
			body.data = arguments;
			am.bodies = [body];
			
			if (!isConnected())
				m_queuedInvocations.push(am);
			else
				sendActionMessage(am);
				
			var result:InvocationResult = new InvocationResult(serviceName, methodName, arguments, 
				m_invocationCount++);
			m_pendingInvocations.push(result);
			return result;
		}
		
		
		
		
		//*****************************************************************************************
		//*                                   Protected Methods                                   *
		//*****************************************************************************************
		protected function readFromSocket():Boolean
		{
			if (m_state == 0 && m_socket.bytesAvailable >= 4)
			{
				m_nextMessageSize = m_socket.readUnsignedInt();
				m_state = 1;
				return m_socket.bytesAvailable > 0;
			}
			else if (m_state == 1 && m_socket.bytesAvailable >= m_nextMessageSize)
			{
				var ba:ByteArray = new ByteArray();
				ba.objectEncoding = ObjectEncoding.AMF0;
				m_socket.readBytes(ba, 0, m_nextMessageSize);
				processActionMessage(actionMessageFromByteArray(ba));
				m_state = 0;
				return m_socket.bytesAvailable > 0;
			}
			return false;
		}
		
		protected function actionMessageFromByteArray(ba:ByteArray):AMFActionMessage
		{
			//log('readActionMessageWithSize ' + size);
			ba.objectEncoding = ObjectEncoding.AMF0;
			var am:AMFActionMessage = new AMFActionMessage();
			am.encoding = ba.readUnsignedShort();
			am.headers = [];
			var numHeaders:int = ba.readUnsignedShort();
			for (var i:int = 0; i < numHeaders; i++)
			{
				var header:AMFMessageHeader = new AMFMessageHeader();
				header.name = ba.readUTF();
				header.mustUnderstand = ba.readBoolean();
				var headerDataLen:Number = ba.readUnsignedInt(); // header length
				if (am.encoding == ObjectEncoding.AMF3){
					var headerDataBa:ByteArray = new ByteArray();
					headerDataBa.objectEncoding = am.encoding;
					ba.readBytes(headerDataBa, 0, headerDataLen);
					headerDataBa.readByte(); // AVMPlus marker
					body.data = headerDataBa.readObject();
				}else{
					header.data = ba.readObject();
				}
				am.headers.push(header);
			}
			am.bodies = [];
			var numBodies:int = ba.readUnsignedShort();
			for (i = 0; i < numBodies; i++)
			{
				var body:AMFMessageBody = new AMFMessageBody();
				body.targetURI = ba.readUTF();
				body.responseURI = ba.readUTF();
				var bodyDataLen:Number = ba.readUnsignedInt(); // body length
				if (am.encoding == ObjectEncoding.AMF3){
					var bodyDataBa:ByteArray = new ByteArray();
					bodyDataBa.objectEncoding = am.encoding;
					ba.readBytes(bodyDataBa, 0, bodyDataLen);
					bodyDataBa.readByte(); // AVMPlus marker
					body.data = bodyDataBa.readObject();
				}else{
					body.data = ba.readObject();
				}
				am.bodies.push(body);
			}
			return am;
		}
		
		protected function sendActionMessage(am:AMFActionMessage):void
		{
			var ba:ByteArray = actionMessageToByteArray(am);
			m_socket.writeUnsignedInt(ba.length);
			m_socket.writeBytes(ba);
		}
		
		protected function actionMessageToByteArray(am:AMFActionMessage):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			ba.objectEncoding = ObjectEncoding.AMF0;
			ba.writeShort(ba.objectEncoding);
			ba.writeShort(am.headers.length);
			for each (var header:AMFMessageHeader in am.headers)
			{
				ba.writeUTF(header.name);
				ba.writeBoolean(header.mustUnderstand);
				var headerBa:ByteArray = new ByteArray();
				headerBa.objectEncoding = am.encoding;
				headerBa.writeObject(header.data);
				ba.writeUnsignedInt(headerBa.length);
				if (am.encoding == ObjectEncoding.AMF3)
					ba.writeByte(0x11); // AVM plus object type
				ba.writeBytes(headerBa);
			}
			ba.writeShort(am.bodies.length);
			for each (var body:AMFMessageBody in am.bodies)
			{
				ba.writeUTF(body.targetURI);
				ba.writeUTF(body.responseURI);
				var bodyBa:ByteArray = new ByteArray();
				bodyBa.objectEncoding = am.encoding;
				bodyBa.writeObject(body.data);
				ba.writeUnsignedInt(bodyBa.length);
				if (am.encoding == ObjectEncoding.AMF3)
					ba.writeByte(0x11); // AVM plus object type
				ba.writeBytes(bodyBa);
			}
			return ba;
		}
		
		protected function processActionMessage(am:AMFActionMessage):void
		{
			for each (var body:AMFMessageBody in am.bodies)
			{
				var targetComponents:Array = body.targetURI.split('.');
				var service:Object = m_services[targetComponents[0]];
				var methodName:String = targetComponents[1];
				// is a response
				if (body.responseURI.indexOf('/') == -1)
				{
					var methodComponents:Array = methodName.split('/');
					methodName = methodComponents[0];
					var index:int = parseInt(methodComponents[1]);
					var resultType:String = methodComponents[2];
					processResponse(targetComponents[0], methodName, body.data, index, resultType);
					continue;
				}
				if (!service){
					throw new Error('No service with name ' + targetComponents[0] + ' registered!');
				}else if (!service.hasOwnProperty(methodName)){
					throw new Error('Service ' + targetComponents[0] + ' has no method named ' + 
						methodName);
				}
				var result:* = service[methodName].apply(service, (body.data is Array ? 
					body.data : [body.data]));
				var isOneway:Boolean = describeType(service)..method.(@name == methodName).
					@returnType == 'void';
				if (!isOneway)
				{
					var ram:AMFActionMessage = new AMFActionMessage();
					var rbody:AMFMessageBody = new AMFMessageBody();
					rbody.targetURI = body.targetURI + body.responseURI + '/onResult';
					rbody.data = result;
					ram.bodies = [rbody];
					sendActionMessage(ram);
				}
			}
		}
		
		protected function processResponse(serviceName:String, methodName:String, responseData:*, 
			invocationIndex:int, resultType:String):void
		{
			// here's room for optimization
			var result:InvocationResult;
			for each (var nextResult:InvocationResult in m_pendingInvocations)
			{
				if (nextResult.invocationIndex == invocationIndex && 
					nextResult.serviceName == serviceName && 
					nextResult.methodName == methodName)
				{
					result = nextResult;
					break;
				}
			}
			if (!result)
			{
				throw new Error('Received a response to a request we obviously never sent!');
			}
			result.status = resultType;
			result.result = responseData;
			result.invocationDidReceiveResponse();
		}
		
		protected function executeQueuedInvocations():void
		{
			for each (var am:AMFActionMessage in m_queuedInvocations)
			{
				sendActionMessage(am);
			}
			m_queuedInvocations = [];
		}
		
		
		
		
		//*****************************************************************************************
		//*                                         Events                                        *
		//*****************************************************************************************
		protected function socket_didConnect(e:Event):void
		{
			m_socket.writeUTFBytes('BIN-INIT');
			m_socket.writeByte(0);
			m_socket.flush();
			
			executeQueuedInvocations();
		}
		
		protected function socket_didDisconnect(e:Event):void
		{
//			log('did disconnect');
		}
		
		protected function socket_ioError(e:IOErrorEvent):void
		{
//			log('io error');
		}
		
		protected function socket_securityError(e:SecurityErrorEvent):void
		{
//			log('security error');
		}
		
		protected function socket_data(e:ProgressEvent):void
		{
			while (readFromSocket());
		}
	}
}
