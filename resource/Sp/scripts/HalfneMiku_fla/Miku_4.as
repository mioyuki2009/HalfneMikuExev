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
   
   public dynamic class Miku_4 extends MovieClip
   {
       
      
      public var leg_L:MovieClip;
      
      public var arm_L:MovieClip;
      
      public var collar:MovieClip;
      
      public var neck:MovieClip;
      
      public var tail_L:MovieClip;
      
      public var head:MovieClip;
      
      public var shoulder_R:MovieClip;
      
      public var upper:MovieClip;
      
      public var leg_R:MovieClip;
      
      public var arm_R:MovieClip;
      
      public var clipBR:MovieClip;
      
      public var lower:MovieClip;
      
      public var tail_R:MovieClip;
      
      public var shoulder_L:MovieClip;
      
      public var mControl:Point;
      
      public var mSwingers:Array;
      
      public var mKeyStates:Array;
      
      public var mMouth:MovieClip;
      
      public var mMouthStack:Array;
      
      public var mEyes:MovieClip;
      
      public function Miku_4()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : void
      {
         var _loc2_:Swinger = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:MovieClip = null;
         this.mKeyStates = new Array();
         this.mControl = new Point();
         var _loc1_:* = 0;
         while(_loc1_ < numChildren)
         {
            if((_loc4_ = getChildAt(_loc1_)) is MovieClip)
            {
               _loc5_ = MovieClip(_loc4_);
               _loc5_._initForm = _loc5_.transform.matrix.clone();
            }
            _loc1_++;
         }
         this.initClipRoot(this.leg_L,this.lower);
         this.initClipRoot(this.leg_R,this.lower);
         this.initClipRoot(this.neck,this.collar);
         this.initClipRoot(this.collar,this.upper);
         this.initClipRoot(this.tail_L,this.head);
         this.initClipRoot(this.tail_R,this.head);
         this.initClipRoot(this.shoulder_L,this.upper);
         this.initClipRoot(this.shoulder_R,this.upper);
         this.initClipRoot(this.clipBR,this.head);
         this.mSwingers = new Array();
         var _loc3_:Point = new Point(0,5);
         _loc2_ = this.MakeSwinger(this.tail_L,new Point(0,128));
         _loc2_.Accelerate(_loc3_);
         _loc2_ = this.MakeSwinger(this.tail_R,new Point(0,128));
         _loc2_.Accelerate(_loc3_);
         _loc3_.y = 64;
         _loc2_ = this.MakeSwinger(this.head.bangs.L,new Point(0,128));
         _loc2_.Accelerate(_loc3_);
         _loc2_.Constrain(new Point(-1,8),new Point(1,8));
         _loc2_ = this.MakeSwinger(this.head.bangs.M,new Point(0,100));
         _loc2_.Accelerate(_loc3_);
         _loc2_ = this.MakeSwinger(this.head.bangs.R,new Point(0,128));
         _loc2_.Accelerate(_loc3_);
         _loc2_.Constrain(new Point(-1,8),new Point(1,8));
         _loc2_ = this.MakeSwinger(this.head.momi_L,new Point(0,64));
         _loc2_.Accelerate(new Point(0.5,8));
         _loc2_.Stretchiness(0.5);
         _loc2_ = this.MakeSwinger(this.head.momi_R,new Point(0,64));
         _loc2_.Accelerate(new Point(-1,8));
         _loc2_.Stretchiness(0.5);
         _loc2_ = this.MakeSwinger(this.collar.tie,new Point(0,32));
         _loc2_.Accelerate(new Point(0,2));
         _loc2_ = this.MakeSwinger(this.lower.skirt,new Point(0,20));
         _loc2_.Accelerate(new Point(0,2));
         _loc2_.Constrain(new Point(-1,7),new Point(1,7));
         _loc2_ = this.MakeSwinger(this.head.ahoge,new Point(0,-32));
         _loc2_.Accelerate(new Point(-12,-12));
         _loc2_.Stretchiness(0);
         _loc2_ = this.MakeSwinger(this.upper.shirt_L,new Point(0,16));
         _loc2_.Accelerate(new Point(-2,4));
         _loc2_ = this.MakeSwinger(this.upper.shirt_R,new Point(0,16));
         _loc2_.Accelerate(new Point(2,4));
         _loc2_ = this.MakeSwinger(this.lower.belt,new Point(0,8));
         _loc2_.Accelerate(new Point(1,4));
         _loc2_.Stretchiness(0);
         this.mMouth = this.head.face.mouth;
         this.mMouth.Init();
         this.mEyes = this.head.face.eyes;
         this.mEyes.Init();
         this.mMouthStack = new Array();
      }
      
      public function SetControl(param1:Point) : void
      {
         this.mControl = param1;
      }
      
      public function UpdateKey(param1:*, param2:Boolean) : void
      {
         var _loc8_:* = undefined;
         if(this.mKeyStates[param1] == param2)
         {
            return;
         }
         this.mKeyStates[param1] = param2;
         var _loc3_:* = "m";
         var _loc4_:* = {"A":65};
         var _loc5_:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
         var _loc6_:String = "aiueo";
         var _loc7_:* = 1;
         while(_loc7_ < 26)
         {
            _loc8_ = _loc5_.charAt(_loc7_);
            _loc4_[_loc8_] = _loc7_ + _loc4_.A;
            _loc7_++;
         }
         switch(param1)
         {
            case "m1":
               this.mEyes.Blink(param2);
               break;
            case _loc4_.A:
               this.StackMouth("a",param2);
               break;
            case _loc4_.S:
               this.StackMouth("i",param2);
               break;
            case _loc4_.W:
               this.StackMouth("u",param2);
               break;
            case _loc4_.E:
               this.StackMouth("e",param2);
               break;
            case _loc4_.D:
               this.StackMouth("o",param2);
               break;
            case _loc4_.Q:
               this.StackMouth("n",param2);
               break;
            case Keyboard.SPACE:
               if(param2)
               {
                  this.mMouth.ChangePhase(_loc6_.charAt(Math.random() * _loc6_.length));
               }
               else
               {
                  this.StackMouth("?",false);
               }
               break;
            default:
               this.mMouth.ChangePhase("a");
         }
      }
      
      public function Update(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc11_:Matrix = null;
         var _loc14_:* = undefined;
         _loc2_ = this.mControl.x;
         _loc3_ = this.mControl.y;
         _loc4_ = _loc2_ * Math.PI / 2;
         _loc5_ = _loc3_ * Math.PI / 2;
         var _loc6_:Number = Math.sin(_loc4_);
         _loc7_ = Math.cos(_loc4_);
         _loc8_ = Math.sin(_loc5_);
         var _loc9_:Number = Math.cos(_loc5_);
         var _loc10_:Number = 1 - (0.5 - _loc8_ * 0.5) * _loc7_;
         _loc11_ = this.getInitMatrix(this.head);
         this.head.x = _loc11_.tx + _loc6_ * 4;
         this.head.y = _loc11_.ty + 10 * _loc10_;
         this.head.rotation = _loc6_ * 30;
         _loc11_ = this.getInitMatrix(this.upper);
         this.upper.x = _loc11_.tx + _loc6_ * 5;
         this.upper.y = _loc11_.ty + 4 * _loc10_;
         this.upper.rotation = -_loc6_ * 15;
         _loc11_ = this.getInitMatrix(this.lower);
         this.lower.x = _loc11_.tx + _loc6_ * 10;
         this.lower.y = _loc11_.ty + 4 * _loc10_;
         this.maintainClipRoot(this.collar);
         var _loc12_:Point = new Point(0,-10);
         _loc11_ = this.getInitMatrix(this.neck);
         this.maintainClipRoot(this.neck);
         this.touchClipTo(this.neck,_loc12_,new Point(this.head.x,this.head.y));
         _loc11_ = this.getInitMatrix(this.arm_L);
         this.arm_L.x = _loc11_.tx + (Math.sin(_loc4_ - 0.5) + 0.75) * 5;
         this.arm_L.y = _loc11_.ty - (0 - _loc7_) * 10;
         _loc11_ = this.getInitMatrix(this.arm_R);
         this.arm_R.x = _loc11_.tx + (Math.sin(_loc4_ + 0.5) - 0.75) * 5;
         this.arm_R.y = _loc11_.ty - (0 - _loc7_) * 10;
         this.maintainClipRoot(this.shoulder_L);
         this.touchClipTo(this.shoulder_L,new Point(0,24),new Point(this.arm_L.x,this.arm_L.y));
         this.maintainClipRoot(this.shoulder_R);
         this.touchClipTo(this.shoulder_R,new Point(0,24),new Point(this.arm_R.x,this.arm_R.y));
         var _loc13_:Point = new Point(0,40);
         _loc11_ = this.getInitMatrix(this.leg_L);
         this.maintainClipRoot(this.leg_L);
         this.touchClipTo(this.leg_L,_loc13_,_loc11_.transformPoint(_loc13_));
         _loc11_ = this.getInitMatrix(this.leg_R);
         this.maintainClipRoot(this.leg_R);
         this.touchClipTo(this.leg_R,_loc13_,_loc11_.transformPoint(_loc13_));
         this.maintainClipRoot(this.tail_L);
         this.maintainClipRoot(this.tail_R);
         this.maintainClipRoot(this.clipBR);
         this.clipBR.rotation = this.head.rotation;
         for(_loc14_ in this.mSwingers)
         {
            this.mSwingers[_loc14_].Update();
         }
      }
      
      public function getInitMatrix(param1:MovieClip) : Matrix
      {
         return param1._initForm;
      }
      
      public function localToLocal(param1:Point, param2:DisplayObject, param3:DisplayObject) : Point
      {
         return param3.globalToLocal(param2.localToGlobal(param1));
      }
      
      public function initClipRoot(param1:MovieClip, param2:DisplayObject) : void
      {
         param1._rootPoint = this.localToLocal(new Point(0,0),param1,param2);
         param1._rootObj = param2;
      }
      
      public function maintainClipRoot(param1:MovieClip) : void
      {
         var _loc2_:Point = param1._rootObj.localToGlobal(param1._rootPoint);
         _loc2_ = param1.parent.globalToLocal(_loc2_);
         param1.x = _loc2_.x;
         param1.y = _loc2_.y;
      }
      
      public function touchClipTo(param1:MovieClip, param2:Point, param3:Point) : void
      {
         var _loc4_:Point = this.localToLocal(param3,param1.parent,param1);
         param1.rotation += (Math.atan2(_loc4_.y,_loc4_.x) - Math.atan2(param2.y,param2.x)) * 180 / Math.PI;
         param1.scaleY *= _loc4_.length / param2.length;
      }
      
      public function MakeSwinger(param1:DisplayObject, param2:Point) : Swinger
      {
         var _loc3_:Swinger = new Swinger();
         this.mSwingers[param1.name] = _loc3_;
         _loc3_.Init(param1,this,param2);
         return _loc3_;
      }
      
      public function StackMouth(param1:String, param2:Boolean) : void
      {
         var _loc3_:* = undefined;
         if(param2)
         {
            if(param1 == "m")
            {
               this.mMouthStack = new Array();
            }
            this.mMouthStack.push(param1);
            this.mMouth.ChangePhase(param1);
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this.mMouthStack.length)
            {
               if(this.mMouthStack[_loc3_] == param1)
               {
                  this.mMouthStack.splice(_loc3_,1);
                  _loc3_--;
               }
               _loc3_++;
            }
            this.mMouth.ChangePhase(!!this.mMouthStack[0] ? this.mMouthStack[this.mMouthStack.length - 1] : "m");
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}
