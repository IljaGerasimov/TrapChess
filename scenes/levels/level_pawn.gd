extends Node2D

# the holy proportions
const GRID_WIDTH = 18
const GRID_HEIGHT = 9
const TILE_SIZE = 128

# The big leagues
enum Tool { NONE, BLOCK, SPIKE, SPAWN, FINISH }
var current_tool = Tool.BLOCK

# LOAD ASSETS
var tex_block = preload("res://sprites/PlatformClosed.png")
var tex_spike = preload("res://sprites/TrapOpen.png")
var tex_spawn = preload("res://sprites/Spawn_tile.png")
var tex_finish = preload("res://sprites/Spawnandfinish_tile.png")

@onready var preview = $PlacementPreview

func _ready():
	setup_camera()
	# optionally drawss an empty grid for orientation
	queue_redraw()

func setup_camera():
	var cam = Camera2D.new()
	add_child(cam)
	
	# calculates the center of the grid
	var center_x = (GRID_WIDTH * TILE_SIZE) / 2
	var center_y = (GRID_HEIGHT * TILE_SIZE) / 2
	cam.position = Vector2(center_x, center_y)

	# calculates zoom, so that 2304px can fit into a 1920px screen
	# 1920 / 2304 = ~0.83
	var zoom_factor = 1920.0 / (GRID_WIDTH * TILE_SIZE)
	cam.zoom = Vector2(zoom_factor, zoom_factor)
	
func _process(_delta):
	# Softsnapping for the preview
	# rounding mouse_pos to the nearest multiple of 128
	var mouse_pos = get_global_mouse_position()
	var snap_x = floor(mouse_pos.x / TILE_SIZE) # * 128
	var snap_y = floor(mouse_pos.y / TILE_SIZE) # * 128
	
	# constraint to game area
	snap_x = clamp(snap_x, 0, GRID_WIDTH - 1)
	snap_y = clamp(snap_y, 0, GRID_HEIGHT - 1)
	
	# preview jumps from tile to tile
	preview.global_position = Vector2(snap_x * TILE_SIZE, snap_y * TILE_SIZE)
	# $PlacementPreview.global_position = Vector2(snap_x, snap_y)
