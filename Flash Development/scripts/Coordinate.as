package scripts{
	
	/**
	 * Generic Coordinate Class
	 */
	class Coordinate{
		
		private var mX:int;
		private var mY:int;
		private var mUserID:int;
		private var mThreadID:int;
		
		/**
		 * Constructor
		 *
		 * param inX:int X Coordinate
		 * param inY:int Y Coordinate
		 */
		public function Coordinate( inX:int = 0, inY:int = 0, inUserID:int = -1, inThreadID:int = -1 )
		{
			mX = inX;
			mY = inY;
			mUserID = inUserID;
			mThreadID = inThreadID;
		}
		
		/**
		 * Get X Coordinate
		 *
		 * return int x-coordinate
		 */
		public function getX():int{
			return mX;
		}
		
		/**
		 * Get Y Coordinate
		 *
		 * return int y-coordinate
		 */
		public function getY():int{
			return mY;
		}
		
		/**
		 * Get User ID
		 *
		 * return User ID
		 */
		public function getUserID():int
		{
			return mUserID;
		}
		
		/**
		 * Get Thread ID
		 *
		 * return Thread ID
		 */
		public function getThreadID():int
		{
			return mThreadID;
		}
		
		/** 
	     * Debug Print
		 */
		public function print()
		{
			trace( "(" + mX.toString() + "," + mY.toString() + ")" );
		}
	}
}
