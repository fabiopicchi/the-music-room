package  
{
	/**
	 * ...
	 * @author arthur e fabio
	 */
	public class LightSwitch extends InteractiveElement 
	{
		
		private var _lights : Array;
		
		public function LightSwitch() 
		{
			
		}
		
		public function loadData (data : Object) : void
		{
			_lights = ((data.lights is Array) ? data.lights : [data.lights]);
		}
		
		override public function interact(item : InventoryItem = null) : void
		{
			super.interact();
			
			var s : Light;
			for (var i : int = 0; i < _lights.length; i++)
			{	
				s = parent.getChildByName(_lights[i]) as Light;
				s.toggle();
			}
		}
	}

}