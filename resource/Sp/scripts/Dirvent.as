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
   
   public dynamic class Dirvent extends MovieClip
   {
       
      
      public const MIN_DUR_MS:Number = 33.333333333333336;
      
      public var mEntry:DirectorEvent;
      
      public var c_PIX_PER_MS:Number;
      
      public var mClickMode:int;
      
      public var mLastMousePos:Number;
      
      public var mBlock:Sprite;
      
      public var mDeIcon:DeIcon;
      
      public const CLICK_MODE_NONE:int = 0;
      
      public const CLICK_MODE_EARLIER:int = 1;
      
      public const CLICK_MODE_LATER:int = 2;
      
      public const CLICK_MODE_SHIFT:int = 3;
      
      public function Dirvent()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init(param1:DirectorEvent) : void
      {
         this.mEntry = param1;
         this.mClickMode = this.CLICK_MODE_NONE;
         this.c_PIX_PER_MS = Singleton.Get(DirectorView).PIXELS_PER_SEC * 0.001;
         this.mBlock = new Sprite();
         var _loc2_:Graphics = this.mBlock.graphics;
         _loc2_.beginFill(8454143,0.5);
         _loc2_.lineStyle(0,8454143);
         _loc2_.drawRect(0,0,100,15);
         addChild(this.mBlock);
         this.mDeIcon = new DeIcon();
         this.mDeIcon.width = this.mDeIcon.height = 15;
         this.mDeIcon.Load(this.mEntry);
         this.Display(this.mEntry);
         this.mEntry.addEventListener(Event.CHANGE,this.OnEventChange);
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut);
      }
      
      public function Finalize() : void
      {
         this.mDeIcon.Finalize();
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.OnKeyDown);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         removeEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut);
         Director.self.removeEventListener(Director.ON_DIRECT,this.OnDirect);
         parent.removeChild(this);
      }
      
      public function Display(param1:DirectorEvent) : void
      {
         x = param1.start_ms * this.c_PIX_PER_MS;
         if(param1.indefinite)
         {
            gotoAndStop("indefinite");
            this.DrawBar(0);
         }
         else
         {
            gotoAndStop("definite");
            this.DrawBar(param1.dur_ms * this.c_PIX_PER_MS);
         }
         addChild(this.mDeIcon);
      }
      
      public function DrawBar(param1:Number) : void
      {
         this.mBlock.width = param1;
      }
      
      public function OnMouseOver(param1:MouseEvent) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.OnKeyDown);
         Director.self.addEventListener(Director.ON_DIRECT,this.OnDirect);
      }
      
      public function OnMouseOut(param1:MouseEvent) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.OnKeyDown);
         Director.self.removeEventListener(Director.ON_DIRECT,this.OnDirect);
      }
      
      public function OnMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         parent.addChild(this);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         this.mLastMousePos = parent.mouseX;
         _loc2_ = this.mBlock.width;
         var _loc3_:Number = Math.min(12,_loc2_ / 4);
         if(this.mEntry.indefinite)
         {
            this.mClickMode = this.CLICK_MODE_SHIFT;
         }
         else if(mouseX < _loc3_)
         {
            this.mClickMode = this.CLICK_MODE_EARLIER;
         }
         else if(mouseX > _loc2_ - _loc3_)
         {
            this.mClickMode = this.CLICK_MODE_LATER;
         }
         else
         {
            this.mClickMode = this.CLICK_MODE_SHIFT;
         }
         param1.stopImmediatePropagation();
      }
      
      public function OnMouseUp(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         this.mClickMode = this.CLICK_MODE_NONE;
      }
      
      public function OnMouseMove(param1:MouseEvent) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:* = parent.mouseX - this.mLastMousePos;
         this.mLastMousePos += _loc2_;
         var _loc3_:Number = _loc2_ / this.c_PIX_PER_MS;
         if(this.mClickMode == this.CLICK_MODE_EARLIER)
         {
            if((_loc4_ = this.mEntry.start_ms + _loc3_) > this.mEntry.end_ms - this.MIN_DUR_MS)
            {
               this.mLastMousePos -= (this.mEntry.end_ms - _loc4_ + this.MIN_DUR_MS) * this.c_PIX_PER_MS;
               _loc4_ = this.mEntry.end_ms - this.MIN_DUR_MS;
            }
            this.mEntry.start_ms = _loc4_;
         }
         else if(this.mClickMode == this.CLICK_MODE_LATER)
         {
            if((_loc5_ = this.mEntry.end_ms + _loc3_) < this.mEntry.start_ms + this.MIN_DUR_MS)
            {
               this.mLastMousePos += (this.mEntry.start_ms - _loc5_ + this.MIN_DUR_MS) * this.c_PIX_PER_MS;
               _loc5_ = this.mEntry.start_ms + this.MIN_DUR_MS;
            }
            this.mEntry.end_ms = _loc5_;
         }
         else
         {
            this.mEntry.ShiftTime(_loc3_);
         }
      }
      
      public function OnEventChange(param1:Event) : void
      {
         this.Display(this.mEntry);
      }
      
      public function OnKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.DELETE || param1.keyCode == Keyboard.BACKSPACE)
         {
            dispatchEvent(new Event(Event.CLEAR));
         }
      }
      
      public function OnDirect(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         if(Director.self.command == "stack")
         {
            _loc2_ = Director.self.args;
            _loc3_ = String(_loc2_.stack);
            _loc4_ = Boolean(_loc2_.push);
            if(_loc3_ == this.mEntry.stack_id && _loc4_)
            {
               this.mEntry.val = _loc2_.val;
               this.mDeIcon.Load(this.mEntry);
            }
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}
