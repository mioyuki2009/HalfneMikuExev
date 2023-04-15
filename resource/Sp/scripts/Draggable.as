package
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class Draggable extends MovieClip
   {
       
      
      public var bSkipBeginning:MovieClip;
      
      public var bRecordKey:MovieClip;
      
      public var mClose:MovieClip;
      
      public var tTime:TextField;
      
      public var bLoadSong:MovieClip;
      
      public var bTogglePlay:MovieClip;
      
      public var bTrackForward:MovieClip;
      
      public var mRecordKey:MovieClip;
      
      public var bSave:MovieClip;
      
      public var bTrackBackward:MovieClip;
      
      public var bSkipEnd:MovieClip;
      
      public var mSeeker:MovieClip;
      
      public var mSlider:MovieClip;
      
      public var mMouseTimeline:MovieClip;
      
      public var bRecordMouse:MovieClip;
      
      public var mBack:MovieClip;
      
      public var mWave:MovieClip;
      
      public var bHelp:MovieClip;
      
      public var bLoad:MovieClip;
      
      public var mRecordMouse:MovieClip;
      
      public var mPlayPause:MovieClip;
      
      public var mDirectorView:DirectorView;
      
      public var mPlayHead:MovieClip;
      
      internal var mClickTarget:DisplayObject;
      
      internal var mMouseClick:Point;
      
      public function Draggable()
      {
         super();
         this.SetDragTarget(this);
      }
      
      public function SetDragTarget(param1:DisplayObject) : void
      {
         if(this.mClickTarget == param1)
         {
            return;
         }
         if(this.mClickTarget)
         {
            this.mClickTarget.removeEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage);
            this.mClickTarget.removeEventListener(Event.REMOVED_FROM_STAGE,this.OnRemovedFromStage);
            if(stage)
            {
               this.OnRemovedFromStage(null);
            }
         }
         this.mClickTarget = param1;
         if(this.mClickTarget)
         {
            this.mClickTarget.addEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage);
            this.mClickTarget.addEventListener(Event.REMOVED_FROM_STAGE,this.OnRemovedFromStage);
            if(stage)
            {
               this.OnAddedToStage(null);
            }
         }
      }
      
      private function OnAddedToStage(param1:Event) : void
      {
         if(this.mClickTarget)
         {
            this.mClickTarget.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         }
         stage.addEventListener(Event.DEACTIVATE,this.OnDeactivate);
      }
      
      private function OnRemovedFromStage(param1:Event) : void
      {
         if(this.mClickTarget)
         {
            this.mClickTarget.removeEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         }
         stage.removeEventListener(Event.DEACTIVATE,this.OnDeactivate);
         this.StopDrag();
      }
      
      private function OnMouseDown(param1:MouseEvent) : void
      {
         this.mMouseClick = new Point(parent.mouseX,parent.mouseY);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
      }
      
      private function OnMouseMove(param1:MouseEvent) : void
      {
         x += parent.mouseX - this.mMouseClick.x;
         y += parent.mouseY - this.mMouseClick.y;
         this.mMouseClick = new Point(parent.mouseX,parent.mouseY);
      }
      
      private function OnMouseUp(param1:MouseEvent) : void
      {
         this.StopDrag();
      }
      
      private function OnDeactivate(param1:Event) : void
      {
         this.StopDrag();
      }
      
      private function StopDrag() : void
      {
         this.mMouseClick = null;
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
      }
   }
}
