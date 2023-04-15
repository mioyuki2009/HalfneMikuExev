package HalfneMiku_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public dynamic class HelpInterface_54 extends MovieClip
   {
       
      
      public var mCurrentPage:String;
      
      public var mShowPhase:Number;
      
      public function HelpInterface_54()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         this.mCurrentPage = null;
         this.mShowPhase = 0;
         Singleton.Set("help",this);
         this.Display(null);
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         addEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
      }
      
      public function Display(param1:String = null) : *
      {
         var _loc2_:* = false;
         var _loc3_:* = false;
         if(this.mCurrentPage == param1)
         {
            param1 = null;
         }
         if(this.mCurrentPage != param1)
         {
            _loc2_ = this.mCurrentPage != null;
            this.mCurrentPage = param1;
            if(param1)
            {
               gotoAndStop(param1);
            }
            _loc3_ = this.mCurrentPage != null;
            if(_loc2_)
            {
               stage.addEventListener(KeyboardEvent.KEY_DOWN,this.OnKeyDown);
            }
            else
            {
               stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.OnKeyDown);
            }
         }
      }
      
      public function OnKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.Display(null);
         }
      }
      
      public function OnMouseDown(param1:MouseEvent) : void
      {
         this.Display(null);
      }
      
      public function OnEnterFrame(param1:Event) : void
      {
         if(this.mCurrentPage)
         {
            this.mShowPhase = Math.min(1,this.mShowPhase + 1 / 8);
         }
         else
         {
            this.mShowPhase = Math.max(0,this.mShowPhase - 1 / 8);
         }
         visible = this.mShowPhase > 0;
         if(visible)
         {
            scaleX = scaleY = 1.25 * Math.sin(this.mShowPhase * Math.PI * 0.6);
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}
