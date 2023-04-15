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
   
   public dynamic class TimestackView extends MovieClip
   {
       
      
      public var mTimestack:Timestack;
      
      public var mLastEvent:DirectorEvent;
      
      public var mLeftMs:Number;
      
      public var mRightMs:Number;
      
      public var mDirvents:Dictionary;
      
      public var mScroller:Sprite;
      
      public var mBounds:Rectangle;
      
      public var PIXELS_PER_SEC:Number;
      
      public function TimestackView()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         this.PIXELS_PER_SEC = Singleton.Get(DirectorView).PIXELS_PER_SEC;
         this.mBounds = this.getBounds(this);
         this.mLeftMs = 0;
         this.mRightMs = 0;
         this.mDirvents = new Dictionary();
         this.mScroller = new Sprite();
         addChild(this.mScroller);
         this.mTimestack = new Timestack();
         this.mTimestack.addEventListener(Event.CHANGE,this.OnStackChange);
      }
      
      public function LoadTimestack(param1:Timestack) : void
      {
         var _loc2_:Object = null;
         var _loc3_:DirectorEvent = null;
         var _loc4_:Dirvent = null;
         for(_loc2_ in this.mDirvents)
         {
            _loc3_ = DirectorEvent(_loc2_);
            (_loc4_ = this.mDirvents[_loc3_]).Finalize();
            delete this.mDirvents[_loc3_];
         }
         if(this.mTimestack)
         {
            this.mTimestack.removeEventListener(Event.CHANGE,this.OnStackChange);
         }
         this.mTimestack = param1;
         this.mTimestack.addEventListener(Event.CHANGE,this.OnStackChange);
         this.Refresh();
      }
      
      public function DisplayWindow(param1:Number, param2:Number) : void
      {
         var _loc4_:DirectorEvent = null;
         var _loc5_:Object = null;
         var _loc6_:Dirvent = null;
         this.mLeftMs = param1;
         this.mRightMs = param2;
         var _loc3_:Vector.<DirectorEvent> = this.mTimestack.GetDirectorEvents(param1,param2);
         for each(_loc4_ in _loc3_)
         {
            if(!this.mDirvents[_loc4_])
            {
               (_loc6_ = new Dirvent()).Init(_loc4_);
               _loc6_.addEventListener(Event.CLEAR,this.OnClearDirvent);
               this.mScroller.addChild(_loc6_);
               this.mDirvents[_loc4_] = _loc6_;
            }
         }
         for(_loc5_ in this.mDirvents)
         {
            if((_loc4_ = DirectorEvent(_loc5_)).start_ms > param2 || !_loc4_.indefinite && _loc4_.end_ms < param1)
            {
               (_loc6_ = this.mDirvents[_loc4_]).Finalize();
               delete this.mDirvents[_loc4_];
            }
         }
         this.mScroller.scrollRect = new Rectangle(param1 * 0.001 * this.PIXELS_PER_SEC,0,this.mBounds.width,this.mBounds.height);
      }
      
      public function Refresh() : void
      {
         this.DisplayWindow(this.mLeftMs,this.mRightMs);
      }
      
      public function OnClearDirvent(param1:Event) : void
      {
         var _loc2_:Dirvent = Dirvent(param1.target);
         var _loc3_:DirectorEvent = _loc2_.mEntry;
         this.mTimestack.RemoveEvent(_loc3_);
         _loc2_.Finalize();
         delete this.mDirvents[_loc3_];
      }
      
      public function OnStackChange(param1:Event) : void
      {
         var _loc2_:Timestack = Timestack(param1.target);
         var _loc3_:DirectorEvent = _loc2_.GetTopEventAt(_loc2_.time);
         if(this.mLastEvent && !this.mLastEvent.indefinite && !this.mLastEvent.in_progress)
         {
            Director.self.Direct("playback",{
               "stack":this.mLastEvent.stack_id,
               "val":this.mLastEvent.val,
               "activate":false
            });
         }
         this.mLastEvent = _loc3_;
         if(Boolean(_loc3_) && !_loc3_.in_progress)
         {
            Director.self.Direct("playback",{
               "stack":_loc3_.stack_id,
               "val":_loc3_.val,
               "activate":true
            });
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}
