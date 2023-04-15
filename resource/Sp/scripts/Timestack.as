package
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.net.registerClassAlias;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class Timestack implements IEventDispatcher, IExternalizable
   {
      
      {
         registerClassAlias("Timestack",Timestack);
      }
      
      private var mStacklets:Array;
      
      private var mLongShots:Vector.<DirectorEvent>;
      
      private var mCurrentEvent:DirectorEvent;
      
      private var mCurrentTime:Number;
      
      private var mDispatcher:EventDispatcher;
      
      private var mLSLU:Dictionary;
      
      private const INTERVAL:Number = 4096;
      
      public function Timestack()
      {
         super();
         this.mCurrentTime = 0;
         this.Clear();
         this.mDispatcher = new EventDispatcher(this);
      }
      
      public function Clear() : void
      {
         this.mLSLU = new Dictionary();
         this.mStacklets = new Array();
         this.mLongShots = new Vector.<DirectorEvent>();
      }
      
      public function AddEvent(param1:DirectorEvent) : void
      {
         this._AddEvent(param1);
         this.MoveTo(this.mCurrentTime);
      }
      
      private function _AddEvent(param1:DirectorEvent) : void
      {
         var _loc2_:Vector.<Stacklet> = null;
         var _loc3_:Stacklet = null;
         if(param1.indefinite)
         {
            this.AddLongShot(param1);
         }
         else
         {
            _loc2_ = this.GetStacklets(param1.start_ms,param1.end_ms,true);
            for each(_loc3_ in _loc2_)
            {
               _loc3_.AddEvent(param1);
            }
         }
         param1.addEventListener(Event.CHANGE,this.OnDirectorEventChange);
      }
      
      public function RemoveEvent(param1:DirectorEvent) : void
      {
         this._RemoveEvent(param1);
         this.MoveTo(this.mCurrentTime);
      }
      
      private function _RemoveEvent(param1:DirectorEvent) : void
      {
         var _loc2_:Vector.<Stacklet> = null;
         var _loc3_:Stacklet = null;
         if(this.mLSLU[param1])
         {
            this.RemoveLongShot(param1);
         }
         else
         {
            _loc2_ = this.GetStacklets(param1.start_ms,param1.end_ms,true);
            for each(_loc3_ in _loc2_)
            {
               _loc3_.RemoveEvent(param1);
            }
         }
         param1.removeEventListener(Event.CHANGE,this.OnDirectorEventChange);
      }
      
      public function MoveTo(param1:Number) : void
      {
         this.mCurrentTime = param1;
         var _loc2_:DirectorEvent = this.GetTopEventAt(param1);
         if(_loc2_ != this.mCurrentEvent)
         {
            this.mCurrentEvent = _loc2_;
            this.dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function GetDirectorEvents(param1:Number = -2147483648, param2:Number = 2147483647) : Vector.<DirectorEvent>
      {
         var _loc9_:Stacklet = null;
         var _loc10_:Vector.<DirectorEvent> = null;
         var _loc11_:DirectorEvent = null;
         var _loc3_:Vector.<DirectorEvent> = new Vector.<DirectorEvent>();
         var _loc4_:int = this.GetClosestLongShot(param1);
         var _loc5_:int = this.GetClosestLongShot(param2);
         var _loc6_:int = _loc4_;
         while(_loc6_ <= _loc5_ && _loc6_ < this.mLongShots.length)
         {
            _loc3_.push(this.mLongShots[_loc6_]);
            _loc6_++;
         }
         var _loc7_:Dictionary = new Dictionary();
         var _loc8_:* = param1 == int.MIN_VALUE || param2 == int.MAX_VALUE ? this.mStacklets : this.GetStacklets(param1,param2);
         for each(_loc9_ in _loc8_)
         {
            _loc10_ = new Vector.<DirectorEvent>();
            _loc9_.CollectEvents(_loc10_,param1,param2);
            for each(_loc11_ in _loc10_)
            {
               _loc7_[_loc11_] = _loc11_;
            }
         }
         for each(_loc11_ in _loc7_)
         {
            _loc3_.push(_loc11_);
         }
         return _loc3_;
      }
      
      private function GetStacklets(param1:Number, param2:Number, param3:Boolean = false) : Vector.<Stacklet>
      {
         var _loc8_:* = undefined;
         var _loc4_:Vector.<Stacklet> = new Vector.<Stacklet>();
         var _loc5_:int = Math.floor(param1 / this.INTERVAL);
         var _loc6_:int = Math.floor(param2 / this.INTERVAL);
         var _loc7_:int = _loc5_;
         for(; _loc7_ <= _loc6_; _loc7_++)
         {
            if(!(_loc8_ = this.mStacklets[_loc7_]))
            {
               if(!param3)
               {
                  continue;
               }
               _loc8_ = new Stacklet(_loc7_ * this.INTERVAL,(_loc7_ + 1) * this.INTERVAL);
               this.mStacklets[_loc7_] = _loc8_;
            }
            _loc4_.push(_loc8_);
         }
         return _loc4_;
      }
      
      private function OnDirectorEventChange(param1:Event) : void
      {
         var _loc2_:DirectorEvent = DirectorEvent(param1.target);
         this._RemoveEvent(_loc2_);
         this._AddEvent(_loc2_);
         this.MoveTo(this.mCurrentTime);
      }
      
      public function GetTopEventAt(param1:Number) : DirectorEvent
      {
         var _loc2_:* = undefined;
         var _loc3_:Stacklet = null;
         var _loc4_:int = 0;
         for each(_loc3_ in this.GetStacklets(param1,param1))
         {
            _loc2_ = _loc3_.GetTopEvent(param1);
         }
         if((_loc4_ = this.GetClosestLongShot(param1)) >= this.mLongShots.length)
         {
            return _loc2_;
         }
         var _loc5_:DirectorEvent = this.mLongShots[_loc4_];
         if(!_loc2_)
         {
            return _loc5_;
         }
         return _loc5_.start_ms < _loc2_.start_ms ? _loc5_ : _loc2_;
      }
      
      public function get time() : Number
      {
         return this.mCurrentTime;
      }
      
      private function GetClosestLongShot(param1:Number) : int
      {
         var _loc5_:DirectorEvent = null;
         if(this.mLongShots.length == 0)
         {
            return 0;
         }
         var _loc2_:int = 0;
         var _loc3_:int = int(this.mLongShots.length - 1);
         var _loc4_:int = Math.ceil((_loc2_ + _loc3_) / 2);
         while(_loc3_ - _loc2_ > 1)
         {
            if((_loc5_ = this.mLongShots[_loc4_]).start_ms == param1)
            {
               return _loc4_;
            }
            if(_loc5_.start_ms > param1)
            {
               _loc3_ = _loc4_;
            }
            else
            {
               _loc2_ = _loc4_;
            }
            _loc4_ = Math.ceil((_loc2_ + _loc3_) / 2);
         }
         return this.mLongShots[_loc4_].start_ms <= param1 ? _loc4_ : _loc2_;
      }
      
      private function AddLongShot(param1:DirectorEvent) : void
      {
         var _loc3_:DirectorEvent = null;
         var _loc2_:int = this.GetClosestLongShot(param1.start_ms);
         if(_loc2_ >= this.mLongShots.length)
         {
            this.mLongShots.push(param1);
         }
         else
         {
            _loc3_ = this.mLongShots[_loc2_];
            if(param1.start_ms > _loc3_.start_ms)
            {
               _loc2_++;
            }
            if(_loc2_ >= this.mLongShots.length)
            {
               this.mLongShots.push(param1);
            }
            else
            {
               this.mLongShots.splice(_loc2_,0,param1);
            }
         }
         this.mLSLU[param1] = true;
      }
      
      private function RemoveLongShot(param1:DirectorEvent) : void
      {
         delete this.mLSLU[param1];
         var _loc2_:int = this.GetClosestLongShot(param1.start_ms);
         if(_loc2_ >= this.mLongShots.length)
         {
            return;
         }
         if(this.mLongShots[_loc2_] == param1)
         {
            this.mLongShots.splice(_loc2_,1);
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this.mDispatcher.addEventListener(param1,param2,param3,param4);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this.mDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.mDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.mDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this.mDispatcher.willTrigger(param1);
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         var _loc3_:Stacklet = null;
         var _loc4_:Vector.<DirectorEvent> = null;
         var _loc5_:DirectorEvent = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in this.mStacklets)
         {
            _loc3_.MergeDictionary(_loc2_);
         }
         _loc4_ = new Vector.<DirectorEvent>();
         for each(_loc5_ in _loc2_)
         {
            _loc4_.push(_loc5_);
         }
         for each(_loc5_ in this.mLongShots)
         {
            _loc4_.push(_loc5_);
         }
         param1.writeObject(_loc4_);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         var _loc3_:DirectorEvent = null;
         var _loc2_:Vector.<DirectorEvent> = param1.readObject();
         for each(_loc3_ in _loc2_)
         {
            this.AddEvent(_loc3_);
         }
      }
   }
}

import flash.utils.Dictionary;

class Stacklet
{
    
   
   private var start_ms:Number;
   
   private var end_ms:Number;
   
   private var mDirVents:Dictionary;
   
   public function Stacklet(param1:Number, param2:Number)
   {
      super();
      this.start_ms = param1;
      this.end_ms = param2;
      this.mDirVents = new Dictionary();
   }
   
   public function AddEvent(param1:DirectorEvent) : void
   {
      if(!this.mDirVents[param1])
      {
         this.mDirVents[param1] = param1;
      }
   }
   
   public function RemoveEvent(param1:DirectorEvent) : void
   {
      delete this.mDirVents[param1];
   }
   
   public function GetTopEvent(param1:Number) : DirectorEvent
   {
      var _loc3_:DirectorEvent = null;
      var _loc2_:DirectorEvent = null;
      for each(_loc3_ in this.mDirVents)
      {
         if(_loc3_.Contains(param1))
         {
            if(!_loc2_ || _loc3_.start_ms > _loc2_.start_ms)
            {
               _loc2_ = _loc3_;
            }
         }
      }
      return _loc2_;
   }
   
   private function CollectEvents(param1:Vector.<DirectorEvent>, param2:Number, param3:Number) : int
   {
      var _loc5_:DirectorEvent = null;
      var _loc4_:int = 0;
      for each(_loc5_ in this.mDirVents)
      {
         if(_loc5_.start_ms <= param3 && (_loc5_.indefinite || _loc5_.end_ms >= param2))
         {
            _loc4_++;
            param1.push(_loc5_);
         }
      }
      return _loc4_;
   }
   
   private function MergeDictionary(param1:Dictionary) : void
   {
      var _loc2_:DirectorEvent = null;
      for each(_loc2_ in this.mDirVents)
      {
         param1[_loc2_] = _loc2_;
      }
   }
}
