extends Node3D

@onready var gpuparticles3d = $GPUParticles3D

func _activate():
	print ("activated")
	gpuparticles3d.emitting = true
