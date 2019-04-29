
package {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	
	public class FlappyBird extends MovieClip
	{
		private var score:Number;
		private var speed:Number;
		private var pipes:Array;
		private var gotoWin, gotoLose, playerClicked:Boolean;
		
		public function FlappyBird()
		{
			
		}
		
		//All Start Functions
		public function startMenu()
		{
			stop();
			btnStartGame.addEventListener(MouseEvent.CLICK, gotoStartGame);
		}
		
		public function startWin()
		{
			btnBack.addEventListener(MouseEvent.CLICK, gotoMenu);
		}
		
		public function startLose()
		{
			btnBack.addEventListener(MouseEvent.CLICK, gotoMenu);
		}
		
		public function startGame()
		{	
			mcPlayer.gotoAndPlay("right");
			score = 0;
			speed = 0;
			
			gotoWin = false;
			gotoLose = false;
			playerClicked = false;
			
			pipes = new Array(	"pipe1a","pipe1b","pipe2a","pipe2b","pipe3a","pipe3b",
								"pipe4a","pipe4b","pipe5a","pipe5b","pipe6a","pipe6b",
								"pipe7a","pipe7b","pipe8a","pipe8b");
			
			addEventListener(Event.ENTER_FRAME,update);
			stage.addEventListener(MouseEvent.CLICK,clicked);
			
			stage.focus = this;
		}
		
		//All Goto Functions
		private function gotoStartGame(evt:MouseEvent)
		{
			btnStartGame.removeEventListener(MouseEvent.CLICK, gotoStartGame);
			gotoAndStop("game");
		}
		
		private function gotoMenu(evt:MouseEvent)
		{
			btnBack.removeEventListener(MouseEvent.CLICK, gotoMenu);
			gotoAndStop("menu");
		}
		
		private function clicked(evt:MouseEvent)
		{
			playerClicked = true;
		}
		
		public function update(evt:Event)
		{
			handleUserInput();
			handleGameLogic();
			handleDraw();
			
			if (gotoWin)
				triggerGoToWin();
			else if (gotoLose)
				triggerGoToLose();
		}
		
		private function handleUserInput()
		{
			//Handle player 1 position
			if (playerClicked)
			{
				speed = -16;	
				playerClicked = false;	
			}
		}
		
		private function handleGameLogic()
		{
			//Update the bird position
			mcPlayer.y += speed;
			
			//Impose gravity
			speed += 1.4;
			
			//Check for collisions
			//Top and bottom walls
			if (mcPlayer.y <= 0)
			{
				gotoLose = true;
			}
			else if (mcPlayer.y >= 600)
			{
				gotoLose = true;
			}
			
			//update pipes
			for (var i in pipes)
			{
				var currPipeName = pipes[i];
				var currPipe = this[currPipeName];
				
				//Move the pipes
				currPipe.x -= 8;
				
				//Check collision with bird
				if (currPipe.hitTestPoint(mcPlayer.x, mcPlayer.y))
				{
					gotoLose = true;
				}
				
				//Add score
				if (currPipe.visible && currPipe.x <= 0)
				{
					score+=0.5;
					currPipe.visible = false;
				}
			}
			 
			//Check for win
			if (score >= 8)
				gotoWin = true;
		}
		
		private function handleDraw()
		{
			//Handle display
			txtScore.text = String(score);
		}
		
		private function triggerGoToWin()
		{
			removeEventListener(Event.ENTER_FRAME, update);
			gotoAndStop("win");
		}
		
		private function triggerGoToLose()
		{
			removeEventListener(Event.ENTER_FRAME, update);
			gotoAndStop("lose");
		}
		
	}//end class	
}//end package