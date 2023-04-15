package
{
   import flash.display.MovieClip;
   
   public dynamic class Eyes extends MovieClip
   {
       
      
      public var mSet:String;
      
      public var mOpen:Boolean;
      
      public var mPhase:Number;
      
      public function Eyes()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         this.mSet = "happy";
         this.Blink(false);
      }
      
      public function ChangeSet(param1:String) : *
      {
         this.mSet = param1;
         this.UpdateFrame();
      }
      
      public function Blink(param1:Boolean) : *
      {
         this.mOpen = !param1;
         this.mPhase = param1 ? 1 : 0;
         this.UpdateFrame();
      }
      
      public function UpdateFrame() : *
      {
         gotoAndStop(this.mSet);
         gotoAndStop(currentFrame + this.mPhase);
      }
      
      internal function frame1() : *
      {
      }
   }
}
