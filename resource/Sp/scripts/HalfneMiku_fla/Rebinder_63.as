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
   
   public dynamic class Rebinder_63 extends MovieClip
   {
       
      
      public var mBind:MovieClip;
      
      public var mMouseOver:Boolean;
      
      public var mRebinding:Boolean;
      
      public var mKeyBind:KeyBind;
      
      public function Rebinder_63()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init(param1:KeyBind) : *
      {
         this.mMouseOver = false;
         this.mRebinding = false;
         this.RefreshState();
         addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseLeave);
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         this.mKeyBind = param1;
         param1.addEventListener(Event.CHANGE,this.OnRebind);
         this.OnRebind(null);
      }
      
      public function OnRebind(param1:Event) : void
      {
         this.mBind.ShowKeybind(this.mKeyBind.keyCode);
         var _loc2_:Rectangle = this.mBind.getBounds(this);
         _loc2_.width = this.mBind.GetWidth();
         this.mBind.x = 32 - _loc2_.width / 2 + (this.mBind.x - _loc2_.left) / 2;
      }
      
      public function OnMouseOver(param1:MouseEvent) : void
      {
         this.mMouseOver = true;
         this.RefreshState();
      }
      
      public function OnMouseLeave(param1:MouseEvent) : void
      {
         this.mMouseOver = false;
         this.RefreshState();
      }
      
      public function OnMouseDown(param1:MouseEvent) : void
      {
         this.mRebinding = !this.mRebinding;
         this.RefreshState();
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.OnKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.OnKeyDown);
      }
      
      public function OnKeyDown(param1:KeyboardEvent) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.OnKeyDown);
         this.mRebinding = false;
         this.RefreshState();
         if(param1.keyCode == Keyboard.DELETE)
         {
            param1.keyCode = 0;
         }
         if(param1.keyCode != Keyboard.ESCAPE)
         {
            this.mKeyBind.Rebind(param1.keyCode);
         }
      }
      
      public function RefreshState() : void
      {
         if(this.mRebinding)
         {
            this.mBind.visible = false;
            gotoAndStop("rebind");
         }
         else
         {
            this.mBind.visible = true;
            gotoAndStop(this.mMouseOver ? "over" : "idle");
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}
