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
   
   public dynamic class KeyRebinder extends Draggable
   {
       
      
      public var mRebindables:Vector.<RebindableKey>;
      
      public var mWindow:Sprite;
      
      public const ROW_SPACING:Number = 30;
      
      public function KeyRebinder()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         SetDragTarget(this);
         this.mRebindables = new Vector.<RebindableKey>();
         this.mWindow = new Sprite();
         addChild(this.mWindow);
         this.mWindow.scrollRect = new Rectangle(0,0,300,260);
         this.mWindow.x = -140;
         this.mWindow.y = -120;
         Singleton.Set(KeyRebinder,this);
         mSlider.Init();
         mSlider.addEventListener(Event.CHANGE,this.OnSlide);
         mClose.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:Event):*
         {
            Toggle();
         });
         this.Toggle();
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:Event):*
         {
            param1.stopPropagation();
         });
      }
      
      public function Toggle() : *
      {
         visible = !visible;
         if(visible)
         {
            stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.OnScroll);
         }
         else
         {
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.OnScroll);
         }
      }
      
      public function AddKeyBind(param1:KeyBind) : void
      {
         var _loc2_:RebindableKey = new RebindableKey();
         _loc2_.Init(param1);
         this.mWindow.addChild(_loc2_);
         _loc2_.y = this.mRebindables.length * this.ROW_SPACING;
         this.mRebindables.push(_loc2_);
         mSlider.SetSteps((_loc2_.y - this.mWindow.scrollRect.height) / this.ROW_SPACING + 1);
      }
      
      public function OnSlide(param1:Event) : void
      {
         var _loc2_:Number = Number(mSlider.GetPercent());
         var _loc3_:* = this.mRebindables.length * this.ROW_SPACING - this.mWindow.scrollRect.height;
         if(_loc3_ > 0)
         {
            this.mWindow.scrollRect = new Rectangle(0,_loc3_ * _loc2_,300,260);
         }
      }
      
      public function OnScroll(param1:MouseEvent) : void
      {
         mSlider.Scroll(-param1.delta);
      }
      
      internal function frame1() : *
      {
      }
   }
}
