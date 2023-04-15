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
   
   public dynamic class WaveDisplay_48 extends MovieClip
   {
       
      
      public var mSound:Sound;
      
      public var mPeaks:Vector.<Number>;
      
      public var mWaveSprite:Sprite;
      
      public var mLastRange:Array;
      
      public var mGraphMap:BitmapData;
      
      public const SAMPLES_PER_MS:Number = 44.1;
      
      public const SAMPLES_PER_WAVE:Number = 44;
      
      public function WaveDisplay_48()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         this.mWaveSprite = new Sprite();
         addChild(this.mWaveSprite);
         this.mPeaks = new Vector.<Number>();
         this.mLastRange = [0,0];
         this.mGraphMap = new BitmapData(500,10,true,0);
         this.mWaveSprite.graphics.beginBitmapFill(this.mGraphMap);
         this.mWaveSprite.graphics.drawRect(0,0,500,10);
      }
      
      public function Reset(param1:Sound) : *
      {
         removeEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
         this.mSound = param1;
         this.mPeaks = new Vector.<Number>();
         addEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
         var _loc2_:* = this.mLastRange;
         this.mLastRange = [0,0];
         this.mGraphMap.fillRect(this.mGraphMap.rect,0);
         this.Draw(_loc2_[0],_loc2_[1]);
      }
      
      public function AttachChannel(param1:SoundChannel) : void
      {
      }
      
      public function Draw(param1:Number, param2:Number) : void
      {
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc3_:int = this.GetSampleIdx(param1);
         var _loc4_:int = this.GetSampleIdx(param2);
         var _loc5_:Number = param2 - param1;
         var _loc6_:int = _loc3_;
         var _loc7_:int = _loc4_;
         if(this.mLastRange[1] - this.mLastRange[0] == _loc5_)
         {
            _loc11_ = this.mLastRange[0] - param1;
            this.mGraphMap.scroll(_loc11_ / _loc5_ * 500,0);
            if(_loc11_ <= 0)
            {
               _loc6_ = this.GetSampleIdx(this.mLastRange[1]);
            }
            else
            {
               _loc7_ = this.GetSampleIdx(this.mLastRange[0]);
            }
         }
         var _loc8_:Number = 500 / (_loc4_ - _loc3_);
         var _loc9_:Number = 10;
         var _loc10_:int = _loc6_;
         while(_loc10_ <= _loc7_)
         {
            _loc12_ = _loc10_ >= 0 && _loc10_ < this.mPeaks.length ? this.mPeaks[_loc10_] : 0;
            _loc13_ = (_loc10_ - _loc3_) / (_loc4_ - _loc3_) * 500;
            this.mGraphMap.fillRect(new Rectangle(_loc13_,0,_loc8_,_loc9_),4278190080 + (int(_loc12_ * 255) << 12));
            this.mGraphMap.fillRect(new Rectangle(_loc13_,0,_loc8_,(1 - _loc12_) * _loc9_),0);
            _loc10_++;
         }
         this.mLastRange[0] = param1;
         this.mLastRange[1] = param2;
      }
      
      public function OnEnterFrame(param1:Event) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:Number = new Date().time;
         var _loc3_:Number = 500 / stage.frameRate;
         var _loc4_:Number = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.mPeaks.length * this.SAMPLES_PER_WAVE / this.SAMPLES_PER_MS;
            _loc6_ = Math.min(_loc5_ + this.SAMPLES_PER_WAVE,this.mSound.length);
            if(this.ExtractWave(_loc5_,_loc6_,this.mPeaks) <= 0)
            {
               removeEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
            }
            _loc4_ = new Date().time - _loc2_;
         }
         if(_loc6_ >= this.mLastRange[0] && _loc5_ <= this.mLastRange[1])
         {
            this.Draw(this.mLastRange[0],this.mLastRange[1]);
         }
      }
      
      public function ExtractWave(param1:Number, param2:Number, param3:*) : Number
      {
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         if(param1 >= this.mSound.length)
         {
            return 0;
         }
         var _loc4_:ByteArray = new ByteArray();
         var _loc5_:Number = Math.ceil((param2 - param1) * this.SAMPLES_PER_MS);
         this.mSound.extract(_loc4_,_loc5_,param1 * this.SAMPLES_PER_MS);
         var _loc6_:Number = 0;
         _loc4_.position = 0;
         while(_loc4_.bytesAvailable > 0)
         {
            _loc7_ = [[],[]];
            _loc8_ = [0,0];
            _loc9_ = 0;
            _loc10_ = 0;
            while(_loc10_ < this.SAMPLES_PER_WAVE && _loc4_.bytesAvailable > 0)
            {
               _loc13_ = 0;
               while(_loc13_ < 2)
               {
                  _loc7_[_loc13_].push(_loc4_.readFloat());
                  _loc8_[_loc13_] += _loc7_[_loc13_][_loc7_[_loc13_].length - 1];
                  _loc13_++;
               }
               _loc9_++;
               _loc10_++;
            }
            _loc8_[0] /= _loc9_;
            _loc8_[1] /= _loc9_;
            _loc11_ = [0,0];
            _loc10_ = 1;
            while(_loc10_ < _loc7_[0].length)
            {
               _loc13_ = 0;
               while(_loc13_ < 2)
               {
                  _loc11_[_loc13_] += Math.abs(_loc7_[_loc13_][_loc10_] - _loc8_[_loc13_]);
                  _loc13_++;
               }
               _loc10_++;
            }
            _loc11_[0] /= _loc9_;
            _loc11_[1] /= _loc9_;
            _loc12_ = Math.sqrt(Math.max(_loc11_[0],_loc11_[1]));
            param3.push(_loc12_);
            _loc6_++;
         }
         _loc4_.clear();
         return _loc6_;
      }
      
      public function GetSampleIdx(param1:Number) : int
      {
         return Math.floor(param1 * this.SAMPLES_PER_MS / this.SAMPLES_PER_WAVE);
      }
      
      internal function frame1() : *
      {
      }
   }
}
