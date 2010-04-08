package com.nesium
{
	import flash.utils.getDefinitionByName;
	public function zz_observe_file(path:String, listener:Function, remove:Boolean=false):void
	{
		try
		{
			var logger:Class = getDefinitionByName('com.nesium.logging.TrazzleLogger') as Class;
			logger['instance']().observeFile(path, listener, remove);
		}
		catch (e:Error) {}
	}
}