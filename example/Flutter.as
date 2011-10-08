package 
{
	import a3dparticle.animators.actions.AccelerateAction;
	import a3dparticle.animators.actions.ChangeColorByLifeAction;
	import a3dparticle.animators.actions.DriftAction;
	import a3dparticle.animators.actions.OffestDistanceAction;
	import a3dparticle.animators.actions.PerParticleAction;
	import a3dparticle.animators.actions.RandomColorAction;
	import a3dparticle.animators.actions.ScaleByTimeAction;
	import a3dparticle.animators.actions.VelocityAction;
	import a3dparticle.materials.SimpleParticleMaterial;
	import a3dparticle.ParticlesContainer;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.primitives.Sphere;
	import away3d.primitives.WireframeAxesGrid;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author liaocheng
	 */
	[SWF(width="1024", height="768", frameRate="60")]
	public class Flutter extends Sprite 
	{
		protected var _view:View3D;
		
		private var particle:ParticlesContainer;
		
		public function Flutter():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			// entry point
			_view = new View3D();
			_view.width = 1024;
			_view.height = 768;
			_view.antiAlias = 4;
			addChild(_view);
			addEventListener(Event.ENTER_FRAME, onRender);
			addChild(new AwayStats(_view));
			new HoverDragController(_view.camera, stage);
			_view.scene.addChild(new WireframeAxesGrid(4,1000));
			initScene();
		}
		
		
		
		private function initScene():void
		{
			var material:SimpleParticleMaterial = new SimpleParticleMaterial(new BitmapData(2, 2, true, 0xFFFFFFFF));
			//the amount of particles are 2000
			particle = new ParticlesContainer(2000,material);
			_view.scene.addChild(particle);
			
			var sphere:Sphere = new Sphere(null, 10,4,4);
			
			particle.startTimeFun = function(index:uint):Number { return 1+Math.random()*3.1; };
			particle.endTimeFun = function(index:uint):Number { return Math.random() * 3.1; };
			particle.loop = true;
			
			var offset_pos :Function = function(index:uint):Vector3D
			{
				var r:Number = Math.random() *100;
				var degree:Number = Math.random() * Math.PI*2;
				var x:Number = r * Math.cos(degree);
				var z:Number = r * Math.sin(degree);
				return new Vector3D(x, -600, z);
			}
			var velocit_pos:Function= function(index:uint):Vector3D
			{
				var r:Number = Math.random() * 200;
				var degree:Number = Math.random() * Math.PI*2;
				var x:Number = r * Math.cos(degree);
				var z:Number = r * Math.sin(degree);
				return new Vector3D(x, 900, z);
			}
			
			var action:PerParticleAction = new VelocityAction(velocit_pos);
			particle.addPerParticleAction(action);
			
			
			var action2:AccelerateAction = new AccelerateAction(new Vector3D(0, -400, 0));
			particle.addAllParticleAction(action2);
			
			var action3:OffestDistanceAction = new OffestDistanceAction(offset_pos);
			particle.addPerParticleAction(action3);
			
			var action4:ChangeColorByLifeAction = new ChangeColorByLifeAction(new ColorTransform(1,0.6,1,0.5,0,0),new ColorTransform(1,0.8,1,0.3,0,0) );
			particle.addAllParticleAction(action4);
			
			var action5:DriftAction = new DriftAction(function(index:uint):Vector3D { return new Vector3D(-100,0,0,1); } );
			particle.addPerParticleAction(action5);
			particle.generate(sphere.geometry.subGeometries[0]);
			particle.start();
		}

		
		private function onRender(e:Event):void
		{
			_view.render();
		}
		private function onStageResize(e:Event):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
		
	}
	
}