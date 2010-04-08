package com.nesium
{
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	public function zz_init(theStage:Stage, title:String):void
	{
		try
		{
			var logger:Class = getDefinitionByName('com.nesium.logging.TrazzleLogger') as Class;
			logger['instance']().setParams(theStage, title);
		}
		catch (e:Error) {}
	}
}