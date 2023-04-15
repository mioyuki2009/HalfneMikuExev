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
   
   public dynamic class Swinger extends MovieClip
   {
       
      
      public var mObj:DisplayObject;
      
      public var mContext:DisplayObject;
      
      public var mCenter:Point;
      
      public var mVel:Point;
      
      public var mPos:Point;
      
      public var mAcc:Point;
      
      public var mDamp:Number;
      
      public var mInitMat:Matrix;
      
      public var mConstraint:Array;
      
      public var mBaseAng:Number;
      
      public var mStretchiness:Number;
      
      public function Swinger()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init(param1:DisplayObject, param2:DisplayObject, param3:Point) : void
      {
         this.mPos = this.LocalToLocal(param3,param1,param2);
         this.mVel = new Point(0,0);
         this.mAcc = new Point(0,0);
         this.mCenter = param3.clone();
         this.mObj = param1;
         this.mContext = param2;
         this.mDamp = 0.95;
         this.mStretchiness = 0.9;
         this.mInitMat = param1.transform.matrix;
         this.mBaseAng = Math.atan2(param3.y,param3.x);
      }
      
      public function Accelerate(param1:Point) : void
      {
         this.mAcc = param1.clone();
      }
      
      public function Stretchiness(param1:Number) : void
      {
         this.mStretchiness = param1;
      }
      
      public function Constrain(param1:Point, param2:Point) : void
      {
         this.mConstraint = [new Point(param1.x,param1.y),new Point(param2.x,param2.y)];
         this.mConstraint[0].normalize(1);
         this.mConstraint[1].normalize(1);
      }
      
      public function Update() : void
      {
         var _loc10_:* = undefined;
         var _loc11_:Number = NaN;
         var _loc12_:Point = null;
         var _loc13_:Number = NaN;
         var _loc1_:Point = this.mPos.clone();
         var _loc2_:Matrix = this.mObj.parent.transform.concatenatedMatrix;
         var _loc3_:Matrix = this.mContext.transform.concatenatedMatrix;
         _loc2_.invert();
         _loc2_.concat(_loc3_);
         _loc2_.tx = 0;
         _loc2_.ty = 0;
         var _loc4_:Point = _loc2_.transformPoint(this.mAcc);
         this.mVel.offset(_loc4_.x,_loc4_.y);
         this.mVel.x *= this.mDamp;
         this.mVel.y *= this.mDamp;
         _loc1_.offset(this.mVel.x,this.mVel.y);
         var _loc5_:Point = this.ContextToLocal(_loc1_);
         var _loc6_:Number = this.mCenter.length;
         var _loc7_:Number;
         if((_loc7_ = _loc5_.length / _loc6_) > 1)
         {
            if(_loc4_.length > 0)
            {
               (_loc10_ = _loc5_.clone()).normalize(1);
               if((_loc11_ = (_loc4_.x * _loc10_.x + _loc4_.y * _loc10_.y) * this.mDamp) > 0)
               {
                  _loc1_.offset(-_loc10_.x * _loc11_,-_loc10_.y * _loc11_);
                  _loc7_ = (_loc5_ = this.ContextToLocal(_loc1_)).length / _loc6_;
               }
            }
            _loc7_ = 1 + Math.max(0,_loc7_ - 1 - 0.1) * this.mStretchiness;
            _loc5_.normalize(_loc7_ * _loc6_);
            _loc1_ = this.LocalToContext(_loc5_);
         }
         if(this.mConstraint)
         {
            _loc12_ = this.mConstraint[0];
            if((_loc13_ = _loc5_.x * _loc12_.y - _loc5_.y * _loc12_.x) < 0)
            {
               _loc5_.offset(-_loc13_ * _loc12_.y,_loc13_ * _loc12_.x);
            }
            _loc12_ = this.mConstraint[1];
            if((_loc13_ = -_loc5_.x * _loc12_.y + _loc5_.y * _loc12_.x) < 0)
            {
               _loc5_.offset(_loc13_ * _loc12_.y,-_loc13_ * _loc12_.x);
            }
            _loc1_ = this.LocalToContext(_loc5_);
         }
         this.mVel = _loc1_.subtract(this.mPos);
         this.mPos = _loc1_;
         var _loc8_:Number;
         var _loc9_:Number = (_loc8_ = Math.atan2(_loc5_.y,_loc5_.x)) - Math.atan2(this.mCenter.y,this.mCenter.x);
         this.mObj.rotation = (_loc8_ - this.mBaseAng) * 180 / Math.PI;
         this.mObj.scaleY = _loc5_.length / this.mCenter.length;
      }
      
      public function LocalToLocal(param1:Point, param2:DisplayObject, param3:DisplayObject) : Point
      {
         return param3.globalToLocal(param2.localToGlobal(param1));
      }
      
      public function LocalToContext(param1:Point) : Point
      {
         return this.LocalToLocal(new Point(param1.x + this.mObj.x,param1.y + this.mObj.y),this.mObj.parent,this.mContext);
      }
      
      public function ContextToLocal(param1:Point) : Point
      {
         param1 = this.LocalToLocal(param1,this.mContext,this.mObj.parent);
         param1.offset(-this.mObj.x,-this.mObj.y);
         return param1;
      }
      
      internal function frame1() : *
      {
      }
   }
}
