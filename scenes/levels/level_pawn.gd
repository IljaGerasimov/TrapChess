extends Node2D

# The proportions
const GRID_WIDTH = 18
const GRID_HEIGHT = 9
const TILE_SIZE = 128

# The big leagues
enum Tool { NONE, PLATFORM, SPIKE, SPAWN, FINISH, FOUNDATION }
var current_tool = Tool.PLATFORM
var current_map_data = {} #: Key Vector2i(x,y)

# LOAD ASSETS
var tex_platform = preload("res://sprites/PlatformClosed.png")
var tex_spike = preload("res://sprites/TrapOpen.png")
var tex_spawn_top = preload("res://sprites/Spawn_tile.png")
var tex_foundation = preload("res://sprites/foundation_tile.png")
var tex_finish_top = preload("res://sprites/Finish_tile.png")

@onready var preview = $PlacementPreview

# ---FUNCTIONS-----------------------------------------------

func _ready():
	# Only the host/ server decides map layout (Authority)
	if multiplayer.is_server():
		generate_level_layout()

func generate_level_layout():
	# A random height for the Start (1, 4 and 7)
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# randomly chooses number between 2 and 6 for start and finish
	var rand_start = rng.randi_range(2, 6)
	var rand_finish = rng.randi_range(2, 6)

	# Sends the randomized numbers over as arrays to the RPC
	setup_map.rpc([rand_start], [rand_finish])

@rpc("call_local", "reliable")
func setup_map(starts, goals):
	# Deletes previous instances on restart
	# Build Start-Pillars (far left: row 0)
	for y_pos in starts:
		build_pillar(0, y_pos, tex_spawn_top)

	for y_pos in goals:
		build_pillar(GRID_WIDTH - 1, y_pos, tex_finish_top)

func build_pillar(x, target_y, top_tex):
	# builds from target_y till the ground (y = 8)
	for y in range(target_y, GRID_HEIGHT):
		var s = Sprite2D.new()
		s.centered = false # Important for snapping
		s.position = Vector2(x * TILE_SIZE, y * TILE_SIZE)

		# The upper tile gets the orange/purple tile, the rest is foundattion
		if y == target_y:
			s.texture = top_tex
		else:
			s.texture = tex_foundation

		add_child(s)
		
func _process(_delta):
	# Softsnapping for the preview
	# rounding mouse_pos to the nearest multiple of 128
	var mouse_pos = get_global_mouse_position()
	# clamp: constraints to the game area
	var snap_x = clamp(floor(mouse_pos.x / TILE_SIZE), 0, GRID_WIDTH - 1)
	var snap_y = clamp(floor(mouse_pos.y / TILE_SIZE), 0, GRID_HEIGHT - 1)
	
	# preview jumps from tile to tile
	preview.global_position = Vector2(snap_x * TILE_SIZE, snap_y * TILE_SIZE)
	# $PlacementPreview.global_position = Vector2(snap_x, snap_y)
