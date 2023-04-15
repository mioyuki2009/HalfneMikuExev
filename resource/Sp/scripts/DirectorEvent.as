package
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.net.registerClassAlias;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class DirectorEvent implements IEventDispatcher, IExternalizable
   {
      
      {
         registerClassAlias("DirectorEvent",DirectorEvent);
      }
      
      private var mStackId:String;
      
      public var val;
      
      private var mStart_ms:int;
      
      private var mEnd_ms:int;
      
      private var mDispatcher:EventDispatcher;
      
      public var in_progress:Boolean;
      
      private const NO_END:int = 2147483647;
      
      private const SRL_VERSION:int = 1;
      
      public function DirectorEvent(param1:String = null, param2:* = null, param3:int = 0, param4:int = 2147483647)
      {
         super();
         this.in_progress = false;
         this.mStackId = param1;
         this.val = param2;
         this.mStart_ms = param3;
         this.mEnd_ms = param4;
         this.mDispatcher = new EventDispatcher(this);
      }
      
      public function ShiftTime(param1:int) : void
      {
         this.mStart_ms += param1;
         if(this.mEnd_ms != this.NO_END)
         {
            this.mEnd_ms += param1;
         }
         this.mDispatcher.dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function Contains(param1:Number) : Boolean
      {
         return this.indefinite ? this.mStart_ms <= param1 : this.mStart_ms <= param1 && this.mEnd_ms >= param1;
      }
      
      public function get stack_id() : String
      {
         return this.mStackId;
      }
      
      public function get dur_ms() : int
      {
         return this.mEnd_ms == this.NO_END ? -1 : this.mEnd_ms - this.mStart_ms;
      }
      
      public function get indefinite() : Boolean
      {
         return this.mEnd_ms == this.NO_END;
      }
      
      public function get start_ms() : int
      {
         return this.mStart_ms;
      }
      
      public function set start_ms(param1:int) : void
      {
         this.mStart_ms = param1;
         this.mDispatcher.dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get end_ms() : int
      {
         return this.mEnd_ms;
      }
      
      public function set end_ms(param1:int) : void
      {
         this.mEnd_ms = param1;
         this.mDispatcher.dispatchEvent(new Event(Event.CHANGE));
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
      
      public function writeExternal(param1:IDataOutput) : void
      {
         param1.writeShort(this.SRL_VERSION);
         param1.writeUTF(this.mStackId);
         param1.writeInt(this.mStart_ms);
         param1.writeInt(this.mEnd_ms);
         param1.writeObject(this.val);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         var _loc2_:int = int(param1.readShort());
         this.mStackId = param1.readUTF();
         this.mStart_ms = param1.readInt();
         this.mEnd_ms = param1.readInt();
         this.val = param1.readObject();
      }
   }
}
