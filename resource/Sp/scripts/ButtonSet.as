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
   
   public dynamic class ButtonSet extends MovieClip
   {
       
      
      public var mButtons:Vector.<Button>;
      
      public var mCols:int;
      
      public const SPACING:Number = 45;
      
      public function ButtonSet()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init(param1:int = 8) : *
      {
         this.mButtons = new Vector.<Button>();
         this.mCols = param1;
      }
      
      public function AddButton(param1:Button, param2:Number = NaN, param3:Number = NaN) : *
      {
         this.mButtons.push(param1);
         var _loc4_:int = int(this.mButtons.length - 1);
         param1.column = isNaN(param2) ? _loc4_ % this.mCols : param2;
         param1.row = isNaN(param3) ? Math.floor(_loc4_ / this.mCols) : param3;
         addChild(param1);
      }
      
      public function Display(param1:Number) : void
      {
         var _loc3_:Button = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.mButtons.length)
         {
            _loc3_ = this.mButtons[_loc2_];
            _loc4_ = int(_loc3_.column);
            _loc5_ = int(_loc3_.row);
            _loc3_.x = _loc4_ * param1 * this.SPACING + this.SPACING / 2;
            _loc3_.y = _loc5_ * this.SPACING + this.SPACING / 2;
            _loc2_++;
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}
