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
   
   public dynamic class DirectorView extends MovieClip
   {
       
      
      public const PIXELS_PER_SEC:Number = 200;
      
      public var mDispIdx:int;
      
      public var mPos:Number;
      
      public var mPlayPos:Number;
      
      public var mHolder:Sprite;
      
      public var mLastRow:int;
      
      public var mTimestackViews:Array;
      
      public var mTimestacks:Array;
      
      public const TIMESTACK_IDS:Array = ["phase","blink","eyes","mouth"];
      
      public function DirectorView()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:TimestackView = null;
         this.mPos = 0;
         this.mPlayPos = 0;
         Singleton.Set(DirectorView,this);
         this.mTimestackViews = new Array();
         this.mTimestacks = new Array();
         var _loc1_:int = 1;
         while(_loc1_ < numChildren)
         {
            _loc2_ = this.TIMESTACK_IDS[_loc1_ - 1];
            this.mTimestacks[_loc2_] = new Timestack();
            _loc3_ = TimestackView(getChildAt(_loc1_));
            this.mTimestackViews[_loc2_] = _loc3_;
            _loc3_.Init();
            _loc3_.LoadTimestack(this.mTimestacks[_loc2_]);
            _loc1_++;
         }
      }
      
      public function SetPos(param1:Number) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:TimestackView = null;
         var _loc6_:Timestack = null;
         var _loc2_:Number = this.mPos;
         this.mPos = param1;
         var _loc3_:Number = 1000 * 250 / this.PIXELS_PER_SEC;
         this.mPlayPos = this.mPos + _loc3_;
         for(_loc4_ in this.mTimestacks)
         {
            (_loc5_ = this.mTimestackViews[_loc4_]).DisplayWindow(this.mPos,this.mPos + 2 * _loc3_);
            (_loc6_ = this.mTimestacks[_loc4_]).MoveTo(this.mPlayPos);
         }
      }
      
      public function Reset() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Timestack = null;
         var _loc3_:TimestackView = null;
         for(_loc1_ in this.mTimestacks)
         {
            _loc2_ = this.mTimestacks[_loc1_];
            _loc3_ = this.mTimestackViews[_loc1_];
            _loc2_.Clear();
            _loc3_.Refresh();
         }
      }
      
      public function LoadEntries(param1:Array) : void
      {
         this.Reset();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.AppendEntry(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function SaveEntries() : Array
      {
         var _loc2_:Timestack = null;
         var _loc3_:Vector.<DirectorEvent> = null;
         var _loc4_:DirectorEvent = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.mTimestacks)
         {
            _loc3_ = _loc2_.GetDirectorEvents(int.MIN_VALUE,int.MAX_VALUE);
            for each(_loc4_ in _loc3_)
            {
               _loc1_.push(_loc4_);
            }
         }
         return _loc1_;
      }
      
      public function AppendEntry(param1:DirectorEvent) : *
      {
         var _loc3_:TimestackView = null;
         var _loc2_:Timestack = this.mTimestacks[param1.stack_id];
         if(_loc2_)
         {
            _loc2_.AddEvent(param1);
            _loc3_ = this.mTimestackViews[param1.stack_id];
            _loc3_.Refresh();
            return;
         }
         throw new Error("no timeline registered for " + param1.stack_id);
      }
      
      public function OnDirventAdjust(param1:Event) : void
      {
         var _loc2_:Dirvent = Dirvent(param1.target);
      }
      
      public function OnDirventClear(param1:Event) : void
      {
         var _loc2_:Dirvent = Dirvent(param1.target);
         this.RemoveEntry(_loc2_.mEntry);
      }
      
      public function RemoveEntry(param1:DirectorEvent) : *
      {
         var _loc2_:Timestack = this.mTimestacks[param1.stack_id];
         if(_loc2_)
         {
            _loc2_.RemoveEvent(param1);
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}
