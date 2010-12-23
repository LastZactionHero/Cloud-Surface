package scripts{
	
	import scripts.User;
	import fl.motion.Color;
	
	/**
	 * ColorController
	 *
	 * Maintains a list of user colors
	 */
	public class ColorController {

		private var mListUsers:Array; // List of users
		private var mListColors:Array; // List of colors
		
		/**
		 * Constructor
		 */
		public function ColorController() 
		{
			mListUsers = new Array;
			mListColors = new Array;
		}
		
		/**
		 * Get Color for a User
		 *
		 * return uint color
		 */
		public function getColorForUser
			(
			inUser:int
			):uint
		{
			// Return the user color, if stored
			for( var i:int = 0; i < mListUsers.length; i++ )
			{
				if( mListUsers[i] == inUser )
				{
					return mListColors[i]
				}
			}
			
			// Generate a new color for this user
			var newColor:uint = generateRandomColor();
			mListUsers.push( inUser );
			mListColors.push( newColor );
			
			return newColor;
		}

		/**
		 * Pick a random color
		 *
		 * return uint color
		 */
		private function generateRandomColor():uint
		{
			var red:uint = 00;
			var green:uint = 00;
			var blue:uint = 00;
			
			red = Math.floor( Math.random() * 256 );
			green = Math.floor( Math.random() * 256 );
			blue = Math.floor( Math.random() * 256 );
			
			var color:uint = red * ( 256 * 256 ) + blue * 256 + green;
			return color;
		}
	}
	
}
