package
{
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.utils.templates.DefaultSceneTemplate;
	import alternativa.utils.templates.TextInfo;
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	import crystal.alternativa3d.loaders.MapLoader;
	
	public class AlternativaEditorMapLoaderSample extends DefaultSceneTemplate
	{
		public var ambientLight:AmbientLight = new AmbientLight(0xFFFFFF);
		public var omniLight:OmniLight = new OmniLight(0xFFFFFF, 1, 7000);
		
		override protected function initScene():void
		{
			mainCamera.nearClipping = .1;
			controller.setObjectPosXYZ(0, -10, 5);
			controller.lookAtXYZ(0, 0, 0);
			controller.speed = 15;
			controller.unbindKey(Keyboard.UP);
			controller.unbindKey(Keyboard.DOWN);
			controller.unbindKey(Keyboard.LEFT);
			controller.unbindKey(Keyboard.RIGHT);
			controller.enable();
			
			ambientLight.intensity = 0.2;
			omniLight.x = 0;
			omniLight.y = 200;
			omniLight.z = 1000;
			omniLight.intensity = 0.8;
			scene.addChild(ambientLight);
			scene.addChild(omniLight);
			
			var textInfo:TextInfo = new TextInfo();
			
			try {
				var mapLoader:MapLoader = new MapLoader("res/propslibs/", "res/map.xml", .005);
				mapLoader.loadAndParseMap(scene, stage3D.context3D);
			} catch (error:Error)
				{
					if (error.errorID == 2148)
					{
						textInfo.write("SecurityError: Error #2148: SWF file cannot access local resources.\nOnly local-with-filesystem and trusted local SWF files may access local resources.");
						addChild(textInfo);
					}
					else throw error;
				}
		}
	}
}