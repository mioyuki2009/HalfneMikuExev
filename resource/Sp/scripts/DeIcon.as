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
   
   public dynamic class DeIcon extends MovieClip
   {
       
      
      public var mEyes:Eyes;
      
      public var mText:TextField;
      
      public var mMouth:Mouth;
      
      public var mIcon:Icon;
      
      public var mClip:MovieClip;
      
      public function DeIcon()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Load(param1:DirectorEvent) : void
      {
         this.Unload();
         scrollRect = new Rectangle(0,0,20,20);
         switch(param1.stack_id)
         {
            case "phase":
               if(param1.val == "?")
               {
                  gotoAndStop("icon");
                  this.mIcon.gotoAndStop("random");
               }
               else
               {
                  gotoAndStop("mouth");
                  this.mMouth.Init();
                  this.mMouth.ChangePhase(param1.val);
                  this.mText.text = param1.val.toUpperCase();
               }
               break;
            case "blink":
               gotoAndStop("icon");
               this.mIcon.gotoAndStop("blink");
               break;
            case "eyes":
               gotoAndStop("eyes");
               this.mEyes.Init();
               this.mEyes.ChangeSet(param1.val);
               break;
            case "mouth":
               gotoAndStop("mouth");
               this.mMouth.Init();
               this.mMouth.ChangeSet(param1.val);
               this.mText.text = "";
               break;
            default:
               throw new Error("unhandled stack_id: " + param1.stack_id);
         }
      }
      
      public function Unload() : *
      {
         gotoAndStop(1);
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      public function Finalize() : *
      {
         this.Unload();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
