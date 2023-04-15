package
{
   import flash.utils.Dictionary;
   
   public class Singleton
   {
      
      internal static var sSingletons:Dictionary = new Dictionary();
       
      
      public function Singleton()
      {
         super();
      }
      
      public static function Set(param1:*, param2:Object) : void
      {
         sSingletons[param1] = param2;
      }
      
      public static function Get(param1:*) : *
      {
         return sSingletons[param1];
      }
   }
}
