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
   
   public dynamic class Timeline extends Draggable
   {
       
      
      public var mActive:Boolean;
      
      public var mRecordingKey:Boolean;
      
      public var mRecordingMouse:Boolean;
      
      public var mLastRecordedMouseIdx:int;
      
      public var mLastEmptyMouseIdx:int;
      
      public var mPlaying:Boolean;
      
      public var mSkipping:Number;
      
      public var mFileRef:FileReference;
      
      public var mOnFileLoaded:Function;
      
      public var mPos:Number;
      
      public var mEventPos:int;
      
      public var mSound:Sound;
      
      public var mSoundChannel:SoundChannel;
      
      public var mDirectorEvents:Object;
      
      public var mMouseDown:Boolean;
      
      public var mMouseRecordEase:Number;
      
      public var mGhost:Cursors;
      
      public const INDEFINITE_STACKS:Object = {
         "eyes":true,
         "mouth":true
      };
      
      public const MRE_SPEED:Number = 6;
      
      public function Timeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Init() : void
      {
         SetDragTarget(mBack);
         mRecordKey.stop();
         mRecordMouse.stop();
         this.mMouseRecordEase = 0;
         this.mLastRecordedMouseIdx = 0;
         this.mRecordingKey = false;
         this.mRecordingMouse = false;
         this.mActive = false;
         visible = this.mActive;
         mPlayPause.gotoAndStop("play");
         this.mPlaying = false;
         this.mSkipping = 0;
         this.mPos = 0;
         this.mDirectorEvents = {};
         mMouseTimeline.Init();
         mDirectorView.Init();
         mSeeker.Init();
         mWave.Init();
         mPlayHead.Init(mWave);
         this.mFileRef = new FileReference();
         this.mFileRef.addEventListener(Event.SELECT,function(param1:Event = null):*
         {
            mFileRef.load();
         });
         this.mFileRef.addEventListener(Event.COMPLETE,function(param1:Event = null):*
         {
            var _loc2_:Function = mOnFileLoaded;
            mOnFileLoaded = null;
            _loc2_();
         });
         this.mFileRef.addEventListener(Event.CANCEL,function(param1:Event = null):*
         {
            mOnFileLoaded = null;
         });
         this.mSound = new Sound();
         this.InitRimButton(bRecordMouse,this.OnToggleRecordMouse);
         this.InitRimButton(bRecordKey,this.OnToggleRecord);
         this.InitRimButton(bTogglePlay,this.OnTogglePlay,null,"Play/Pause",Keyboard.ENTER);
         this.InitRimButton(bSkipBeginning,function(param1:Event):*
         {
            SeekSoundTo(0);
         },null,"Jump to Beginning");
         this.InitRimButton(bSkipEnd,function(param1:Event):*
         {
            SeekSoundTo(mSound.length);
         },null,"Jump to End");
         this.InitRimButton(bTrackForward,this.OnSeekFwd_Start,this.OnSeek_Stop,"Seek Forward",Keyboard.PERIOD);
         this.InitRimButton(bTrackBackward,this.OnSeekBack_Start,this.OnSeek_Stop,"Seek Backward",Keyboard.COMMA);
         this.InitRimButton(bLoadSong,this.OnTryLoadSong,null,"Load Audio");
         this.InitRimButton(bSave,this.OnTrySaveDance,null,"Save",Keyboard.F5);
         this.InitRimButton(bLoad,this.OnTryLoadDance,null,"Load",Keyboard.F7);
         this.InitRimButton(bHelp,function(param1:Event):*
         {
            Singleton.Get("help").Display("studio");
         });
         addEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
         this.UpdateTimeHead();
         this.UpdateTimeStamp();
         mSeeker.addEventListener(Event.CHANGE,function(param1:Event):*
         {
            SeekSoundTo(mSeeker.GetPercent() * mSound.length);
         });
         mPlayHead.addEventListener(Event.CHANGE,function(param1:Event):*
         {
            var _loc2_:Number = mPlayHead.mouseX / mDirectorView.PIXELS_PER_SEC * 1000;
            SeekSoundTo(mPos + _loc2_);
         });
         this.mGhost = new Cursors();
         stage.addChild(this.mGhost);
         this.mGhost.gotoAndStop("cursor");
         this.mGhost.visible = false;
         this.mGhost.alpha = 0.5;
         mClose.addEventListener(MouseEvent.MOUSE_DOWN,this.Toggle);
         addEventListener(MouseEvent.MOUSE_DOWN,this.EatEvent);
      }
      
      public function Toggle(param1:* = null) : void
      {
         this.mActive = !this.mActive;
         visible = this.mActive;
      }
      
      public function SeekSoundTo(param1:Number) : void
      {
         if(this.mSound.length > 0)
         {
            if(this.mSoundChannel)
            {
               this.mSoundChannel.stop();
            }
            if(param1 <= this.mSound.length && param1 >= 0)
            {
               this.mSoundChannel = this.mSound.play(param1,1);
               mWave.AttachChannel(this.mSoundChannel);
            }
         }
         this.UpdatePositionTo(param1);
      }
      
      public function UpdatePositionTo(param1:Number) : void
      {
         var _loc2_:Number = param1 - this.mPos;
         this.mPos = param1;
         this.UpdateTimeHead();
         this.UpdateTimeStamp();
      }
      
      public function UpdateTimeHead() : void
      {
         var _loc1_:Boolean = this.mRecordingKey;
         this.mRecordingKey = false;
         var _loc2_:Number = this.mPos - 250 / mDirectorView.PIXELS_PER_SEC * 1000;
         var _loc3_:Number = _loc2_ + 500 / mDirectorView.PIXELS_PER_SEC * 1000;
         mDirectorView.SetPos(_loc2_);
         mMouseTimeline.SetPos(_loc2_);
         mSeeker.SetPercent(Math.max(0,Math.min(this.mPos / this.mSound.length,1)));
         if(this.mActive)
         {
            mWave.Draw(_loc2_,_loc3_);
         }
         this.mRecordingKey = _loc1_;
      }
      
      public function UpdateTimeStamp() : void
      {
         var _loc1_:Number = this.mSound.length;
         tTime.text = this.FormatTime(this.mPos) + " / " + this.FormatTime(_loc1_);
      }
      
      public function FormatTime(param1:Number) : String
      {
         var _loc2_:* = param1 < 0;
         param1 = Math.abs(param1);
         var _loc3_:Number = param1 / 1000;
         var _loc4_:Number = Math.floor(_loc3_ / 60);
         _loc3_ %= 60;
         var _loc5_:String = String(_loc4_);
         var _loc6_:String;
         if((_loc6_ = String(Math.floor(_loc3_))).length < 2)
         {
            _loc6_ = "0" + _loc6_;
         }
         var _loc7_:String;
         if((_loc7_ = String(Math.floor(_loc3_ % 1 * 100))).length < 2)
         {
            _loc7_ = "0" + _loc7_;
         }
         return (_loc2_ ? "-" : "") + _loc5_ + ":" + _loc6_ + "." + _loc7_;
      }
      
      public function InitRimButton(param1:MovieClip, param2:Function = null, param3:Function = null, param4:String = null, param5:int = 0) : void
      {
         var _loc6_:KeyBind = null;
         param1.Init();
         if(param2 != null)
         {
            param1.addEventListener("OnPress",param2,false,1);
         }
         if(param3 != null)
         {
            param1.addEventListener("OnRelease",param3,false,1);
         }
         if(param4)
         {
            (_loc6_ = new KeyBind(param1.name,param4,param5)).SetListener(stage);
            if(param2 != null)
            {
               _loc6_.addEventListener(KeyboardEvent.KEY_DOWN,param2);
            }
            if(param3 != null)
            {
               _loc6_.addEventListener(KeyboardEvent.KEY_UP,param3);
            }
            Singleton.Get(KeyRebinder).AddKeyBind(_loc6_);
         }
      }
      
      public function OnToggleRecord(param1:Event = null) : void
      {
         this.OnToggleRecordKey(param1);
         this.OnToggleRecordMouse(param1);
      }
      
      public function OnToggleRecordKey(param1:Event = null) : void
      {
         this.mRecordingKey = !this.mRecordingKey;
         mRecordKey.gotoAndStop(this.mRecordingKey ? 2 : 1);
         mRecordKey.visible = true;
         mRecordKey.alpha = 1;
         this.mDirectorEvents = {};
         if(this.mRecordingKey)
         {
            Director.self.addEventListener(Director.ON_DIRECT,this.OnDirect);
         }
         else
         {
            Director.self.removeEventListener(Director.ON_DIRECT,this.OnDirect);
         }
      }
      
      public function OnMouseDown(param1:MouseEvent) : void
      {
         this.mMouseDown = true;
      }
      
      public function OnMouseUp(param1:MouseEvent) : void
      {
         this.mMouseDown = false;
      }
      
      public function OnDirect(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:DirectorEvent = null;
         if(this.mRecordingKey && Director.self.command == "stack")
         {
            _loc2_ = Director.self.args;
            _loc3_ = String(_loc2_.stack);
            _loc4_ = _loc2_.val;
            _loc5_ = Boolean(_loc2_.push);
            _loc6_ = _loc3_ + String(_loc4_);
            _loc7_ = this.mDirectorEvents[_loc6_] || new DirectorEvent(_loc3_,_loc4_,this.mPos);
            if(_loc5_)
            {
               _loc7_.start_ms = this.mPos;
               mDirectorView.AppendEntry(_loc7_);
               if(!this.INDEFINITE_STACKS[_loc3_])
               {
                  _loc7_.in_progress = true;
                  this.mDirectorEvents[_loc6_] = _loc7_;
               }
            }
            else
            {
               _loc7_.in_progress = false;
               _loc7_.end_ms = this.mPos;
               delete this.mDirectorEvents[_loc6_];
            }
         }
      }
      
      public function OnTogglePlay(param1:Event = null) : void
      {
         this.mPlaying = !this.mPlaying;
         mPlayPause.gotoAndStop(this.mPlaying ? "pause" : "play");
         if(this.mPlaying && this.mSound.length > 0)
         {
            if(this.mPos < this.mSound.length)
            {
               this.mSoundChannel = this.mSound.play(this.mPos,1);
               mWave.AttachChannel(this.mSoundChannel);
            }
         }
         else if(this.mSoundChannel)
         {
            this.mSoundChannel.stop();
         }
      }
      
      public function OnSeekFwd_Start(param1:Event = null) : void
      {
         this.mSkipping = 1;
         param1.stopPropagation();
      }
      
      public function OnSeekBack_Start(param1:Event = null) : void
      {
         this.mSkipping = -1;
         param1.stopPropagation();
      }
      
      public function OnSeek_Stop(param1:Event = null) : void
      {
         this.mSkipping = 0;
         param1.stopPropagation();
      }
      
      public function OnTryLoadSong(param1:Event = null) : void
      {
         this.mOnFileLoaded = this.OnSongLoad;
         this.mFileRef.browse([new FileFilter("mp3","*.mp3")]);
      }
      
      public function OnSongLoad() : void
      {
         this.mSound = new Sound();
         this.mSound.loadCompressedDataFromByteArray(this.mFileRef.data,this.mFileRef.data.length);
         mWave.Reset(this.mSound);
         this.UpdatePositionTo(0);
      }
      
      public function OnTryLoadDance(param1:Event = null) : void
      {
         this.mOnFileLoaded = this.OnDanceLoad;
         this.mFileRef.browse([new FileFilter("jig","*.jig")]);
      }
      
      public function OnDanceLoad() : void
      {
         var key_to_dirArgs:Array = null;
         var kbinds:Vector.<KeyBind> = null;
         var kb:KeyBind = null;
         var MapKeyBind:Function = null;
         var entry:* = undefined;
         var dirArgs:Object = null;
         var de:DirectorEvent = null;
         var dance:Object = this.mFileRef.data.readObject();
         if(dance.version == "0.1")
         {
            dance.director_events = new Array();
            key_to_dirArgs = new Array();
            kbinds = KeyBind.GetKeyBinds();
            MapKeyBind = function(param1:Event):void
            {
               key_to_dirArgs[kb.keyCode] = Director.self.args;
            };
            Director.self.addEventListener(Director.ON_DIRECT,MapKeyBind);
            for each(kb in kbinds)
            {
               kb.Press();
            }
            Director.self.removeEventListener(Director.ON_DIRECT,MapKeyBind);
            for each(entry in dance.key_seq)
            {
               dirArgs = key_to_dirArgs[entry.kc];
               if(dirArgs)
               {
                  de = new DirectorEvent(dirArgs.stack,dirArgs.val,entry.t0,entry.t1);
                  dance.director_events.push(de);
               }
            }
         }
         mMouseTimeline.LoadSequence(dance.mouse_seq);
         mDirectorView.LoadEntries(dance.director_events);
      }
      
      public function OnTrySaveDance(param1:Event = null) : void
      {
         var name:String;
         var data:ByteArray = null;
         var DEFAULT_NAME:String = null;
         var fileSave:FileReference = null;
         var e:Event = param1;
         var dance:Object = {
            "type":"Halfne Miku Dance",
            "version":"0.2",
            "mouse_seq":mMouseTimeline.SaveSequence(),
            "director_events":mDirectorView.SaveEntries(),
            "keybinds":{}
         };
         data = new ByteArray();
         data.writeObject(dance);
         DEFAULT_NAME = "MikuMiku";
         name = DEFAULT_NAME;
         if(this.mSound && this.mSound.id3 && this.mSound.id3.songName && this.mSound.id3.songName.length > 0)
         {
            name = this.mSound.id3.songName;
         }
         fileSave = new FileReference();
         try
         {
            fileSave.save(data,name + ".jig");
         }
         catch(ioe:IllegalOperationError)
         {
            fileSave.save(data,DEFAULT_NAME + ".jig");
         }
      }
      
      public function OnEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:DirectorEvent = null;
         var _loc4_:int = 0;
         var _loc5_:Point = null;
         var _loc6_:Boolean = false;
         var _loc7_:MovieClip = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(this.mSkipping != 0)
         {
            _loc2_ = this.mPos + this.mSkipping * 1000 / stage.frameRate;
            if(this.mPlaying && this.mSkipping > 0)
            {
               _loc2_ += 1000 / stage.frameRate;
            }
            this.SeekSoundTo(_loc2_);
            this.mSkipping *= Math.exp(0.1 / stage.frameRate);
         }
         if(this.mPlaying)
         {
            if(this.mSoundChannel)
            {
               if(this.mPos < 0)
               {
                  this.UpdatePositionTo(this.mPos + 1000 / stage.frameRate);
                  if(this.mPos <= 0)
                  {
                     this.mSoundChannel.stop();
                  }
                  else
                  {
                     this.mSoundChannel = this.mSound.play(this.mPos);
                  }
               }
               else
               {
                  this.UpdatePositionTo(this.mSoundChannel.position);
               }
            }
            else
            {
               this.UpdatePositionTo(this.mPos + 1000 / stage.frameRate);
            }
         }
         else if(this.mActive && Boolean(this.mSoundChannel))
         {
            this.mSoundChannel.stop();
         }
         if(this.mRecordingKey)
         {
            mRecordKey.gotoAndStop(new Date().milliseconds < 500 ? 2 : 3);
            for each(_loc3_ in this.mDirectorEvents)
            {
               if(!this.INDEFINITE_STACKS[_loc3_.stack_id])
               {
                  _loc3_.end_ms = this.mPos;
               }
            }
         }
         if(this.mRecordingMouse)
         {
            _loc4_ = int(mMouseTimeline.GetSampleIdx(this.mPos));
            _loc5_ = mMouseTimeline.GetSampleAt(this.mPos);
            _loc6_ = this.mMouseDown;
            this.mMouseRecordEase = Math.max(0,Math.min(this.mMouseRecordEase + (_loc6_ ? 1 : -1) * this.MRE_SPEED / stage.frameRate,1));
            _loc6_ ||= this.mMouseRecordEase > 0;
            mRecordMouse.alpha = _loc6_ ? 1 : 0.5;
            mRecordMouse.gotoAndStop(new Date().milliseconds < 500 ? 2 : 3);
            if(this.mPlaying && _loc6_)
            {
               _loc8_ = Number((_loc7_ = MovieClip(parent).Miku).mControl.x);
               _loc9_ = Number(_loc7_.mControl.y);
               if(Boolean(_loc5_) && this.mMouseRecordEase < 1)
               {
                  _loc10_ = this.mMouseRecordEase;
                  _loc8_ = _loc8_ * _loc10_ + (1 - _loc10_) * _loc5_.x;
                  _loc9_ = _loc9_ * _loc10_ + (1 - _loc10_) * _loc5_.y;
               }
               mMouseTimeline.Record(this.mPos,_loc8_,_loc9_);
               this.mLastRecordedMouseIdx = _loc4_;
            }
         }
         MovieClip(parent).ControlOverride = this.ControlOverride;
      }
      
      public function OnToggleRecordMouse(param1:Event = null) : void
      {
         this.mRecordingMouse = !this.mRecordingMouse;
         mRecordMouse.gotoAndStop(this.mRecordingMouse ? 2 : 1);
         this.mMouseDown = false;
         this.mLastRecordedMouseIdx = NaN;
         param1.stopImmediatePropagation();
         if(this.mRecordingMouse)
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         }
         else
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         }
      }
      
      public function ControlOverride(param1:Point) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         this.mGhost.visible = false;
         if(this.mRecordingMouse && mRecordMouse.alpha == 1 && this.mMouseRecordEase >= 1)
         {
            return;
         }
         var _loc2_:Point = mMouseTimeline.GetSampleAt(this.mPos);
         if(_loc2_)
         {
            _loc3_ = this.mMouseRecordEase;
            param1.x = param1.x * _loc3_ + _loc2_.x * (1 - _loc3_);
            param1.y = param1.y * _loc3_ + _loc2_.y * (1 - _loc3_);
            this.mGhost.visible = this.mActive;
            _loc4_ = MovieClip(parent).InverseTransformControl(_loc2_);
            this.mGhost.x = _loc4_.x;
            this.mGhost.y = _loc4_.y;
         }
      }
      
      public function EatEvent(param1:Event) : void
      {
         param1.stopImmediatePropagation();
      }
      
      internal function frame1() : *
      {
         this.mSkipping = 0;
      }
   }
}
