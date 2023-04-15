package
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
   
   public dynamic class Mouth extends MovieClip
   {
       
      
      public var mSet:String;
      
      public var mPhase:int;
      
      public const PHASE_MAP = {};
      
      public function Mouth()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         this.PHASE_MAP["m"] = 0;
         this.PHASE_MAP["a"] = 1;
         this.PHASE_MAP["i"] = 2;
         this.PHASE_MAP["u"] = 3;
         this.PHASE_MAP["e"] = 4;
         this.PHASE_MAP["o"] = 5;
         this.PHASE_MAP["n"] = 6;
         this.mSet = "happy";
         this.ChangePhase("m");
      }
      
      public function ChangeSet(param1:String) : *
      {
         this.mSet = param1;
         this.UpdateFrame();
      }
      
      public function ChangePhase(param1:String) : *
      {
         if(param1 == "?")
         {
            this.mPhase = Math.floor(1 + 5 * Math.random());
         }
         else
         {
            this.mPhase = this.PHASE_MAP[param1];
         }
         this.UpdateFrame();
      }
      
      public function GetPhase() : String
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.PHASE_MAP)
         {
            if(this.mPhase == this.PHASE_MAP[_loc1_])
            {
               return _loc1_;
            }
         }
         return "m";
      }
      
      public function UpdateFrame() : *
      {
         gotoAndStop(this.mSet);
         gotoAndStop(currentFrame + this.mPhase);
      }
      
      internal function frame1() : *
      {
      }
   }
}
