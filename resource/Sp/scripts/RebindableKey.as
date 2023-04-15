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
   
   public dynamic class RebindableKey extends MovieClip
   {
       
      
      public var mDisplayName:TextField;
      
      public var mRebinder:MovieClip;
      
      public var mKeyBind:KeyBind;
      
      public function RebindableKey()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init(param1:KeyBind) : void
      {
         this.mKeyBind = param1;
         this.mDisplayName.text = param1.name;
         this.mRebinder.Init(param1);
      }
      
      internal function frame1() : *
      {
      }
   }
}
