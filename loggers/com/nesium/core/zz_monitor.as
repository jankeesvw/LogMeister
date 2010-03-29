package com.nesium.core
{
	import com.nesium.lib.com.nesium.logging.TrazzleLogger;
	public function zz_monitor(isOn : Boolean) : void
	{
		try
		{
			var logger : Class = TrazzleLogger as Class;
			isOn ? logger['instance']( ).startPerformanceMonitoring( ) : logger['instance']( ).stopPerformanceMonitoring( );
		}
catch (e : Error) 
		{
		}
	}
}