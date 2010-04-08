package com.nesium
{
	import flash.utils.getDefinitionByName;
	public function logf(format:String, ...rest):void
	{
		try
		{
			var logger:Class = getDefinitionByName('com.nesium.logging.TrazzleLogger') as Class;
			var printf:Function = getDefinitionByName('br.com.stimuli.string.printf') as Function;
			logger['instance']().log(printf.apply(null, [format].concat(rest)));
		}
		catch (e:Error) {}
	}
}