package com.nesium.logging
{
	
	import mx.logging.AbstractTarget;
	import mx.logging.LogEvent;
	import mx.logging.Log;
	import com.nesium.logging.TrazzleLogger;
	
	
	public class TrazzleTarget extends AbstractTarget
	{
		
		/***************************************************************************
		*							public properties							   *
		***************************************************************************/
		public var includeTime : Boolean = false;
		public var includeLevel : Boolean = true;
		public var includeCategory : Boolean = false;
		
		
		
		/***************************************************************************
		*							private properties							   *
		***************************************************************************/
		private var m_logger : TrazzleLogger;
		
		
		
		/***************************************************************************
		*							public methods								   *
		***************************************************************************/
		public function TrazzleTarget()
		{
			super();
			m_logger = new TrazzleLogger();
		}
		
		
		override public function logEvent(event:LogEvent) : void
		{
			m_logger.log(event.message);
		}
	}
}