package scripts{
	
	/**
	 * User ID Class
	 */
	public class User {
		var mUserID:int;	// User ID Number
		
		/**
		 * Constructor
		 */
		public function User() {
			mUserID = generateUserID();
		}
		
		/**
		 * Get User ID Number
		 *
		 * return User ID Number
		 */
		public function getUserID():int
		{
			return mUserID;
		}
		
		/**
		 * Generate a Random User ID Number
		 */ 
		private function generateUserID():int
		{
			var id:int = Math.floor( Math.random() * 1000 );
			return id;
		}
		
	}
}
