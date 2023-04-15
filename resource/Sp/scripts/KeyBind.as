package
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.utils.ByteArray;
   
   public class KeyBind implements IEventDispatcher
   {
      
      private static var sKeybinds:Vector.<KeyBind> = new Vector.<KeyBind>();
       
      
      internal var mId:String;
      
      internal var mKeyCode:int;
      
      private var mDisplayName:String;
      
      private var mDispatcher:EventDispatcher;
      
      private var mListener:EventDispatcher;
      
      private var mDown:Boolean;
      
      public function KeyBind(param1:String, param2:String, param3:int = 0)
      {
         super();
         this.mId = param1;
         this.mDisplayName = param2;
         this.mKeyCode = param3;
         this.mDown = false;
         this.mDispatcher = new EventDispatcher(this);
         sKeybinds.push(this);
      }
      
      public static function GetKeyBinds() : Vector.<KeyBind>
      {
         return sKeybinds;
      }
      
      public static function WriteToByteArray(param1:ByteArray) : void
      {
         var _loc2_:KeyBind = null;
         param1.writeInt(sKeybinds.length);
         for each(_loc2_ in sKeybinds)
         {
            param1.writeUTF(_loc2_.mId);
            param1.writeInt(_loc2_.mKeyCode);
         }
      }
      
      public static function ReadFromByteArray(param1:ByteArray) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:KeyBind = null;
         var _loc2_:int = param1.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readUTF();
            _loc5_ = param1.readInt();
            for each(_loc6_ in sKeybinds)
            {
               if(_loc6_.mId == _loc4_)
               {
                  _loc6_.Rebind(_loc5_);
                  break;
               }
            }
            _loc3_++;
         }
      }
      
      public function Rebind(param1:int = 0) : void
      {
         this.mKeyCode = param1;
         this.dispatchEvent(new Event(Event.CHANGE));
         this.Release();
      }
      
      public function SetListener(param1:EventDispatcher) : void
      {
         if(this.mListener)
         {
            this.mListener.removeEventListener(KeyboardEvent.KEY_DOWN,this.OnKeyDown);
            this.mListener.removeEventListener(KeyboardEvent.KEY_UP,this.OnKeyUp);
            this.mListener.removeEventListener(Event.DEACTIVATE,this.OnDeactivate);
         }
         this.mListener = param1;
         if(this.mListener)
         {
            this.mListener.addEventListener(KeyboardEvent.KEY_DOWN,this.OnKeyDown);
            this.mListener.addEventListener(KeyboardEvent.KEY_UP,this.OnKeyUp);
            this.mListener.addEventListener(Event.DEACTIVATE,this.OnDeactivate);
         }
      }
      
      public function Press() : void
      {
         if(!this.mDown)
         {
            this.mDown = true;
            this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN));
         }
      }
      
      public function Release() : void
      {
         if(this.mDown)
         {
            this.mDown = false;
            this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP));
         }
      }
      
      private function OnKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == this.mKeyCode)
         {
            this.Press();
         }
      }
      
      private function OnKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == this.mKeyCode && this.mDown)
         {
            this.Release();
         }
      }
      
      private function OnDeactivate(param1:Event) : void
      {
         this.Release();
      }
      
      public function get down() : Boolean
      {
         return this.mDown;
      }
      
      public function get keyCode() : int
      {
         return this.mKeyCode;
      }
      
      public function get name() : String
      {
         return this.mDisplayName;
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
