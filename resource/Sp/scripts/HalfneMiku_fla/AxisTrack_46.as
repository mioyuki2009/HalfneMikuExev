package HalfneMiku_fla
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
   
   public dynamic class AxisTrack_46 extends MovieClip
   {
       
      
      public const PIXELS_PER_SEC:Number = 200;
      
      public const MS_PER_SAMPLE:Number = 100;
      
      public const PIXELS_PER_SAMPLE:Number = 20;
      
      public const AMPLITUDE:Number = 11;
      
      public var mSamples:Array;
      
      public var mGrapher:Sprite;
      
      public var mGraphX:Sprite;
      
      public var mGraphY:Sprite;
      
      public var mPos:Number;
      
      public function AxisTrack_46()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         this.mSamples = new Array();
         this.mGrapher = new Sprite();
         this.mGraphX = new Sprite();
         this.mGraphY = new Sprite();
         this.mGrapher.addChild(this.mGraphY);
         this.mGrapher.addChild(this.mGraphX);
         this.mGraphX.y = this.mGraphY.y = 25 / 2;
         addChild(this.mGrapher);
         this.Reset();
      }
      
      public function Reset() : void
      {
         this.LoadSequence(new Array());
      }
      
      public function LoadSequence(param1:Array) : void
      {
         var _loc2_:* = undefined;
         this.mSamples = new Array();
         for(_loc2_ in param1)
         {
            this.mSamples[_loc2_] = new Point(param1[_loc2_].x,param1[_loc2_].y);
         }
         this.SetPos(0);
      }
      
      public function SaveSequence() : Array
      {
         return this.mSamples;
      }
      
      public function SetPos(param1:Number) : void
      {
         this.mPos = param1;
         var _loc2_:Number = this.mPos / 1000 * this.PIXELS_PER_SEC;
         this.mGrapher.scrollRect = new Rectangle(_loc2_,0,500,25);
         this.Draw(this.mPos,this.mPos + 1000 * 500 / this.PIXELS_PER_SEC);
      }
      
      public function Draw(param1:Number, param2:Number) : void
      {
         var _loc8_:Point = null;
         var _loc9_:Number = NaN;
         var _loc3_:Graphics = this.mGraphX.graphics;
         var _loc4_:Graphics = this.mGraphY.graphics;
         _loc3_.clear();
         _loc4_.clear();
         _loc3_.lineStyle(1,65535);
         _loc4_.lineStyle(1,16711935);
         var _loc5_:int = this.GetSampleIdx(param2) + 1;
         var _loc6_:Point = new Point(0,0);
         var _loc7_:int = this.GetSampleIdx(param1) - 1;
         while(_loc7_ <= _loc5_)
         {
            _loc8_ = this.mSamples[_loc7_];
            _loc9_ = _loc7_ * this.PIXELS_PER_SAMPLE;
            if(_loc8_)
            {
               _loc3_.lineTo(_loc9_,_loc8_.x * this.AMPLITUDE);
               _loc4_.lineTo(_loc9_,_loc8_.y * this.AMPLITUDE);
               _loc6_ = _loc8_;
            }
            else
            {
               _loc3_.moveTo(_loc9_,_loc6_.x);
               _loc4_.moveTo(_loc9_,_loc6_.y);
            }
            _loc7_++;
         }
      }
      
      public function Record(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:int = this.GetSampleIdx(param1);
         this.mSamples[_loc4_] = new Point(param2,param3);
         this.Draw(this.mPos,this.mPos + 1000 * 500 / this.PIXELS_PER_SEC);
      }
      
      public function GetSampleAt(param1:Number) : Point
      {
         var _loc2_:Number = param1 / this.MS_PER_SAMPLE;
         var _loc3_:int = int(_loc2_);
         var _loc4_:int = _loc3_;
         if(_loc2_ > _loc3_)
         {
            _loc4_++;
         }
         else
         {
            _loc3_--;
         }
         var _loc5_:Number = _loc2_ - _loc3_;
         var _loc6_:Point = this.mSamples[_loc3_];
         var _loc7_:Point = this.mSamples[_loc4_];
         if(Boolean(_loc6_) && Boolean(_loc7_))
         {
            return new Point(_loc6_.x * (1 - _loc5_) + _loc7_.x * _loc5_,_loc6_.y * (1 - _loc5_) + _loc7_.y * _loc5_);
         }
         return this.mSamples[int(_loc2_)];
      }
      
      public function GetSampleIdx(param1:Number) : int
      {
         return int(param1 / this.MS_PER_SAMPLE);
      }
      
      internal function frame1() : *
      {
      }
   }
}
