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
   
   public dynamic class keycode_display_57 extends MovieClip
   {
       
      
      public var mText:TextField;
      
      public function keycode_display_57()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function ShowKeybind(param1:int) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         if(param1 <= 0)
         {
            gotoAndStop("none");
         }
         else if(param1 >= 65 && param1 <= 90 || param1 >= 48 && param1 <= 57)
         {
            gotoAndStop("alphanum");
            this.mText.text = String.fromCharCode(param1);
         }
         else
         {
            _loc2_ = {
               8:"Backspace",
               9:"Tab",
               13:"Enter",
               16:"Ctrl",
               19:"Pause",
               20:"Caps",
               27:"Esc",
               32:"Space",
               33:"PgUp",
               34:"PgDn",
               35:"End",
               36:"Home",
               37:"Arrow_Left",
               38:"Arrow_Up",
               39:"Arrow_Right",
               40:"Arrow_Down",
               45:"Ins",
               46:"Del",
               96:"Num0",
               97:"Num1",
               98:"Num2",
               99:"Num3",
               100:"Num4",
               101:"Num5",
               102:"Num6",
               103:"Num7",
               104:"Num8",
               105:"Num9",
               106:"Num*",
               107:"Num+",
               13:"NumEnter",
               109:"Num-",
               110:"Num.",
               111:"Num/",
               112:"F1",
               113:"F2",
               114:"F3",
               115:"F4",
               116:"F5",
               117:"F6",
               118:"F7",
               119:"F8",
               120:"F9",
               122:"F11",
               123:"F12",
               144:"NumLock",
               145:"ScrLock",
               186:";",
               187:"+",
               188:"<",
               189:"-",
               190:">",
               191:"?",
               192:"~",
               219:"[",
               220:"\\",
               221:"]",
               222:"\""
            };
            _loc3_ = String(_loc2_[param1]);
            if(_loc3_)
            {
               if(_loc3_.indexOf("Arrow_") == 0)
               {
                  gotoAndStop(_loc3_);
               }
               else
               {
                  gotoAndStop(_loc3_.length < 2 ? "alphanum" : "string");
                  this.mText.text = _loc3_;
               }
            }
            else
            {
               gotoAndStop("string");
               this.mText.text = String(param1);
            }
         }
      }
      
      public function GetWidth() : Number
      {
         return !!this.mText ? this.mText.textWidth : width;
      }
      
      public function ShowMouseBind() : void
      {
         gotoAndStop("mouse");
      }
      
      internal function frame1() : *
      {
      }
   }
}
