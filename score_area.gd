extends Area2D

func _on_area_2d_body_exited(_body):
	SignalBus.player_passed_pipe.emit()

