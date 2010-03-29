package {
	import logmeister.connectors.FlashConnector;
	import logmeister.connectors.MonsterDebuggerConnector;
	import logmeister.connectors.SosMaxConnector;
	import logmeister.connectors.TrazzleConnector;
	import logmeister.connectors.YalogConnector;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Jankees van Woezik / Base42.nl
	 */
	public class Main extends Sprite {

		public function Main() {
			var textField : TextField = new TextField();
			textField.text = "Check your logger...";
			addChild(textField);
			
			LogMeister.addLogger(new TrazzleConnector(stage, "Test application"));
			LogMeister.addLogger(new SosMaxConnector());
			LogMeister.addLogger(new MonsterDebuggerConnector(stage));
			LogMeister.addLogger(new YalogConnector());
			LogMeister.addLogger(new FlashConnector());
			
			critical('critical');
			debug('debug');
			error('error');
			fatal('fatal');
			info('info');
			notice('notice');
			status('status');
			warn('warn');
			trace('regular trace');
		}
	}
}
