package scripts{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.*;
	import scripts.Coordinate;
	import scripts.User;
	import scripts.DataController;
	import scripts.ColorController;
	
	/**
	 * SurfaceDisplay
	 *
	 * The main controller class, coordinating mouse i/o and remote data
	 * Performs all drawing to the display
	 */
	public class SurfaceDisplay extends Sprite {
		
		private var mMouseDown:Boolean;	// Indicates that the mouse is down
		private var mCoordinateArray:Array; // List of points in the current drawing path
		
		private var mDrawSurface:Shape; // Local drawing surface
		private var mDrawSurfaceRx:Shape; // Remote drawing surface
		private var mClearField:TextField; // Clear button
		
		private var mUser:User; // Current User
		private var mDataController:DataController; // Remote data rx controller
		private var mColorController:ColorController; // User color list
		
		
		/**
		* Constructor
		*/
		public function SurfaceDisplay()
		{
			// Initialize Variables
			mMouseDown = false;
			mCoordinateArray = null;
			mDrawSurface = null;
			mDrawSurfaceRx = null;
			mClearField = null;
			mDataController = null;
			
			// Configure current user
			mUser = new User();
			
			// Setup Drawing Shape and Clear Box
			resetDrawSurface();
			resetClearBox();
			
			// User Coloring Controller
			mColorController = new ColorController();
			
			// Start polling for updates
			mDataController = new DataController();
			mDataController.addEventListener( "onFetch", handleDataFetch );
			mDataController.enableFetch( true );
		
			// Add mouse handlers
			stage.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
		}
		
		/**
		 * Reset Local Drawing Surface
		 *
		 * Destroy and create local drawing surface
		 */
		private function resetDrawSurface()
		{
			if( mDrawSurface )
				removeChild( mDrawSurface );
				
			mDrawSurface = new Shape();
			mDrawSurface.graphics.lineStyle( 4, 0x000000 );
			addChild( mDrawSurface );
		}
		
		/**
		 * Reset Remote Surface
		 *
		 * Destroy and create remote drawing surface
		 */
		private function resetRemoteSurface()
		{
			if( mDrawSurfaceRx )
			{
				removeChild( mDrawSurfaceRx );
			}
			mDrawSurfaceRx = new Shape();
			mDrawSurfaceRx.graphics.lineStyle( 4, 0x00CCCC );
			addChild( mDrawSurfaceRx );
		}
		
		/**
		 * Draw Clear Box
		 *
		 * Destroy and create Clear button
		 */
		private function resetClearBox()
		{
			// Remove field if already exists
			if( mClearField )
				removeChild( mClearField );
				
			// Text Formatting
			var format:TextFormat = new TextFormat();
			format.color = "0x999999";
			format.size = "16";
			format.align = "left";
			format.font = "Verdana";
			
			// Create and add text field
			mClearField = new TextField();
			mClearField.text = "Clear";
			mClearField.setTextFormat( format );
			addChild( mClearField );
			mClearField.width = 100;
			mClearField.height = 50;
			
			mClearField.addEventListener( MouseEvent.CLICK, handleClearClick );
		}
		
		/**
		 * Clear Drawing Surface
		 *
		 * Reset all drawing surfaces
		 */
		private function handleClearClick( inEvent:MouseEvent )
		{
			resetDrawSurface();
			resetRemoteSurface();
			resetClearBox();
			
			mDataController.clearData();
		}
		
		/**
		* Handle Mouse Down Event
		*
		* param inEvent:MouseEvent Mouse Down Event
		*/
		private function handleMouseDown( inEvent:MouseEvent )
		{
			if( !mMouseDown )
			{
				// Clear out coordinate array
				mCoordinateArray = new Array();
				mCoordinateArray.push( new Coordinate( inEvent.stageX, inEvent.stageY ) );
									  
				// Start line
				mMouseDown = true;
				mDrawSurface.graphics.moveTo( inEvent.stageX, inEvent.stageY );
			}
		}
		
		/**
		* Handle Mouse Up Event
		*
		* param inEvent:MouseEvent Mouse Up Event
		*/		
		private function handleMouseUp( inEvent:MouseEvent )
		{
			if( mMouseDown )
			{
				// Add last coordinate
				mCoordinateArray.push( new Coordinate( inEvent.stageX, inEvent.stageY ) );
				sendCoordinates();
						
				// End line
				mMouseDown = false;
			}
		}
		
		/**
		* Handle Mouse Move Event
		*
		* param inEvent:MouseEvent Mouse Move Event
		*/		
		private function handleMouseMove( inEvent:MouseEvent )
		{
			if( mMouseDown )
			{
				// Add coordinate
				mCoordinateArray.push( new Coordinate( inEvent.stageX, inEvent.stageY ) );
				
				// Move line to next position
				mDrawSurface.graphics.lineTo( inEvent.stageX, inEvent.stageY );
			}
		}
		
		/**
		 * Send Coordinate Array
		 *
		 * Send list of mouse positions to the server
		 */
		private function sendCoordinates()
		{
			if( mCoordinateArray.length <= 0 )
				return;
			
			mDataController.sendCoordinateArray( mUser, mCoordinateArray );
		}
		

		/**
		 * Handle Remote Data Fetch
		 *
		 * Callback from data controller when data has been
		 * successfully pulled
		 */
		private function handleDataFetch
			(
			inEvent:Event 
			)
		{
			var remoteList:Array = mDataController.getCoordinateList();
			drawRemoteThread( remoteList );
		}
		
		
		/**
		 * Draw Remote Thread
		 *
		 * Draw a list of coordinates to the remote surface
		 */
		private function drawRemoteThread
			(
			inCoordinateList:Array
			)
		{
			// Reset
			resetRemoteSurface();
			mDrawSurfaceRx.graphics.moveTo( 0, 0 );
			
			// Clear if nothing exists- indicates a user clear
			if( inCoordinateList.length <= 0 )
			{
				resetDrawSurface();
				return;
			}
			
			var curThread:int = -1;
			var curUser:int = -1;
			for( var i:int = 0; i < inCoordinateList.length; i++ )
			{
				// Skip current user
				if( inCoordinateList[i].getUserID() == mUser.getUserID() )
					continue;
					
				// User Change: Change Color
				if( inCoordinateList[i].getUserID() != curUser )
				{
					var color:uint = 0x000000;
					if( inCoordinateList[i].getUserID() != mUser.getUserID() )
					{
						color = mColorController.getColorForUser( inCoordinateList[i].getUserID() );
					}
					mDrawSurfaceRx.graphics.lineStyle( 4, color );
				}
				
				if( inCoordinateList[i].getThreadID() != curThread )
				{
					// Thread Change: Move to new position
					curThread = inCoordinateList[i].getThreadID();
					if( curThread >= 0 )
					{
						mDrawSurfaceRx.graphics.moveTo( inCoordinateList[i].getX(), inCoordinateList[i].getY() );
					}
				}
				else
				{
					// Move to new point
					mDrawSurfaceRx.graphics.lineTo( inCoordinateList[i].getX(), inCoordinateList[i].getY() );
				}
			}
		}
		
	}
}