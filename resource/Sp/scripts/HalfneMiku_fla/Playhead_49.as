package HalfneMiku_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public dynamic class Playhead_49 extends MovieClip
   {
       
      
      public var mTrack:MovieClip;
      
      public var mBounds:Rectangle;
      
      public function Playhead_49()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init(param1:MovieClip) : void
      {
         this.mTrack = param1;
         this.mBounds = this.mTrack.getBounds(parent);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
      }
      
      public function OnMouseDown(param1:MouseEvent) : void
      {
         dispatchEvent(new MouseEvent(Event.CHANGE));
         param1.stopImmediatePropagation();
      }
      
      internal function frame1() : *
      {
      }
   }
}
