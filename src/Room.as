package  
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author arthur e fabio
	 */
	public class Room extends Entity 
	{
		private var _player:Player;
		private var _frontScrollFactor : Number;
		private var _time : String = "day";
		private var _scrollAcc : Number = 0;
		
		public function Room() 
		{
			updateAssets();
		}
		
		public function addPlayer () : void
		{
			_player = Game.playerInstance;
			addChild(Game.playerInstance);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			super.addChild(child);
			setChildIndex(child, getChildIndex(getChildByName("s" + name + "_0")));
			return child;
		}
		
		public function removePlayer () : void
		{
			_player = null;
			removeChild(Game.playerInstance);
		}
		
		override protected function init(e:Event):void 
		{
			if (getChildByName("front"))
			{
				_frontScrollFactor = (getChildByName("front").width - 1024) / (getChildByName("back").width - 1024);
			}
			for (var i : int = 0; i < numChildren; i++)
			{
				var h : Hitbox;
				if ((h = (getChildAt(i) as Hitbox)))
				{
					h.visible = false;
				}
				if (getChildAt(i).name == name + "_area")
				{
					getChildAt(i).visible = false;
				}
			}
			super.init(e);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (_player)
			{
				if (_player.x < getChildByName(name + "_area").x)
				{
					_player.x = getChildByName(name + "_area").x;
				}
				else if (_player.x + _player.width > getChildByName(name + "_area").x + getChildByName(name + "_area").width)
				{
					_player.x = getChildByName(name + "_area").x + getChildByName(name + "_area").width - _player.width;
				}
				
				_player.resetFlag(Player.HIDDEN);
				var objectSet : Boolean = false;
				for (var i : int = 0; i < numChildren; i++)
				{
					var o : GameObject;
					var oMidPoint : Point;
					var h : Hitbox;
					var s : Shadow;
					if ((o = (getChildAt(i) as GameObject)))
					{
						o.hidden = false;
						for (var j : int = 0; j < numChildren; j++)
						{
							if ((s = getChildAt(j) as Shadow))
							{
								if (s.visible && s.hitTestPoint(o.x, o.y, true) && s.hitTestPoint(o.x + o.width, o.y, true))
								{
									o.hidden = true;
									break;
								}
							}
						}
						
						if (o.interactive && !o.hidden)
						{
							if ((h = (getChildByName("h" + name + "_" + o.id) as Hitbox)))
							{
								if (_player.getMidPoint().x <= h.x + h.width && _player.getMidPoint().x >= h.x)
								{
									o.over();
									_player.gameObject = o;
									objectSet = true;
								}
								else
								{
									o.out();
								}
							}
							else 
							{
								if (_player.getMidPoint().x <= o.x + o.width && _player.getMidPoint().x >= o.x)
								{
									objectSet = true;
									_player.gameObject = o;
									o.over();
								}
								else
								{
									o.out();
								}
							}
						}
					}
					
					if ((s = getChildAt(i) as Shadow))
					{
						if (s.visible)
						{
							if (_player.isOverlappedBy(s))
							{
								_player.setFlag(Player.HIDDEN);
								break;
							}
						}
					}
				}
				
				if (!objectSet)
				{
					_player.gameObject = null;
				}
				
				//scrollX
				var scrollX : Number = 0;
				if (_player.x >= 724 && _scrollAcc > -(getChildByName("back").width - 1024))
				{
					if (_scrollAcc - 1024 * Game.dt < -(getChildByName("back").width - 1024))
					{
						scrollX = -Math.round((_scrollAcc + (getChildByName("back").width - 1024)));
					}
					else
					{
						scrollX = -(_player.x - 724);
					}
					
					for (i = 0; i < numChildren; i++)
					{
						if (getChildAt(i).name != "front")
						{
							getChildAt(i).x += scrollX;
						}
						else
						{
							getChildAt(i).x += scrollX * _frontScrollFactor;
						}
					}
				}
				
				if (_player.x <= 300 && _scrollAcc < 0)
				{
					if ((_scrollAcc + 1024 * Game.dt) > 0)
					{
						scrollX = -Math.round(_scrollAcc);
					}
					else
					{
						scrollX = 300 - _player.x;
					}
					for (i = 0; i < numChildren; i++)
					{
						if (getChildAt(i).name != "front")
						{
							getChildAt(i).x += scrollX;
						}
						else
						{
							getChildAt(i).x += scrollX * _frontScrollFactor;
						}
					}
				}
				_scrollAcc += scrollX;
			}
		}
		
		override public function draw():void 
		{
			super.draw();
		}
		
		override protected function destroy(e:Event):void 
		{
			super.destroy(e);
		}
		
		public function updateAssets () : void
		{
			(getChildByName("back") as MovieClip).gotoAndStop(_time);
			if (getChildByName("front"))
			{
				(getChildByName("front") as MovieClip).gotoAndStop(_time);
			}
			
			var obj : GameObject;
			for (var i : int = 0; i < numChildren; i++)
			{
				if ((obj = (getChildAt(i) as GameObject)))
				{
					obj.time = _time;
					obj.updateAsset();
				}
			}
		}
	}

}