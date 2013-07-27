package  
{
	/**
	 * ...
	 * @author arthur e fabio
	 */
	public class Action 
	{
		public static const NONE:int = 0;
		public static const LEFT:int = 1 << 0;
		public static const RIGHT:int = 1 << 1;
		
		public function Action() 
		{
			
		}
		
		public static function getAction (keyCode : int) : int
		{
			switch (keyCode)
			{
				case 65:
				case 37:
					return LEFT;
					
				case 68:
				case 39:
					return RIGHT;
					
				default:
					return NONE;
			}
		}
		
	}

}