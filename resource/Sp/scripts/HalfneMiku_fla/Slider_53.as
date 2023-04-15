package HalfneMiku_fla
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public dynamic class Slider_53 extends MovieClip
   {
       
      
      public var mThumb:Sprite;
      
      public var mSteps:int;
      
      public var mBounds:Rectangle;
      
      public var mDragOffset:Number;
      
      public function Slider_53()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : void
      {
         this.mBounds = this.getBounds(this);
         this.mSteps = 0;
         this.mThumb = new Sprite();
         addChild(this.mThumb);
         var _loc1_:Graphics = this.mThumb.graphics;
         _loc1_.beginFill(6353136);
         _loc1_.drawRect(0,0,15,15);
         this.mThumb.addEventListener(MouseEvent.MOUSE_DOWN,this.OnDragStart);
      }
      
      public function SetSteps(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         this.mSteps = param1;
         if(this.mSteps > 0)
         {
            this.mThumb.visible = true;
            _loc2_ = Math.max(1 / (1 + this.mSteps),0.1);
            this.mThumb.height = _loc2_ * (this.mBounds.height - this.mThumb.height);
         }
         else
         {
            this.mThumb.visible = false;
         }
      }
      
      public function GetPercent() : Number
      {
         return this.mThumb.y / (this.mBounds.height - this.mThumb.height);
      }
      
      public function GetStep() : Number
      {
         return this.mSteps * this.GetPercent();
      }
      
      public function Scroll(param1:int) : void
      {
         var _loc2_:Number = this.GetPercent();
         var _loc3_:Number = Math.max(0,Math.min((this.GetStep() + param1) / this.mSteps,1));
         if(_loc3_ != _loc2_)
         {
            this.mThumb.y = _loc3_ * (this.mBounds.height - this.mThumb.height);
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function OnDragStart(param1:MouseEvent) : void
      {
         this.mDragOffset = this.mThumb.mouseY;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.OnDragStop);
         param1.stopImmediatePropagation();
      }
      
      public function OnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.GetPercent();
         this.mThumb.y += this.mThumb.mouseY - this.mDragOffset;
         this.mThumb.y = Math.max(0,Math.min(this.mThumb.y,this.mBounds.bottom - this.mThumb.height));
         if(_loc2_ != this.GetPercent())
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function OnDragStop(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnDragStop);
      }
      
      internal function frame1() : *
      {
      }
   }
}
