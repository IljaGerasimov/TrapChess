extends Node2D

func _process(_delta):
	var mouse_pos = get_global_mouse_position()

	# Snapping-Logic
	# rounding mouse_pos to the nearest multiple of 128
	var snap_x = floor(mouse_pos.x / 128) * 128
	var snap_y = floor(mouse_pos.y / 128) * 128
	
	# preview jumps from tile to tile
	$PlacementPreview.global_position = Vector2(snap_x, snap_y)
