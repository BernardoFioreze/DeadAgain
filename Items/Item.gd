class_name Item

extends Node


@export var id: String = ""
@export var name_item: String = ""
@export var texture: Texture2D
@export var max_stack: int = 1
# factor é o valor de dano/cura do item
@export var factor: int = 0
@export var description: String = ""
@export var consumable: bool = false
# id item que combina com esse item para formar outro
@export var merge_partner_id: String = ""
@export var merge_to_id: String = ""
