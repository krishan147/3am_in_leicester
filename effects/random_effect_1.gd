extends Node3D

@onready var gpuparticles3d = $GPUParticles3D

func _activate():
	gpuparticles3d.emitting = true
