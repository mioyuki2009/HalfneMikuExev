package HalfneMiku_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public dynamic class RimButton_50 extends MovieClip
   {
       
      
      public var mMouseOver:Boolean;
      
      public var mMouseDown:Boolean;
      
      public function RimButton_50()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         this.mMouseOver = false;
         this.mMouseDown = false;
         this.RefreshState();
         addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown,false,2);
      }
      
      public function OnMouseOver(param1:MouseEvent = null) : void
      {
         this.mMouseOver = true;
         this.RefreshState();
      }
      
      public function OnMouseOut(param1:MouseEvent = null) : void
      {
         this.mMouseOver = false;
         this.RefreshState();
      }
      
      public function OnMouseDown(param1:MouseEvent = null) : void
      {
         this.mMouseDown = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp,false,2);
         dispatchEvent(new Event("OnPress"));
         this.RefreshState();
         param1.stopPropagation();
      }
      
      public function OnMouseUp(param1:MouseEvent = null) : void
      {
         this.mMouseDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         dispatchEvent(new Event("OnRelease"));
         this.RefreshState();
         param1.stopPropagation();
      }
      
      public function RefreshState() : void
      {
         if(this.mMouseDown)
         {
            gotoAndStop("active");
         }
         else if(this.mMouseOver)
         {
            gotoAndStop("over");
         }
         else
         {
            gotoAndStop("idle");
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}
