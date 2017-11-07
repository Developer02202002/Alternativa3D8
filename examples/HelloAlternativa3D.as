package {
	
	import alternativa.engine3d.controllers.*;import alternativa.engine3d.core.*;
	import alternativa.engine3d.lights.*;import alternativa.engine3d.materials.*;
	import alternativa.engine3d.primitives.*;import alternativa.engine3d.resources.*;
	import alternativa.engine3d.shadows.*;import alternativa.engine3d.loaders.*;
	import alternativa.engine3d.objects.*;import alternativa.engine3d.core.*;
	import alternativa.protocol.codec.primitive.*;
	
	import flash.display.*; import flash.events.*; import flash.system.*; 
	import flash.ui.*; import flash.utils.*; import flash.sampler.*; 
	import flash.media.*; import flash.net.*; import flash.external.*;
	import flash.text.*;import flash.geom.*;
	
	
	import jiglib.cof.*; import jiglib.debug.*;import jiglib.geometry.*; import jiglib.math.*;
	import jiglib.data.*;import jiglib.physics.*;import jiglib.plugin.away3d4.*;
	import jiglib.plugin.*;
	import jiglib.vehicles.*;
	
	import helloalternativa3d.*;
	
	/**
	 * Alternativa3D 8.32.0 13.05.2013 0:23 "Hello world + shadow + box + jiglib 3d physics!"
	 */
	public class HelloAlternativa3D extends Sprite {
		private var rootContainer:Object3D;
		private var camera:Camera3D;
		private var stage3D:Stage3D;
		private var box:Mesh;
		private var material:TextureMaterial;
		
		private var spriteSmoke:Sprite3dSmoke;
		
		private var physics:AbstractPhysics;
		
		private var cubeMaterial:VertexLightTextureMaterial;
		
		private var shadow:DirectionalLightShadow;
		
		private var carBody:JCar;
		
		private var steerFL:*;
		private var steerFR:*;
		private var wheelFL:*;
		private var wheelFR:*;
		private var  wheelBL:*;
		private var wheelBR:*;
		
		private var carContainer:Object3D;
		private var smokePosContainer:Object3D;
		
		private var hrefTxt:TextField;
		
		private var carMaterial:VertexLightTextureMaterial;
		private var mBox:Mesh;
		
		private var cameraSpeedVector:Vector3D = new Vector3D(7, 0, 10);
		private var cameraPos:Vector3D = new Vector3D();
		private var directionalLight:DirectionalLight;
		private var hoverTr:Boolean;
		public function HelloAlternativa3D() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
		}


		private function onContextCreate(e:Event):void {
			
			var bitmapCubeResource:BitmapTextureResource 
			= new BitmapTextureResource(makeBlaBmd());
			
			var planeResource:BitmapTextureResource 
			= new BitmapTextureResource(getPerlinBmd());
			
			var smokeBitmapTextureResource:BitmapTextureResource = 
			new BitmapTextureResource(Sprite3dSmoke.makeSmokePuffBmd(0x000000));
			
			var carBitmapTextureResource:BitmapTextureResource = 
			new BitmapTextureResource(CarBmdTexture.makeCarTextureBitmap());
			
			
			var smoke_normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0xFFFFFF));
			
			var grass_diffuse:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0xFF0000));
			
			var grass_normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0xFFFFFF));
			
			var box_normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0xFFFFFF));
			
			
			bitmapCubeResource.upload(stage3D.context3D);
			smokeBitmapTextureResource.upload(stage3D.context3D);
			grass_diffuse.upload(stage3D.context3D);
			grass_normal.upload(stage3D.context3D);
			box_normal.upload(stage3D.context3D);
			smoke_normal.upload(stage3D.context3D);
			carBitmapTextureResource.upload(stage3D.context3D);
			// Camera and view
			camera = new Camera3D(0.1, 10000);
			camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 4);
			addChild(camera.view);
			addChild(camera.diagram);
			
			// Initial position
			camera.setPosition(350, 700, 0);
			camera.lookAt(0, 0, 0);
			
			camera.rotationY = Math.PI / 2;
			rootContainer = new Object3D();
			
			
			
			rootContainer.addChild(camera);
			
			// Light sources
			var ambientLight:AmbientLight = new AmbientLight(0x333333);
			ambientLight.intensity = 3;
			
			ambientLight.z = 200;
			ambientLight.y = -200;
			ambientLight.x = 200;
			
			rootContainer.addChild(ambientLight);
			
			
			
			directionalLight = new DirectionalLight(0xFFFF99);
			
			directionalLight.z = 200;
			directionalLight.y = 200;
			directionalLight.x = 200;
			
			directionalLight.intensity = 1;
			
			//directionalLight.lookAt(2000, 0, 0);
			directionalLight.lookAt(0, 0, 0);
			
			rootContainer.addChild(directionalLight);
			
			
			cubeMaterial = new VertexLightTextureMaterial(bitmapCubeResource, box_normal, 1);
			carMaterial = new VertexLightTextureMaterial(carBitmapTextureResource, box_normal, 1);
			//var material:TextureMaterial = new TextureMaterial(grass_normal, box_normal, 1);
			
			
			//var rgBody:RigidBody = physics.addBody((bgMaterial,1000,1000,1,1,true);
			var plObj:Object3D = new Object3D();
			
			var plane:Plane = new Plane(8000, 2000);
			plane.rotationX = Math.PI / 2;
			var planeMaterial:StandardMaterial = 
			new StandardMaterial(planeResource, grass_normal);
			
			plane.setMaterialToAllSurfaces(planeMaterial);
			plObj.addChild(plane);
			rootContainer.addChild(plObj);
			
			
			
			var smokeMaterial:StandardMaterial = 
			new StandardMaterial(smokeBitmapTextureResource, smoke_normal);
			
			smokeMaterial.alpha = 0.7;
			smokeMaterial.alphaThreshold = 1;
			smokeMaterial.lightMap = smoke_normal;
			
			
			spriteSmoke = new Sprite3dSmoke(rootContainer, 20, 20, 1, 3, smokeMaterial);
			
			
			// Shadow
			shadow = new DirectionalLightShadow(1000, 1000, -500, 500, 512, 2);
			shadow.biasMultiplier = 1;
			//shadow.addCaster(plane);
			//shadow.addCaster(box);
			directionalLight.shadow = shadow;
			
			
			
			
			for each (var resource:Resource in rootContainer.getResources(true)) {
				resource.upload(stage3D.context3D);
			}
			
			physics = new AbstractPhysics(6);
			var jGround:JPlane = 
				new JPlane(new Alternativa3DSkinObject(plObj), new Vector3D(0, 1, 0));
			
			jGround.y = 0;
			jGround.movable = false;
			physics.addBody(jGround);
			
			createBox();
			createCar();
			
			var jBox:JBox = createBox(1);
			jBox.x = 0;
			jBox.z = -300;
			jBox.y = -10;
			
			jBox.rotationZ = 45;
			jBox.movable = false;
			mBox.setMaterialToAllSurfaces(planeMaterial);
			
			addChild(hrefTxt = new TextField());
			with (hrefTxt) { border = background = true; selectable = false;
			x = 150; scaleX = scaleY = 1.4; backgroundColor = 0xFFFFFF; }
			hrefTxt.autoSize = TextFieldAutoSize.LEFT;
			var htmStr:String = '';
			htmStr = addStrHref('camA') + addStrHref('camB') 
			+ addStrHref('camC') + addStrHref('jump') + addStrHref('hover') + addStrHref('jump');
			
			
			hrefTxt.htmlText = htmStr;
			hrefTxt.addEventListener("link", txtNavHandler);
			
			// Listeners
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		private function smoothCamParam(cameraTagPos:Vector3D, p:String = 'x'):void {
			var cSpeed:Vector3D = cameraSpeedVector.clone();
			var leng:Number = Vector3D.distance(cameraPos, cameraTagPos);
			if (leng>200){
				trace('leng '+leng);
				leng *= 0.01;
				cSpeed.scaleBy(leng);
			}
			if (Math.abs(cameraPos[p] - cameraTagPos[p]) > cSpeed[p]) {
				if (cameraPos[p] > cameraTagPos[p]) cameraPos[p] -= cSpeed[p];
				if (cameraPos[p] < cameraTagPos[p]) cameraPos[p] += cSpeed[p];
			} else {
				cameraPos[p] -= (cameraPos[p] - cameraTagPos[p])*0.99;
			}
		}

		private function onEnterFrame(e:Event):void {
			var carContainerPosition:Vector3D = 
				new Vector3D(carContainer.x, carContainer.y, carContainer.z);
			
			physics.engine.integrate(0.12);
			
			updateWheelSkin();
			
			
			var pos:Vector3D = 
				new Vector3D(smokePosContainer.x, smokePosContainer.y, smokePosContainer.z)
			pos = carContainer.matrix.transformVector(pos);
			
			var cameraTagPos:Vector3D = new Vector3D( 0, 0, -200);
			cameraTagPos = carContainer.matrix.transformVector(cameraTagPos);
			cameraTagPos.y = 200;
			
			shadow.centerX = carContainerPosition.x;
			shadow.centerY = 0;
			shadow.centerZ = carContainerPosition.z;
			
			/*var camLimit:Number = 20;
			if (Math.abs(cameraPos.x - cameraTagPos.x) > camLimit) {
				if (cameraPos.x > cameraTagPos.x) cameraPos.x -= cameraSpeedVector.x;
				if (cameraPos.x < cameraTagPos.x) cameraPos.x += cameraSpeedVector.x;
			}
			*/

			
			if (carBody.chassis.getVelocity(carContainerPosition).length > 50) 
				spriteSmoke.update(pos,rootContainer);
			else spriteSmoke.updateAndDelete(pos);
			
			if (hoverTr) {
				smoothCamParam(cameraTagPos, 'x');
				//smoothCamParam(cameraTagPos, 'y');
				smoothCamParam(cameraTagPos, 'z');
				cameraPos.y = 200;
				var camMat:Matrix3D = awayLookAt(cameraPos, carContainerPosition,
				new Vector3D(0,-1,0), 1, 1, 1);
				camera.matrix = camMat;
			}
			camera.render(stage3D);
		}

		private function keyDownHandler(event:KeyboardEvent) : void
		{
			
			switch(event.keyCode)
			{
				case Keyboard.UP:
				case 87:
				{
					carBody.setAccelerate(1);
					break;
				}
				case Keyboard.DOWN:
				case 83:
				{
					carBody.setAccelerate(-1);
					break;
				}
				case Keyboard.LEFT:
				case 65:
				{
					carBody.setSteer(["WheelFL", "WheelFR"], 1);
					break;
				}
				case Keyboard.RIGHT:
				case 68:
				{
					carBody.setSteer(["WheelFL", "WheelFR"], -1);
					break;
				}
				case Keyboard.SPACE:
				{
					carBody.setHBrake(1);
					break;
				}
				default:
				{
					break;
				}
			}
		}


		private function keyUpHandler(event:KeyboardEvent) : void
		{
			trace(event.keyCode);
			switch(event.keyCode)
			{
				case Keyboard.UP:
				case 87:
				{
					carBody.setAccelerate(0);
					break;
				}
				case Keyboard.DOWN:
				case 83:
				{
					carBody.setAccelerate(0);
					break;
				}
				case Keyboard.LEFT:
				case 65:
				{
					carBody.setSteer(["WheelFL", "WheelFR"], 0);
					break;
				}
				case Keyboard.RIGHT:
				case 68:
				{
					carBody.setSteer(["WheelFL", "WheelFR"], 0);
					break;
				}
				case Keyboard.SPACE:
				{
					carBody.setHBrake(0);
				}
				default:
				{
					break;
				}
			}
			return;
		}

		private function createCar() : void {
			carContainer = new Object3D();
			rootContainer.addChild(carContainer);
			
			//carContainer.addChild(setupCube(40, 20, 90));
			
			carContainer.addChild(setupCarBody(40, 20, 90));
			//carContainer.addChild(CarMesh.makeCar(-40, 20, 90, shadow, carMaterial, stage3D));
			
			
			carContainer.addChild(smokePosContainer = new Object3D());
			position(smokePosContainer, new Vector3D( 5, 1, -45));
			
			var oWheelFR:Object3D = new Object3D();
			var oWheelFL:Object3D = new Object3D();
			
			var oWheelFR_PIVOT:Object3D = new Object3D();
			var oWheelFL_PIVOT:Object3D = new Object3D();
			
			var oWheelBR:Object3D = new Object3D();
			var oWheelBL:Object3D = new Object3D();
			
			var oWheelBR_PIVOT:Object3D = new Object3D();
			var oWheelBL_PIVOT:Object3D = new Object3D();
			
			carContainer.addChild(oWheelFR);
			oWheelFR.addChild(oWheelFR_PIVOT)
			oWheelFR_PIVOT.addChild(setupWheel(true));
			
			carContainer.addChild(oWheelFL);
			oWheelFL.addChild(oWheelFL_PIVOT);
			oWheelFL_PIVOT.addChild(setupWheel(false));
			
			carContainer.addChild(oWheelBR);
			oWheelBR.addChild(oWheelBR_PIVOT)
			var w:Mesh;
			oWheelBR_PIVOT.addChild(w = setupWheel(true));
			
			carContainer.addChild(oWheelBL);
			
			oWheelBL.addChild(oWheelBL_PIVOT);
			oWheelBL_PIVOT.addChild(w = setupWheel(false));
			
			oWheelFR.name = "WheelFR";
			position(oWheelFR, new Vector3D(20, -10, 25));
			
			oWheelFR_PIVOT.name = "WheelFR_PIVOT";
			
			oWheelFL.name = "WheelFL";
			position(oWheelFL, new Vector3D(-20, -10, 25));
			
			oWheelFL_PIVOT.name = "WheelFL_PIVOT";
			oWheelBR.name = "WheelBR";
			
			
			position(oWheelBR, new Vector3D(20, -10, -25));
			oWheelBR_PIVOT.name = "WheelBR_PIVOT";
			
			oWheelBL.name = "WheelBL";
			position(oWheelBL, new Vector3D(-20, -10, -25));
			oWheelBL_PIVOT.name = "WheelBL_PIVOT";
			
			carBody = new JCar(new Alternativa3DSkinObject(carContainer));
			
			carBody.setCar(40, 5, 500);
			carBody.chassis.moveTo(new Vector3D(200, 0, 0));
			carBody.chassis.rotationY = 90;
			carBody.chassis.mass = 9;
			carBody.chassis.sideLengths = new Vector3D(40, 20, 90);
			physics.addBody(carBody.chassis);
			
			carBody.setupWheel("WheelFL", new Vector3D(-20, -10, 25), 1.2, 1.5, 3, 8, 0.4, 0.5, 2);
			carBody.setupWheel("WheelFR", new Vector3D(20, -10, 25), 1.2, 1.5, 3, 8, 0.4, 0.5, 2);
			carBody.setupWheel("WheelBL", new Vector3D(-20, -10, -25), 1.2, 1.5, 3, 8, 0.4, 0.5, 2);
			carBody.setupWheel("WheelBR", new Vector3D(20, -10, -25), 1.2, 1.5, 3, 8, 0.4, 0.5, 2);
			
			steerFL = oGetChildByName(carContainer, "WheelFL");
			steerFR = oGetChildByName(carContainer, "WheelFR");
			wheelFL = oGetChildByName(carContainer, "WheelFL_PIVOT");
			wheelFR = oGetChildByName(carContainer, "WheelFR_PIVOT");
			wheelBL = oGetChildByName(carContainer, "WheelBL");
			wheelBR = oGetChildByName(carContainer, "WheelBR");
		}

		private function position(o:*, v:Vector3D):void {
			o.x = v.x;
			o.y = v.y;
			o.z = v.z;
		}

		private function updateWheelSkin() : void
		{
			/*
			carContainer.matrix = 
			JMatrix3D.getAppendMatrix3D(carBody.chassis.currentState.orientation, 
			JMatrix3D.getTranslationMatrix(carBody.chassis.currentState.position.x, 
			carBody.chassis.currentState.position.y, carBody.chassis.currentState.position.z));
			*/
			
			steerFL.rotationY = carBody.wheels["WheelFL"].getSteerAngle()*Math.PI/180;
			steerFR.rotationY = carBody.wheels["WheelFR"].getSteerAngle()*Math.PI/180;
			
			//wheelFL.pitch(carBody.wheels["WheelFL"].getRollAngle());
			wheelFL.rotationX += carBody.wheels["WheelFL"].getRollAngle()*Math.PI/180;
			
			//wheelFR.pitch(carBody.wheels["WheelFR"].getRollAngle());
			wheelFR.rotationX += carBody.wheels["WheelFR"].getRollAngle()*Math.PI/180;
			
			//wheelBL.roll(carBody.wheels["WheelBL"].getRollAngle());
			wheelBL.rotationX += carBody.wheels["WheelBL"].getRollAngle()*Math.PI/180;
			
			//wheelBR.roll(carBody.wheels["WheelBR"].getRollAngle());
			wheelBR.rotationX += carBody.wheels["WheelBR"].getRollAngle()*Math.PI/180;
			
			steerFL.y = carBody.wheels["WheelFL"].getActualPos().y;
			steerFR.y = carBody.wheels["WheelFR"].getActualPos().y;
			wheelBL.y = carBody.wheels["WheelBL"].getActualPos().y;
			wheelBR.y = carBody.wheels["WheelBR"].getActualPos().y;
			
		}

		private function oGetChildByName(o:Object3D, name:String):*{
			var o1:*;
			var o2:*;
			for (var i:int = 0; i < o.numChildren; i++) {
				o1 = o.getChildAt(i);
				trace(o1.name);
				if (o1.name == name) return o1;
				for (var j:int = 0; j < o1.numChildren; j++) {
					o2 = o1.getChildAt(j);
					if (o2.name == name) return o2;
				}
			}
			return null;
		}

		private function setupCarBody(sx:Number,sy:Number,sz:Number) : Mesh
		{
			include '\\helloalternativa3d\\blender3d\\myBlenderMesh.txt'
			
			
			return Blender3DMesh.makeMeshFromBlender(
			meVertices,
			meIndex,
			meUv,
			sx, sy, sz, shadow, carMaterial, stage3D);
			
			
		}

		private function setupWheel(rotateTr:Boolean) : Mesh
		{
			/*var meVertices:Array = [1,1,-1,1,-1,-1,-1,-1,-1,-1,1,-1,1,1,1,1,-1,1,-1,-1,1,-1,1,1];
			var meIndex:Array = [0,1,2,0,2,3,4,7,6,4,6,5,0,4,5,0,5,1,1,5,6,1,6,2,2,6,7,2,7,3,4,0,3,4,3,7];
			var meUv:Array = [1, 0, 2 / 3, 0, 2 / 3, 0.5, 1, 0, 2 / 3, 0.5, 1, 0.5, 1 / 3, 0, 0, 0, 0, 0.5, 
			1 / 3, 0, 0, 0.5, 1 / 3, 0.5, 1 / 3, 0.5, 0, 0.5, 0, 1, 1 / 3, 0.5, 0, 1, 1 / 3, 1, 2 / 3, 0, 
			1 / 3, 0, 1 / 3, 0.5, 2 / 3, 0, 1 / 3, 0.5, 2 / 3, 0.5, 2 / 3, 0.5, 1 / 3, 0.5, 1 / 3, 1, 
			2 / 3, 0.5, 1 / 3, 1, 2 / 3, 1, 1, 0.5, 2 / 3, 0.5, 2 / 3, 1, 1, 0.5, 2 / 3, 1, 1, 1];
			*/
			include '\\helloalternativa3d\\blender3d\\myBlenderCylider.txt'
			
			var m:Matrix3D = null;
			if (rotateTr) {
				m = new Matrix3D();
				m.appendRotation(180, Vector3D.Y_AXIS);
			}
			return Blender3DMesh.makeMeshFromBlender(
			meVertices,
			meIndex,
			meUv,
			5, 17, 17, shadow, carMaterial, stage3D,m);
			
			
		}

		private function setupCube(sx:Number = 100, sy:Number = 100, sz:Number = 100):Mesh {
			var meVertices:Array = [1,1,-1,1,-1,-1,-1,-1,-1,-1,1,-1,1,1,1,1,-1,1,-1,-1,1,-1,1,1];
			var meIndex:Array = [0,1,2,0,2,3,4,7,6,4,6,5,0,4,5,0,5,1,1,5,6,1,6,2,2,6,7,2,7,3,4,0,3,4,3,7];
			var meUv:Array = [1, 0, 2 / 3, 0, 2 / 3, 0.5, 1, 0, 2 / 3, 0.5, 1, 0.5, 1 / 3, 0, 0, 0, 0, 0.5, 
			1 / 3, 0, 0, 0.5, 1 / 3, 0.5, 1 / 3, 0.5, 0, 0.5, 0, 1, 1 / 3, 0.5, 0, 1, 1 / 3, 1, 2 / 3, 0, 
			1 / 3, 0, 1 / 3, 0.5, 2 / 3, 0, 1 / 3, 0.5, 2 / 3, 0.5, 2 / 3, 0.5, 1 / 3, 0.5, 1 / 3, 1, 
			2 / 3, 0.5, 1 / 3, 1, 2 / 3, 1, 1, 0.5, 2 / 3, 0.5, 2 / 3, 1, 1, 0.5, 2 / 3, 1, 1, 1];
			return Blender3DMesh.makeMeshFromBlender(meVertices, meIndex, meUv, sx, sy, sz, shadow, cubeMaterial, stage3D);
			//return mesh;
		}

		private function createBox(leng:uint = 4) : JBox
		{
			var i:int;
			while (i < leng)
			{
				var box:Mesh = mBox = setupCube(100, 100, 100);
				box.z = 100;
				
				rootContainer.addChild(box);
				
				var jBox:JBox = new JBox(new Alternativa3DSkinObject(box), 100, 100, 100);
				physics.addBody(jBox);
				
				jBox.y = 102 * (i+1);
				i++;
			}
			return jBox;
		}

		private function txtNavHandler(e:TextEvent):void {
			if (e.text == 'camA') {
				camera.setPosition(0, 2000, 0);
				camera.lookAt(0, 0, 0);
				camera.rotationY = Math.PI / 2;
				hoverTr = false;
			}
			
			if (e.text == 'camB') {
				camera.setPosition(350, 700, 0);
				camera.lookAt(0, 0, 0);
				camera.rotationY = Math.PI / 2;
				hoverTr = false;
			}
			
			if (e.text == 'camC') {
				camera.setPosition(-568, 128, 75);
				camera.lookAt(0, 0, 0);
				camera.rotationY = -Math.PI / 2;
				hoverTr = false;
			}
			if (e.text == 'hover') {
				hoverTr = true;
			}
			if (e.text == 'jump') {
				carBody.chassis.applyBodyWorldImpulse(new Vector3D(0, 100, 0), new Vector3D(10, 0, 10), true);
			}
		}

		private function addStrHref(str:String, delimStr:String = ' | '):String {
			return "<a href='event:" + str + "'>" + str + "<u></u>"+delimStr; 
		}

		public  function makeBlaBmd():BitmapData {
			var s:Sprite = new Sprite();
			var sh:Shape = new Shape();
			var b:Bitmap;
			var e:Number = 128;
			s.addChild(makeABitmap('A'));
			s.addChild(b = makeABitmap('B'));
			b.x = e;
			s.addChild(b = makeABitmap('C'));
			b.x = e * 2;
			s.addChild(b = makeABitmap('D'));
			b.y = e;
			s.addChild(b = makeABitmap('E'));
			b.x = e; b.y = e;
			s.addChild(b = makeABitmap('F'));
			b.x = e * 2; b.y = e;
			s.addChild(sh);
			sh.graphics.lineStyle(24, 0xFF8000);
			for (var i:int; i < 6; i++) {
				sh.graphics.drawRect(i % 3 * e, int(i / 3) * e, e, e);
			}
			var bmd:BitmapData = new BitmapData(256, 256);
			var m:Matrix = new Matrix();
			m.scale(1 / 1.5, 1);
			bmd.draw(s, m);
			//addChild(new Bitmap(bmd));////show my cube textures
			return bmd;
		}

		public function makeABitmap(str:String = 'A'):Bitmap {
			var txt:TextField = new TextField();
			txt.htmlText = 
			'<FONT FACE="courier" SIZE="12" COLOR="0" LETTERSPACING="0" KERNING="0"><b>' +
			str + '</b></FONT></P>';
			
			var tbmd:BitmapData = new BitmapData(128, 128);
			var m:Matrix = new Matrix();
			m.ty = -4;
			m.tx = -2;
			m.scale(13, 13);
			tbmd.draw(txt,m);
			return new Bitmap(tbmd);
		}

		public function getPerlinBmd():BitmapData {
			var s:Number = 512;
			var bitmapData:BitmapData = new BitmapData(s, s, true);
			var numOctaves:Number = 1;
			bitmapData.perlinNoise(25, 52, 1, 1314, false, false, 10, false)
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xFFFFFF);
			sp.graphics.drawRect(0, 0, s, s);
			sp.addChild(new Bitmap(bitmapData));
			var resBitmap:BitmapData = new BitmapData(s, s, true);
			sp.graphics.lineStyle(5, 0x808080);
			sp.graphics.beginFill(0xFF8040, 0.5);
			sp.graphics.drawRect(0, 320, 512, 25);
			resBitmap.draw(sp);
			return resBitmap;
		}

		//thx http://redefy.net/2012/02/19/away3d4-controllers/
		public function awayLookAt(position:Vector3D, target : Vector3D, upAxis : Vector3D = null, scaleX:Number = 1, scaleY:Number = 1, scaleZ:Number = 1) : Matrix3D {
			var yAxis : Vector3D, zAxis : Vector3D, xAxis : Vector3D;
			var raw : Vector.<Number>;
			
			zAxis = target.subtract(position);
			zAxis.normalize();
			
			xAxis = upAxis.crossProduct(zAxis);
			xAxis.normalize();
		 
			if (xAxis.length < .05) {
				xAxis = upAxis.crossProduct(Vector3D.Z_AXIS);
			}
			
			yAxis = zAxis.crossProduct(xAxis);
			
			raw = new Vector.<Number>(16);
			
			var _x:Number = position.x;
			var _y:Number = position.y;
			var _z:Number = position.z;
			
			raw[0] = scaleX*xAxis.x;
			raw[1] = scaleX*xAxis.y;
			raw[2] = scaleX*xAxis.z;
			raw[3] = 0;
		 
			raw[4] = scaleY*yAxis.x;
			raw[5] = scaleY*yAxis.y;
			raw[6] = scaleY*yAxis.z;
			raw[7] = 0;
		 
			raw[8] = scaleZ*zAxis.x;
			raw[9] = scaleZ*zAxis.y;
			raw[10] = scaleZ*zAxis.z;
			raw[11] = 0;
		 
			raw[12] = _x;
			raw[13] = _y;
			raw[14] = _z;
			raw[15] = 1;
			
			var transform:Matrix3D = new Matrix3D(raw);
			return transform;
		}

	}
}
