package com.nesium
{
	import flash.utils.getDefinitionByName;
	public function zz_inspect(obj:*):void
	{
		try
		{
			var logger:Class = getDefinitionByName('com.nesium.logging.TrazzleLogger') as Class;
			logger['instance']().inspectObject(obj);
		}
		catch (e:Error) {}
	}
}