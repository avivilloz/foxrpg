extends Control

var max_health = 1 setget set_max_health
var health = max_health setget set_health

onready var healthEmpty = $HealthEmpty
onready var healthFull = $HealthFull

func set_max_health(value):
	max_health = max(value, 1)
	healthEmpty.rect_size.x = max_health * 15

func set_health(value):
	health = clamp(value, 0, max_health)
	healthFull.rect_size.x = health * 15

func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	healthEmpty.rect_size.y = 11
	healthFull.rect_size.y = 11
	PlayerStats.connect("health_changed", self, "set_health")
	PlayerStats.connect("max_health_changed", self, "set_max_health")