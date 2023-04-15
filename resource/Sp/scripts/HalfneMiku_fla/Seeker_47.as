package HalfneMiku_fla
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public dynamic class Seeker_47 extends MovieClip
   {
       
      
      public var mDragDelta:Number;
      
      public var mPct:Number;
      
      public var mHead:Sprite;
      
      public const W:Number = 200;
      
      public function Seeker_47()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : void
      {
         this.mPct = 0;
         this.mDragDelta = 0;
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         this.mHead = new Sprite();
         addChild(this.mHead);
         var _loc1_:Graphics = this.mHead.graphics;
         _loc1_.beginFill(16777215);
         _loc1_.drawRect(-2,0,2,10);
      }
      
      public function SetPercent(param1:Number) : void
      {
         this.mPct = param1;
         if(!isNaN(this.mPct))
         {
            this.mHead.visible = true;
            this.mHead.x = this.mPct * this.W;
         }
         else
         {
            this.mHead.visible = false;
         }
      }
      
      public function GetPercent() : Number
      {
         return this.mPct;
      }
      
      public function OnMouseDown(param1:MouseEvent) : void
      {
         this.mDragDelta = mouseX / this.W - this.mPct;
         if(Math.abs(this.mDragDelta) >= 10 / this.W)
         {
            this.mDragDelta = 0;
            this.OnMouseMove();
         }
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         param1.stopImmediatePropagation();
      }
      
      public function OnMouseMove(param1:MouseEvent = null) : void
      {
         var _loc2_:Number = mouseX / this.W - this.mDragDelta;
         this.SetPercent(Math.max(0,Math.min(_loc2_,1)));
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function OnMouseUp(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
      }
      
      internal function frame1() : *
      {
      }
   }
}
