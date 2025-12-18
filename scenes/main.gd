extends Node

# const: like #define or const int in c
const PORT = 7000
const MAX_CLIENTS = 2

# dereferencing the Lobby-Node
@onready var lobby = $Lobby

# --- MAIN FUNCTIONS----------------------------------------------

# func _ready(): like the main() in C but sepperately for each Object
# Called only once when objects scene loads
func _ready():
	#if Lobby sends a signal execute functions _on_...
	lobby.host_game.connect(_on_host_game)
	lobby.join_game.connect(_on_join_game)

# --- HOST LOGIC----------------------------------------------

func _on_host_game(player_name):
	# malloc/new networking-object
	var peer = ENetMultiplayerPeer.new()

	# test Server Connection (return Error code)
	var error = peer.create_server(PORT, MAX_CLIENTS)
	if error != OK: #OK: Enum for Value 0
		print("Error: " + str(error))
		return
	
	# global Network pointer
	multiplayer.multiplayer_peer = peer
	print("Server established by " + player_name + "! Waiting for friend ...")
	
	# Wait for client response (register callback)
	# if connection succeeds -> call func (_on_player_connected)
	multiplayer.peer_connected.connect(_on_player_connected)

# ---CLIENT LOGIC----------------------------------------------

func _on_join_game(address, player_name):
	var peer = ENetMultiplayerPeer.new()

	if address == "":
		address = "127.0.0.1" # Standard Localhost-IP (IPv4)
	
	peer.create_client(address, PORT)
	
	# Check if connection was built
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		print("Connection faltered!")
		return

	multiplayer.multiplayer_peer = peer
	print("Connecting" + player_name + "to server ...")

# ---CALLBACKS----------------------------------------------
func _on_player_connected(id):
	# id: unique player integer
	print("New player connected: " + str(id))
