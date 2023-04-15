package HalfneMiku_fla
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public dynamic class MainTimeline extends MovieClip
   {
       
      
      public var Miku:MovieClip;
      
      public var Timeliner:Timeline;
      
      public var myBackdrop:Backdrop;
      
      public var HelpInterface:MovieClip;
      
      public var Rebinder:KeyRebinder;
      
      public var UI:MovieClip;
      
      public var mTicker:Number;
      
      public var W:Number;
      
      public var H:Number;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(1,this.frame2);
      }
      
      public function OnAddedToStage(param1:Event = null) : void
      {
         stop();
         this.Miku.Init();
         this.Rebinder.Init();
         this.UI.Init();
         this.myBackdrop.Init();
         this.HelpInterface.Init();
         this.Timeliner.Init();
         this.mTicker = 0;
         Director.self.addEventListener(Director.ON_DIRECT,this.OnDirectorPlayback);
         addEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
      }
      
      public function InverseTransformControl(param1:Point) : Point
      {
         var _loc2_:Point = new Point(Math.tan(param1.x * Math.PI / 2) / 4,Math.tan(param1.y * Math.PI / 2) / 4);
         _loc2_.x = _loc2_.x * this.W + this.W / 2;
         _loc2_.y = _loc2_.y * this.H + this.H / 2;
         return _loc2_;
      }
      
      public function OnEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = 1 / stage.frameRate;
         this.mTicker += _loc2_;
         var _loc3_:Point = new Point((mouseX - this.W / 2) / this.W,(mouseY - this.H / 2) / this.H);
         _loc3_.x = Math.atan(_loc3_.x * 4) / Math.PI * 2;
         _loc3_.y = Math.atan(_loc3_.y * 4) / Math.PI * 2;
         if(this.ControlOverride != null)
         {
            this.ControlOverride(_loc3_);
         }
         this.Miku.SetControl(_loc3_);
         this.Miku.Update(_loc2_);
         this.UI.Update(_loc2_);
      }
      
      public function TrackStack(param1:String, param2:*, param3:Boolean = true) : void
      {
         Director.self.Direct("stack",{
            "stack":param1,
            "val":param2,
            "push":param3
         });
         this.ExecuteEvent(param1,param2,param3);
      }
      
      public function OnDirectorPlayback(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         if(Director.self.command == "playback")
         {
            _loc2_ = Director.self.args;
            _loc3_ = String(_loc2_.stack);
            _loc4_ = _loc2_.val;
            this.ExecuteEvent(_loc2_.stack,_loc2_.val,_loc2_.activate);
         }
      }
      
      public function ExecuteEvent(param1:String, param2:*, param3:Boolean = true) : void
      {
         switch(param1)
         {
            case "phase":
               this.Miku.StackMouth(param2,param3);
               break;
            case "blink":
               this.Miku.head.face.eyes.Blink(param3);
               break;
            case "eyes":
               this.Miku.head.face.eyes.ChangeSet(param2);
               break;
            case "mouth":
               this.Miku.head.face.mouth.ChangeSet(param2);
         }
      }
      
      internal function frame2() : *
      {
         this.W = 800;
         this.H = 600;
         if(stage)
         {
            this.OnAddedToStage();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage);
         }
         this.UI.addEventListener("OnSetEyes",function(param1:Event):*
         {
            var _loc2_:* = param1.target.GetEventArgs(param1.type);
            TrackStack("eyes",_loc2_.eye_set,true);
         });
         this.UI.addEventListener("OnBlink",function(param1:Event):*
         {
            var _loc2_:* = param1.target.GetEventArgs(param1.type);
            TrackStack("blink",_loc2_.eye_set,_loc2_.shut);
         });
         this.UI.addEventListener("OnSetMouth",function(param1:Event):*
         {
            var _loc2_:* = param1.target.GetEventArgs(param1.type);
            TrackStack("mouth",_loc2_.mouth_set,true);
         });
         this.UI.addEventListener("OnMouthPhase",function(param1:Event):*
         {
            var _loc2_:* = param1.target.GetEventArgs(param1.type);
            TrackStack("phase",_loc2_.phase,_loc2_.start);
         });
         this.UI.addEventListener("OnSetBackdrop",function(param1:Event):*
         {
            var _loc2_:* = param1.target.GetEventArgs(param1.type);
            if(_loc2_.data)
            {
               myBackdrop.LoadData(_loc2_.data);
            }
            else
            {
               myBackdrop.LoadBg(_loc2_.frame);
            }
         });
         this.UI.addEventListener("OnTransformBackdrop",function(param1:Event):*
         {
            var _loc2_:* = param1.target.GetEventArgs(param1.type);
            if(_loc2_.reset)
            {
               myBackdrop.Autofit();
               myBackdrop.SetMouseMode(null);
            }
            else if(_loc2_.move)
            {
               myBackdrop.SetMouseMode("move");
            }
            else if(_loc2_.zoom)
            {
               myBackdrop.SetMouseMode("zoom");
            }
         });
         this.UI.addEventListener("OnToggleStudio",function(param1:Event):*
         {
            Timeliner.Toggle();
         });
         this.UI.addEventListener("OnHelp",function(param1:Event):*
         {
            HelpInterface.Display("general");
         });
      }
   }
}
