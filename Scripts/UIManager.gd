extends Control



func SetScore(Player, values):
	if Player == 1:
		
		$Scores/ScoreP1/Scores/Health.text = values[0]
	
		$Scores/ScoreP1/Scores/AP.text = values[1]
	
		$Scores/ScoreP1/Scores/Cards.text = values[2]
			
	if Player == 1:
		
		$Scores/ScoreP2/Scores/Health.text = values[0]
	
		$Scores/ScoreP2/Scores/AP.text = values[1]
	
		$Scores/ScoreP2/Scores/Cards.text = values[2]
# Called when the node enters the scene tree for the first time.
