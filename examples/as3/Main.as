package {
	import logmeister.connectors.FirebugConnector;
	import logmeister.LogMeister;
	import logmeister.connectors.FlashConnector;
	import logmeister.connectors.MonsterDebuggerConnector;
	import logmeister.connectors.SosMaxConnector;
	import logmeister.connectors.TrazzleConnector;
	import logmeister.connectors.YalogConnector;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 *
	 * LogMeister demo application.
	 * 
	 * If you want to see the stacktraces in your logging application add this to your compiler arguments:
	 * -verbose-stacktraces=true
	 *
	 * That's all! Have fun!
	 *
	 */
	public class Main extends Sprite {

		public function Main() {
			var textField : TextField = new TextField();
			textField.text = "Check your logger...";
			addChild(textField);


			var sender : String = new Error().getStackTrace();
			trace(sender);

			var textField2 : TextField = new TextField();
			textField2.y = 30;
			textField2.text = "Example stacktrace: \n" + sender;
			textField2.width = stage.stageWidth;
			textField2.height = 50;
			addChild(textField2);
			
			LogMeister.addLogger(new TrazzleConnector(stage, "Test application"));
			LogMeister.addLogger(new SosMaxConnector());
			LogMeister.addLogger(new MonsterDebuggerConnector(stage));
			LogMeister.addLogger(new YalogConnector());
			LogMeister.addLogger(new FlashConnector());
			LogMeister.addLogger(new FirebugConnector());
			
			error('error');
			critical('critical');
			debug('debug');
			fatal('fatal');
			info('info');
			notice('notice');
			status('status');
			warn('warn');
			trace('regular trace');
			
			someFunction();
			
			var sp : Sprite = new Sprite();
			sp.graphics.beginFill(0xff0000);
			sp.graphics.drawRect(0, 0, 10, 10);
			sp.graphics.endFill();
			
			TrazzleConnector.logDisplayObject(sp);
			TrazzleConnector.logDisplayObject(textField, false);
			
		}

		private function someFunction() : void {
			anotherFunction();
		}

		private function anotherFunction() : void {
			showStackTraceLog();
		}

		private function showStackTraceLog() : void {
			debug('I have a stacktrace');
		}
	}
}
