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
   
   public dynamic class Button extends MovieClip
   {
       
      
      public var mBind:MovieClip;
      
      public var mLabel:Sprite;
      
      public var mCallback:Function;
      
      public var mOver:Boolean;
      
      public var mKeybind:KeyBind;
      
      public function Button()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init(param1:String, param2:String, param3:Function, param4:DisplayObject = null) : *
      {
         stop();
         this.mCallback = param3;
         this.mOver = false;
         this.mLabel = new Sprite();
         addChild(this.mLabel);
         if(param4)
         {
            this.mLabel.addChild(param4);
         }
         addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         addEventListener(Event.ADDED_TO_STAGE,this.OnAddToStage);
         this.mKeybind = new KeyBind(param1,param2,0);
         this.mKeybind.addEventListener(KeyboardEvent.KEY_DOWN,this.OnAction);
         this.mKeybind.addEventListener(KeyboardEvent.KEY_UP,this.OnAction);
         this.mKeybind.addEventListener(Event.CHANGE,this.OnRebind);
         this.BindToKey(0);
         this.RefreshState();
         if(param1 != "")
         {
            Singleton.Get(KeyRebinder).AddKeyBind(this.mKeybind);
         }
      }
      
      public function OnAddToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.OnAddToStage);
         this.mKeybind.mId;
         this.mKeybind.SetListener(stage);
      }
      
      public function BindToKey(param1:int) : *
      {
         this.mKeybind.Rebind(param1);
      }
      
      public function OnRebind(param1:Event) : *
      {
         this.mBind.ShowKeybind(this.mKeybind.keyCode);
      }
      
      public function OnMouseOver(param1:MouseEvent) : void
      {
         this.mOver = true;
         this.RefreshState();
      }
      
      public function OnMouseOut(param1:MouseEvent) : void
      {
         this.mOver = false;
         this.RefreshState();
      }
      
      public function OnMouseDown(param1:MouseEvent) : void
      {
         this.mKeybind.Press();
         stage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         param1.stopImmediatePropagation();
      }
      
      public function OnAction(param1:KeyboardEvent) : void
      {
         this.mCallback(param1.type == KeyboardEvent.KEY_DOWN);
         this.RefreshState();
      }
      
      public function OnMouseUp(param1:MouseEvent) : void
      {
         this.mKeybind.Release();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
      }
      
      public function RefreshState() : void
      {
         if(this.mKeybind.down && this.mOver)
         {
            gotoAndStop(3);
         }
         else if(this.mOver || this.mKeybind.down)
         {
            gotoAndStop(2);
         }
         else
         {
            gotoAndStop(1);
         }
         this.mLabel.y = currentFrame == 3 ? 2 : 0;
         addChild(this.mLabel);
      }
      
      internal function frame1() : *
      {
      }
   }
}
