extends SpotLight

const MAX_ENERGY = 2.2
const MIN_ENERGY = 0.3

const MIN_TIME = 0.01
const MAX_TIME = 0.1

onready var energy_timer = $EnergyTimer

func _ready():
	randomize()
	energy_timer.connect("timeout", self, "on_energyTimer_timeout")
	energy_timer.wait_time = rand_range(MIN_TIME, MAX_TIME)
	energy_timer.start()

func on_energyTimer_timeout():
	energy_timer.wait_time = rand_range(MIN_TIME, MAX_TIME)
	self.light_energy = rand_range(MIN_ENERGY, MAX_ENERGY)
	energy_timer.start()