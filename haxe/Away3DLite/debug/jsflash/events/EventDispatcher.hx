/**
 * ...
 * @author neash
 */

package jsflash.events;
import jsflash.display.DisplayObject;
import jsflash.events.IEventDispatcher;

class Listener
{
   public var mListner : Function;
   public var mUseCapture : Bool;
   public var mPriority : Int;
   static var sIDs = 1;
   public var mID:Int;

   public function new(inListener,inUseCapture,inPriority)
   {
      mListner = inListener;
      mUseCapture = inUseCapture;
      mPriority = inPriority;
      mID = sIDs++;
   }

   public function Is(inListener,inCapture)
   {
      return Reflect.compareMethods(mListner,inListener) && mUseCapture == inCapture;
   }

   public function dispatchEvent(event : Event)
   {
      mListner(event);
   }
}

typedef ListenerList = Array<Listener>;

typedef EventMap = Hash<ListenerList>;

/**
* @author	Hugh Sanderson
* @author	Russell Weir
**/
class EventDispatcher implements IEventDispatcher
{
	var mTarget:IEventDispatcher;
	var mEventMap : EventMap;
	var isInDisplayList:Bool;
	static var mIDBase = 0;

	  public function new(?target : IEventDispatcher) : Void
	  {
		if (Std.is(this, DisplayObject))
			isInDisplayList = true;

	     if(mTarget != null)
	       mTarget = target;
	     else
	       mTarget = this;
	     mEventMap = new EventMap();
	  }

	  public function addEventListener(type:String, inListener:Function,
	      ?useCapture:Bool /*= false*/, ?inPriority:Int /*= 0*/,
	      ?useWeakReference:Bool /*= false*/):Int
	  {
	     var capture:Bool = useCapture==null ? false : useCapture;
	     var priority:Int = inPriority==null ? 0 : inPriority;

	     var list = mEventMap.get(type);
	     if (list==null)
	     {
	        list = new ListenerList();
	        mEventMap.set(type,list);
	     }

	     var l =  new Listener(inListener,capture,priority);
	     list.push(l);
	     // trace("Add listener " + type +" now:" + list);
	     return l.mID;
	  }
	  
	  public function toString()
	  {
		  return "[EventDispatcher]";
	  }

	  public function dispatchEvent(event : Event) : Bool
	  {
			var retval:Bool = false;
			if(event.target == null)
			{
				event.target = mTarget;
				if (this.isInDisplayList && event.capturing)
				{
					event.SetPhase(EventPhase.CAPTURING_PHASE);
					var dsp:DisplayObject = cast this;
					var stack = [];
					var len = 0;
					while (dsp != null)
					{
						stack.push(dsp);
						dsp = dsp.parent;
						len++;
					}
					while (len-- > 0)
					{
						stack.pop().DispatchEventInternal(event);
						if (event.IsCancelled())
							return true;
					}
				}
				
				event.SetPhase(EventPhase.AT_TARGET);
				
				retval = DispatchEventInternal(event);
				if (event.bubbles)
					event.SetPhase(EventPhase.BUBBLING_PHASE);
					
				if (event.eventPhase == EventPhase.BUBBLING_PHASE)
				{
					var dsp:DisplayObject = cast this;
					while (dsp != null)
					{
						dsp.DispatchEventInternal(event);
						dsp = dsp.parent;
					}
				}
				return retval;
			} else {
				return DispatchEventInternal(event);
			}
	  }
	
	public function DispatchEventInternal(event:Event):Bool 
	{
		 event.currentTarget = this;
		 var list = mEventMap.get(event.type);
	     var capture = event.eventPhase==EventPhase.CAPTURING_PHASE;
	     if (list!=null)
	     {
	        var idx = 0;
	        while(idx<list.length)
	        {
	           var listener = list[idx];
	           if (listener.mUseCapture==capture)
	           {
	              listener.dispatchEvent(event);
	              if (event.IsCancelledNow())
	                 return true;
	           }
	           // Detect if the just used event listener was removed...
	           if (idx<list.length && listener!=list[idx])
	           {
	              // do not advance to next item because it looks like one was just removed
	           }
	           else
	              idx++;
	        }
	        return true;
	     }

	     return false;
	}
	

	public function CapturePhaseDispatch(event:Event):Void 
	{
		if (!this.isInDisplayList)
		{
			event.SetPhase(EventPhase.AT_TARGET);
			return;
		}
		
		var displayObj:DisplayObject = cast this;
		displayObj.root.CapturePhaseDispatch(event);
	}


	  public function hasEventListener(type : String)
	  {
	     return mEventMap.exists(type);
	  }
	  public function removeEventListener(type : String, listener : Function,
	             ?inCapture : Bool) : Void
	  {
	     if (!mEventMap.exists(type)) return;

	     var list = mEventMap.get(type);
	     var capture:Bool = inCapture==null ? false : inCapture;
	     for(i in 0...list.length)
	     {
	        if (list[i].Is(listener,capture))
	        {
	            list.splice(i,1);
	            return;
	        }
	     }
	  }

	  public function RemoveByID(inType:String,inID:Int) : Void
	  {
	     if (!mEventMap.exists(inType)) return;

	     var list = mEventMap.get(inType);
	     for(i in 0...list.length)
	     {
	        if (list[i].mID == inID)
	        {
	            list.splice(i,1);
	            //trace("remove " + i);
	            return;
	        }
	     }
	     //trace("could not remove?");
	  }


	  public function willTrigger(type : String) : Bool
	  {
	     return hasEventListener(type);
	  }

	  public function DumpListeners()
	  {
	     trace(mEventMap);
	  }


	/**
	* Creates and dispatches a typical Event.COMPLETE
*/
	public function DispatchCompleteEvent() {
		var evt = new Event(Event.COMPLETE);
		dispatchEvent(evt);
	}

	/**
	* Creates and dispatches a typical IOErrorEvent.IO_ERROR
	*/
	public function DispatchIOErrorEvent() {
		var evt = new IOErrorEvent(IOErrorEvent.IO_ERROR);
		dispatchEvent(evt);
	}
}