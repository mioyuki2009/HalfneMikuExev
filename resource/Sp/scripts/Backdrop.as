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
   
   public dynamic class Backdrop extends MovieClip
   {
       
      
      public var mLoader:Loader;
      
      public var mMouseMode:String;
      
      public var mMouseCursor:Cursors;
      
      public function Backdrop()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         stop();
         this.mLoader = new Loader();
         addChild(this.mLoader);
         this.mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.OnLoadComplete);
      }
      
      public function LoadBg(param1:*) : void
      {
         this.mLoader.unload();
         gotoAndStop(param1);
         cacheAsBitmap = true;
      }
      
      public function LoadData(param1:ByteArray) : void
      {
         addChild(this.mLoader);
         this.mLoader.loadBytes(param1);
      }
      
      public function SetMouseMode(param1:String) : *
      {
         if(param1 == this.mMouseMode)
         {
            param1 = null;
         }
         var _loc2_:MovieClip = MovieClip(parent).UI;
         if(param1 != this.mMouseMode)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
            if(param1 == "move" || param1 == "zoom")
            {
               Mouse.hide();
               if(!this.mMouseCursor)
               {
                  this.mMouseCursor = new Cursors();
                  this.mMouseCursor.mouseEnabled = false;
                  stage.addChild(this.mMouseCursor);
                  stage.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
               }
               this.mMouseCursor.visible = true;
               this.mMouseCursor.gotoAndStop(param1);
               stage.addEventListener(KeyboardEvent.KEY_DOWN,this.OnCancelMouseModePlease);
               stage.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
               this.OnMouseMove();
            }
            else
            {
               _loc2_.SetTooltip("");
               Mouse.show();
               this.mMouseCursor.visible = false;
               stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.OnCancelMouseModePlease);
            }
            this.mMouseMode = param1;
         }
      }
      
      public function Autofit() : void
      {
         var _loc1_:Number = NaN;
         if(!this.mLoader.content)
         {
            return;
         }
         _loc1_ = this.mLoader.contentLoaderInfo.width;
         var _loc2_:Number = this.mLoader.contentLoaderInfo.height;
         var _loc3_:Number = Math.max(640 / _loc1_,480 / _loc2_);
         this.mLoader.scaleX = this.mLoader.scaleY = _loc3_;
         this.mLoader.x = (640 - _loc1_ * this.mLoader.scaleX) / 2;
         this.mLoader.y = (480 - _loc2_ * this.mLoader.scaleY) / 2;
      }
      
      public function OnLoadComplete(param1:Event) : *
      {
         this.Autofit();
      }
      
      public function OnCancelMouseModePlease(param1:Event) : void
      {
         this.SetMouseMode(null);
      }
      
      public function OnMouseDown(param1:Event = null) : void
      {
         this.mMouseCursor.down = true;
         this.mMouseCursor.start = new Point(this.mMouseCursor.x,this.mMouseCursor.y);
         this.mMouseCursor.start_matrix = this.mLoader.transform.matrix;
         this.mMouseCursor.local_point = new Point(this.mLoader.mouseX,this.mLoader.mouseY);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
      }
      
      public function OnMouseMove(param1:Event = null) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Matrix = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc2_:Point = new Point(this.mMouseCursor.mouseX,this.mMouseCursor.mouseY);
         this.mMouseCursor.x += _loc2_.x;
         this.mMouseCursor.y += _loc2_.y;
         if(this.mMouseMode)
         {
            _loc3_ = MovieClip(parent).UI;
            _loc3_.SetTooltip("Click and drag to " + (this.mMouseMode == "translate" ? "move" : "zoom"));
         }
         if(this.mMouseCursor.down)
         {
            _loc4_ = this.mMouseCursor.start_matrix;
            _loc5_ = this.mMouseCursor.start;
            if(this.mMouseMode == "move")
            {
               this.mLoader.x = _loc4_.tx + (this.mMouseCursor.x - _loc5_.x);
               this.mLoader.y = _loc4_.ty + (this.mMouseCursor.y - _loc5_.y);
            }
            else if(this.mMouseMode == "zoom")
            {
               this.mLoader.scaleX = this.mLoader.scaleY = _loc4_.a * Math.exp(-(this.mMouseCursor.y - _loc5_.y) / 256);
               _loc6_ = this.mLoader.transform.matrix.transformPoint(this.mMouseCursor.local_point);
               _loc7_ = _loc4_.transformPoint(this.mMouseCursor.local_point);
               this.mLoader.x += _loc7_.x - _loc6_.x;
               this.mLoader.y += _loc7_.y - _loc6_.y;
            }
         }
      }
      
      public function OnMouseUp(param1:Event = null) : void
      {
         this.mMouseCursor.down = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
      }
      
      internal function frame1() : *
      {
      }
   }
}
