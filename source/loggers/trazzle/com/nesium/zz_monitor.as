package com.nesium
{
	import flash.utils.getDefinitionByName;
	public function zz_monitor(isOn:Boolean):void
	{
		try
		{
			var logger:Class = getDefinitionByName('com.nesium.logging.TrazzleLogger') as Class;
			isOn 
				? logger['instance']().startPerformanceMonitoring()
				: logger['instance']().stopPerformanceMonitoring();
		}
		catch (e:Error) {}
	}
}