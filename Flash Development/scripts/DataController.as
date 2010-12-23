package scripts{
	
	import flash.net.*;
	import flash.utils.Timer;
	import flash.events.*;
	import scripts.User;
	import scripts.Coordinate;
	
	/**
	 * DataController
	 *
	 * Class manages sending and receiving data from the server
	 */
	public class DataController extends EventDispatcher{
		private var mFetchActive:Boolean; // Fetching is enabled/disabled
		private var mIsFetching:Boolean; // Currently downloading from server
		private var mFetchTimer:Timer; // Periodic fetch timer
		
		private var mCoordinateListRemote:Array; // List of downloaded points
		
		/**
		 * Constructor
		 */
		public function DataController() {
			mFetchActive = false;
			mIsFetching = false;
			mCoordinateListRemote = new Array();
			
			mFetchTimer = new Timer( 2000 );
			mFetchTimer.addEventListener( TimerEvent.TIMER, handleFetchTimer ); 
			mFetchTimer.start();			
		}
		
		/**
		 * Send Clear Command
		 */
		public function clearData()
		{
			// Clear stored coordinate array
			mCoordinateListRemote = new Array();
			
			// Send clear command to server
			var loader:URLLoader = new URLLoader();
			var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
			var request:URLRequest = new URLRequest( "http://cloudsurface.heroku.com/drawings/clear_all" );
			request.requestHeaders.push(header);
			loader.load( request );
		}

		/**
		 * Send Coordinate Array
		 *
		 * param inCoordinates:Array
		 */
		function sendCoordinateArray
			(
			 inUser:User,
			 inCoordinates:Array
			 )
		{
			// Reduce drawing data set
			var reducedList:Array = reduceCoordinateResolution( inCoordinates );
			
			// Assemble parameters
			var paramString:String = "?user=" + inUser.getUserID().toString() + "&points="
			for( var i:int = 0; i < reducedList.length; i++ )
			{
				paramString += reducedList[i].getX() + "," + reducedList[i].getY();
				if( i < ( reducedList.length - 1 ) )
					paramString += ","
			}
			
			// Send data to server
			var loader:URLLoader = new URLLoader();
			var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
			var request:URLRequest = new URLRequest( "http://cloudsurface.heroku.com/drawings/new_thread" + paramString );
			request.requestHeaders.push(header);
			loader.load( request );
		}
		
		/**
		 * Reduce Coordinate Resolution
		 *
		 * Remove points in the drawing to reduce the amount 
		 * of data
		 */
		private function reduceCoordinateResolution
			(
			 inList:Array
			 ):Array
		{
			// Pick every 5th element
			var reducedList:Array = new Array();
			for( var i:int = 0; i < inList.length / 5; i++ )
			{
				if( inList[5 * i] )
				{
					reducedList.push( inList[5 * i] );
				}
			}
			reducedList.push( inList[inList.length - 1] );
			return reducedList;
		}
		
		/**
		 * Enable Data Fetching
		 */
		function enableFetch
			(
			 inFetchEnabled:Boolean
			 )
		{
			mFetchActive = true;
		}
		
		/**
		 * Handle Fetch Timer Event
		 */
		function handleFetchTimer
			(
			inEvent:TimerEvent
			)
		{			
			if( mFetchActive && !mIsFetching )
			{
				mIsFetching = true;

				// Send request for data
				var loader:URLLoader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, handleFetchComplete );
				var request:URLRequest = new URLRequest( "http://cloudsurface.heroku.com/drawings.xml?nocache=" + new Date().getTime() );
				loader.load( request );
			}
		}
		
		/**
		 * Handle Data Fetch Response
		 */
        private function handleFetchComplete(event:Event)
		{
			// Retrieve data
            var loader:URLLoader = URLLoader(event.target);
			var xmlData:XML = new XML( loader.data );
			
			// Build list of coordinates
			mCoordinateListRemote = new Array();
			
			for each( var drawing:XML in xmlData.drawing )
			{
				var thread:int = drawing.thread;
				var user:int = drawing.user;
				var crdX:int = drawing.x;
				var crdY:int = drawing.y;
				
				mCoordinateListRemote.push( new Coordinate( crdX, crdY, user, thread ) );
			}
			mIsFetching = false;
			
			// Send completion event
			dispatchEvent( new Event( "onFetch" ) );
        }
		
		/**
		 * Get Remote Coordinate List
		 */
		public function getCoordinateList():Array
		{
			return mCoordinateListRemote;
		}
	}
	
}
