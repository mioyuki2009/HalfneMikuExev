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
   
   public dynamic class UI_Pane_38 extends MovieClip
   {
       
      
      public var mToggleShow:MovieClip;
      
      public var mTooltip:TextField;
      
      public var mButtonSets:Vector.<ButtonSet>;
      
      public var mActiveSet:ButtonSet;
      
      public var mEventArgs:Object;
      
      public var mFileRef:FileReference;
      
      public var mOnSelectFile:Function;
      
      public function UI_Pane_38()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : *
      {
         var root_set:ButtonSet;
         var eyes_exp:Array;
         var mouth_exp:Array;
         var vowels:Array;
         var cursor:Cursors;
         var button:Button = null;
         var icon:Icon = null;
         var i:int = 0;
         var face_set:ButtonSet = null;
         var vowel_set:ButtonSet = null;
         var backdrop_set:ButtonSet = null;
         this.mFileRef = new FileReference();
         this.mFileRef.addEventListener(Event.SELECT,this.OnFileRefSelect);
         this.mFileRef.addEventListener(Event.COMPLETE,this.OnFileRefLoad);
         this.mButtonSets = new Vector.<ButtonSet>();
         root_set = this.MakeButtonSet();
         face_set = this.MakeButtonSet();
         this.MakeBackButton(face_set,root_set);
         eyes_exp = ["happy","jaded","o_o","*_*","@_@","sideglance","eheh","pumped"];
         mouth_exp = ["happy","neutral","cat","angry","pout","drool","duck","tongue"];
         i = 0;
         while(i < eyes_exp.length)
         {
            button = this.Make_EyesButton(eyes_exp[i]);
            face_set.AddButton(button,i + 1,0);
            button.BindToKey(49 + i);
            this.SetButtonTooltip(button,eyes_exp[i]);
            i++;
         }
         i = 0;
         while(i < mouth_exp.length)
         {
            button = this.Make_MouthButton(mouth_exp[i]);
            face_set.AddButton(button,i + 1,1);
            this.SetButtonTooltip(button,mouth_exp[i]);
            i++;
         }
         button = new Button();
         icon = new Icon();
         icon.gotoAndStop("blink");
         button.Init("blink","blink",function(param1:Boolean):*
         {
            FireEvent("OnBlink",{"shut":param1});
         },icon);
         this.SetButtonTooltip(button,"blink");
         face_set.AddButton(button,10,0);
         button.BindToKey(64 + 24);
         vowel_set = this.MakeButtonSet();
         this.MakeBackButton(vowel_set,root_set);
         vowels = [["m",0,"closed"],["a",65,"ah"],["i",68,"ee"],["u",65 + 22,"oo"],["e",65 + 18,"eh"],["o",69,"oh"],["n",65 + 16,"teeth"],["?",Keyboard.SPACE,"random"]];
         i = 0;
         while(i < vowels.length)
         {
            button = this.Make_VowelButton(vowels[i][0]);
            button.BindToKey(vowels[i][1]);
            vowel_set.AddButton(button,i + 1,0);
            this.SetButtonTooltip(button,vowels[i][2]);
            i++;
         }
         backdrop_set = this.MakeButtonSet();
         this.MakeBackButton(backdrop_set,root_set);
         i = 1;
         while(i <= 8)
         {
            button = this.Make_BackdropButton(i);
            backdrop_set.AddButton(button,i,0);
            i++;
         }
         backdrop_set.AddButton(this.Make_BackdropButton("url"),1,1);
         button = new Button();
         cursor = new Cursors();
         cursor.gotoAndStop("move");
         cursor.scaleX = cursor.scaleY = 1.5;
         button.Init("mcb","move custom background",function(param1:*):*
         {
            if(param1)
            {
               FireEvent("OnTransformBackdrop",{"move":true});
            }
         },cursor);
         backdrop_set.AddButton(button,2,1);
         this.SetButtonTooltip(button,"move custom background");
         button = new Button();
         cursor = new Cursors();
         cursor.gotoAndStop("zoom");
         cursor.scaleX = cursor.scaleY = 1.5;
         button.Init("zcb","zoom custom background",function(param1:*):*
         {
            if(param1)
            {
               FireEvent("OnTransformBackdrop",{"zoom":true});
            }
         },cursor);
         backdrop_set.AddButton(button,3,1);
         this.SetButtonTooltip(button,"zoom custom background");
         button = new Button();
         icon = new Icon();
         icon.gotoAndStop("expand");
         button.Init("acb","autofit custom background",function():*
         {
            FireEvent("OnTransformBackdrop",{"reset":true});
         },icon);
         backdrop_set.AddButton(button,4,1);
         this.SetButtonTooltip(button,"autofit custom background");
         button = new Button();
         icon = new Icon();
         icon.gotoAndStop("face");
         button.Init(">exp","expressions menu",function(param1:Boolean):*
         {
            if(param1)
            {
               ActivateSet(face_set);
            }
         },icon);
         root_set.AddButton(button,1);
         this.SetButtonTooltip(button,"expressions");
         button = new Button();
         icon = new Icon();
         icon.gotoAndStop("vowel");
         button.Init(">ls","lipsyncing menu",function(param1:Boolean):*
         {
            if(param1)
            {
               ActivateSet(vowel_set);
            }
         },icon);
         root_set.AddButton(button,2);
         this.SetButtonTooltip(button,"lipsyncing");
         button = new Button();
         icon = new Icon();
         icon.gotoAndStop("background");
         button.Init(">bg","backgrounds menu",function(param1:Boolean):*
         {
            if(param1)
            {
               ActivateSet(backdrop_set);
            }
         },icon);
         root_set.AddButton(button,3);
         this.SetButtonTooltip(button,"backgrounds");
         button = new Button();
         button = new Button();
         icon = new Icon();
         icon.gotoAndStop("studio");
         button.Init(">stu","toggle studio",function(param1:Boolean):*
         {
            if(param1)
            {
               FireEvent("OnToggleStudio");
            }
         },icon);
         root_set.AddButton(button,1,1);
         this.SetButtonTooltip(button,"toggle studio");
         button = new Button();
         icon = new Icon();
         icon.gotoAndStop("key");
         button.Init(">kbnd","keybinds",function(param1:Boolean):*
         {
            if(param1)
            {
               Singleton.Get(KeyRebinder).Toggle();
            }
         },icon);
         root_set.AddButton(button,11,1);
         this.SetButtonTooltip(button,"keybinds");
         button = new Button();
         icon = new Icon();
         icon.gotoAndStop("help");
         button.Init("help","help",function(param1:Boolean):*
         {
            if(param1)
            {
               FireEvent("OnHelp");
            }
         },icon);
         root_set.AddButton(button,12,1);
         this.SetButtonTooltip(button,"help");
         this.mActiveSet = root_set;
         this.mToggleShow.addEventListener(MouseEvent.MOUSE_DOWN,this.OnToggleShow);
         this.SetTooltip();
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:Event):*
         {
            param1.stopPropagation();
         });
      }
      
      public function Update(param1:Number) : *
      {
         var _loc2_:ButtonSet = null;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         for each(_loc2_ in this.mButtonSets)
         {
            if(_loc2_ == this.mActiveSet)
            {
               _loc2_.presence = Math.min(1,_loc2_.presence + param1 * 8);
            }
            else
            {
               _loc2_.presence = Math.max(-1,_loc2_.presence - param1 * 8);
            }
            _loc2_.Display(_loc2_.presence);
            _loc2_.visible = _loc2_.presence > 0;
            _loc2_.x = -5 + _loc2_.presence * 10;
            _loc2_.y = 5;
         }
         if(this.mToggleShow.hiding)
         {
            y = y * 0.75 + 600 * 0.25;
            this.mToggleShow.y = -15;
            _loc3_ = new Point(this.mToggleShow.mouseX * 0.1,this.mToggleShow.mouseY);
            _loc4_ = _loc3_.length < 15 ? 1 : 1 + 15 / 30 - _loc3_.length / 30;
            alpha = Math.max(alpha * 0.8,_loc4_);
         }
         else
         {
            y = y * 0.75 + 500 * 0.25;
            this.mToggleShow.y = 5;
            alpha = alpha * 0.2 + 1.1;
         }
      }
      
      public function OnToggleShow(param1:MouseEvent) : *
      {
         this.mToggleShow.hiding = !this.mToggleShow.hiding;
         this.mToggleShow.gotoAndStop(!!this.mToggleShow.hiding ? 2 : 1);
      }
      
      public function FireEvent(param1:String, param2:Object = null) : void
      {
         this.mEventArgs = param2;
         dispatchEvent(new Event(param1));
      }
      
      public function GetEventArgs(param1:String = null) : *
      {
         return this.mEventArgs;
      }
      
      public function MakeButtonSet() : ButtonSet
      {
         var _loc1_:ButtonSet = new ButtonSet();
         addChild(_loc1_);
         _loc1_.Init();
         this.mButtonSets.push(_loc1_);
         _loc1_.presence = 0;
         return _loc1_;
      }
      
      public function MakeBackButton(param1:ButtonSet, param2:ButtonSet) : void
      {
         var bset:ButtonSet = param1;
         var prev_set:ButtonSet = param2;
         var button:Button = new Button();
         var icon:Icon = new Icon();
         icon.gotoAndStop("back");
         button.Init("","back",function(param1:Boolean):*
         {
            if(param1)
            {
               ActivateSet(prev_set);
            }
         },icon);
         bset.AddButton(button,0,0);
         this.SetButtonTooltip(button,"back");
      }
      
      public function ActivateSet(param1:ButtonSet) : void
      {
         this.mActiveSet = param1;
      }
      
      public function SetButtonTooltip(param1:Button, param2:String = "") : void
      {
         var button:Button = param1;
         var mouse_over:String = param2;
         button.addEventListener(MouseEvent.MOUSE_OVER,function(param1:Event = null):*
         {
            SetTooltip(mouse_over);
         });
         button.addEventListener(MouseEvent.MOUSE_OUT,function(param1:Event = null):*
         {
            if(mTooltip.text == mouse_over)
            {
               SetTooltip("");
            }
         });
      }
      
      public function SetTooltip(param1:String = "") : void
      {
         this.mTooltip.text = param1;
      }
      
      public function Make_EyesButton(param1:String) : Button
      {
         var eye_set:String = param1;
         var button:Button = new Button();
         var eyes:Eyes = new Eyes();
         eyes.gotoAndStop(eye_set);
         eyes.scaleX = eyes.scaleY = 0.4;
         eyes.filters = [new DropShadowFilter(2,45,0,0.5,8,8,1)];
         button.Init("eye-" + eye_set,"Eye Set: " + eye_set,function(param1:Boolean):*
         {
            if(param1)
            {
               FireEvent("OnSetEyes",{"eye_set":eye_set});
            }
         },eyes);
         return button;
      }
      
      public function Make_MouthButton(param1:String) : Button
      {
         var mouth_set:String = param1;
         var button:Button = new Button();
         var mouth:Mouth = new Mouth();
         mouth.gotoAndStop(mouth_set);
         mouth.scaleX = mouth.scaleY = 1.5;
         mouth.filters = [new DropShadowFilter(2,45,0,0.5,8,8,1)];
         button.Init("mouth-" + mouth_set,"Mouth Set: " + mouth_set,function(param1:Boolean):*
         {
            if(param1)
            {
               FireEvent("OnSetMouth",{"mouth_set":mouth_set});
            }
         },mouth);
         return button;
      }
      
      public function Make_VowelButton(param1:String) : Button
      {
         var label:MovieClip = null;
         var display_name:String = null;
         var mouth:Mouth = null;
         var vowel:String = param1;
         var button:Button = new Button();
         if(vowel != "?")
         {
            mouth = new Mouth();
            mouth.Init();
            mouth.ChangePhase(vowel);
            mouth.scaleX = mouth.scaleY = 1.5;
            mouth.filters = [new DropShadowFilter(2,45,0,0.5,8,8,1)];
            label = mouth;
            display_name = "Mouth Shape " + vowel;
         }
         else
         {
            label = new Icon();
            label.gotoAndStop("random");
            display_name = "Random Mouth Shape";
         }
         button.Init("mp-" + vowel,display_name,function(param1:Boolean):*
         {
            FireEvent("OnMouthPhase",{
               "phase":vowel,
               "start":param1
            });
         },label);
         return button;
      }
      
      public function Make_BackdropButton(param1:*) : Button
      {
         var BG:Backdrop = null;
         var icon:Icon = null;
         var bg:* = param1;
         var button:Button = new Button();
         if(bg != "url")
         {
            BG = new Backdrop();
            BG.Init();
            BG.LoadBg(bg);
            BG.scaleX = BG.scaleY = 40 / 640;
            BG.x -= 15;
            BG.y -= 14;
            BG.scrollRect = new Rectangle((640 - 500) / 2,0,500,480);
            BG.filters = [new DropShadowFilter(2,45,0,0.5,8,8,1)];
            button.Init("bg-" + bg,"Background: " + bg,function(param1:Boolean):*
            {
               FireEvent("OnSetBackdrop",{"frame":bg});
            },BG);
            this.SetButtonTooltip(button,BG.currentLabel || "background " + BG.currentFrame);
         }
         else
         {
            icon = new Icon();
            icon.gotoAndStop("my_pictures");
            button.Init("lcb","Load custom background",function(param1:Boolean):*
            {
               var down:Boolean = param1;
               if(down)
               {
                  SelectFiles(new FileFilter("*.swf;*.jpg;*.jpeg;*.gif;*.png","*.swf;*.jpg;*.jpeg;*.gif;*.png"),function(param1:ByteArray):*
                  {
                     FireEvent("OnSetBackdrop",{"data":param1});
                  });
               }
            },icon);
            this.SetButtonTooltip(button,"load custom background");
         }
         return button;
      }
      
      public function SelectFiles(param1:FileFilter, param2:Function) : *
      {
         this.mFileRef.browse([param1]);
         this.mOnSelectFile = param2;
      }
      
      public function OnFileRefSelect(param1:Event) : *
      {
         this.mFileRef.load();
      }
      
      public function OnFileRefLoad(param1:Event) : *
      {
         if(this.mOnSelectFile != null)
         {
            this.mOnSelectFile(this.mFileRef.data);
         }
         this.mOnSelectFile = null;
      }
      
      internal function frame1() : *
      {
      }
   }
}
