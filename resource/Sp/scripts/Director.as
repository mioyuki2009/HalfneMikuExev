package
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class Director implements IEventDispatcher
   {
      
      public static var self:Director = new Director();
      
      public static const ON_DIRECT:String = "OnDirect";
       
      
      private var mDispatcher:EventDispatcher;
      
      private var mArgs;
      
      private var mCommand:String;
      
      public function Director()
      {
         super();
         this.mDispatcher = new EventDispatcher(this);
      }
      
      public function Direct(param1:String, param2:* = null) : void
      {
         this.mArgs = param2;
         this.mCommand = param1;
         this.dispatchEvent(new Event(ON_DIRECT));
         this.mCommand = null;
         this.mArgs = null;
      }
      
      public function get command() : String
      {
         return this.mCommand;
      }
      
      public function get args() : *
      {
         return this.mArgs;
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
   }
}
