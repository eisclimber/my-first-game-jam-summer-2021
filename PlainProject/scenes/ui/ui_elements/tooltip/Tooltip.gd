extends Control

enum TooltipPlacement {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}

# Tooltip text
export(String) var text = "" setget set_text
# Where the tooltip shows up relative to the attached control
export(TooltipPlacement) var placement = TooltipPlacement.LEFT setget set_placement
# If true, the tooltip changes its placement if the given placement is not ideal because the tooltip would be out of the viewport
export(bool) var adaptive_position = false setget set_adaptive_position


# Margin of the tooltip to the parent control
const margin := 10


onready var arrowX 			:= $HBoxContainer/Control/ArrowX
onready var arrowY 			:= $HBoxContainer/VBoxContainer/Control/ArrowY
onready var label  			:= $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer/Label
onready var marginContainer := $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer

# Parent element to which the tooltip is attached to
var parent: Node

var opened := false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	self.opened = false;


# Tooltip size without margin if the given TooltipPlacement is applied
func tooltip_size(_placement) -> Vector2:
	var width = self.label.rect_size.x + self.marginContainer.get("custom_constants/margin_left") + self.marginContainer.get("custom_constants/margin_right")
	var height = self.label.rect_size.y + self.marginContainer.get("custom_constants/margin_top") + self.marginContainer.get("custom_constants/margin_bottom")
	
	if _placement == TooltipPlacement.LEFT || _placement == TooltipPlacement.RIGHT:
		width += self.arrowX.rect_size.x
	elif _placement == TooltipPlacement.TOP || _placement == TooltipPlacement.BOTTOM:
		height += self.arrowY.rect_size.y
		
	return Vector2(width, height)


func _show():
	self._set_tooltip_position()

	self.visible = true
	self.opened = true


func _hide():
	self.visible = false
	self.opened = false


func _set_tooltip_position():
	var position = {}
	match self.placement:
		TooltipPlacement.TOP:
			position = self._determine_best_position(
				[TooltipPlacement.TOP, TooltipPlacement.BOTTOM, TooltipPlacement.LEFT, TooltipPlacement.RIGHT]
			)
		TooltipPlacement.RIGHT:
			position = self._determine_best_position(
				[TooltipPlacement.RIGHT, TooltipPlacement.LEFT, TooltipPlacement.TOP, TooltipPlacement.BOTTOM]
			)
		TooltipPlacement.BOTTOM:
			position = self._determine_best_position(
				[TooltipPlacement.BOTTOM, TooltipPlacement.TOP, TooltipPlacement.LEFT, TooltipPlacement.RIGHT]
			)
		TooltipPlacement.LEFT:
			position = self._determine_best_position(
				[TooltipPlacement.LEFT, TooltipPlacement.RIGHT, TooltipPlacement.TOP, TooltipPlacement.BOTTOM]
			)
	
	self.set_global_position(position.position)
	self._set_tooltip_arrow(position.placement)


func _set_tooltip_arrow(_placement):
	match _placement:
		TooltipPlacement.TOP:
			self.arrowY.rect_rotation = 180.0
			$HBoxContainer/Control.rect_min_size = Vector2(0, 0)
			$HBoxContainer/VBoxContainer/Control.rect_min_size = Vector2(10, 10)
			$HBoxContainer/VBoxContainer.move_child($HBoxContainer/VBoxContainer/Control, 1)
			self.arrowX.visible = false
			self.arrowY.visible = true
		TooltipPlacement.RIGHT:
			self.arrowX.rect_rotation = 270.0
			$HBoxContainer/Control.rect_min_size = Vector2(10, 10)
			$HBoxContainer/VBoxContainer/Control.rect_min_size = Vector2(0, 0)
			$HBoxContainer.move_child($HBoxContainer/Control, 0)
			self.arrowX.visible = true
			self.arrowY.visible = false
		TooltipPlacement.BOTTOM:
			self.arrowY.rect_rotation = 0.0
			$HBoxContainer/Control.rect_min_size = Vector2(0, 0)
			$HBoxContainer/VBoxContainer/Control.rect_min_size = Vector2(10, 10)
			$HBoxContainer/VBoxContainer.move_child($HBoxContainer/VBoxContainer/Control, 0)
			self.arrowX.visible = false
			self.arrowY.visible = true
		TooltipPlacement.LEFT:
			self.arrowX.rect_rotation = 90.0
			$HBoxContainer/Control.rect_min_size = Vector2(10, 10)
			$HBoxContainer/VBoxContainer/Control.rect_min_size = Vector2(0, 0)
			$HBoxContainer.move_child($HBoxContainer/Control, 1)
			self.arrowX.visible = true
			self.arrowY.visible = false
	
	# Reset size so the size of the tooltip is recalculated
	self.rect_size = Vector2()



# Returns dictionary which contains the determined position and the placement
func _determine_best_position(placement_order: Array):
	var parent_position = self.parent.rect_global_position
	var parent_size = self.parent.rect_size
	var position = Vector2()
	
	for _placement in placement_order:
		var tooltip_size = self.tooltip_size(_placement)
		position = self._get_tooltip_position(_placement, tooltip_size, parent_position, parent_size)
		
		if (!self.adaptive_position || !self._tooltip_out_of_viewport(position, tooltip_size)):
			return {
				"position": position,
				"placement": _placement
			}
	
	# At this point we return the last calculated position, even if it's not ideal
	return {
		"position": position,
		"placement": placement_order[placement_order.size()]
	}


func _get_tooltip_position(_placement, tooltip_size: Vector2, parent_position: Vector2, parent_size: Vector2):
	match _placement:
		TooltipPlacement.TOP:
			return Vector2(
				parent_position.x + (parent_size.x / 2) - (tooltip_size.x / 2),
				parent_position.y - (tooltip_size.y + margin)
			)
		TooltipPlacement.RIGHT:
			return Vector2(
				parent_position.x + parent_size.x + self.margin,
				parent_position.y + (parent_size.y / 2) - (tooltip_size.y / 2)
			)
		TooltipPlacement.BOTTOM:
			return Vector2(
				parent_position.x + (parent_size.x / 2) - (tooltip_size.x / 2),
				parent_position.y + parent_size.y + margin
			)
		TooltipPlacement.LEFT:
			return Vector2(
				parent_position.x - (tooltip_size.x + self.margin),
				parent_position.y + (parent_size.y / 2) - (tooltip_size.y / 2)
			)


func _tooltip_out_of_viewport(tooltip_position: Vector2, tooltip_size: Vector2) -> bool:
	return tooltip_position.x < 0 \
		|| tooltip_position.x + tooltip_size.x > self.get_viewport().size.x \
		|| tooltip_position.y < 0 \
		|| tooltip_position.y + tooltip_size.y > self.get_viewport().size.y \


func _on_Tooltip_tree_entered():
	self.parent = self.get_parent()
	var error1 = self.parent.connect("mouse_entered", self, "_on_Parent_mouse_entered")
	var error2 = self.parent.connect("mouse_exited", self, "_on_Parent_mouse_exited")
	
	assert(error1 == OK && error2 == OK, "The node to which the tooltip was attached does not support tooltips")


func _on_Tooltip_tree_exited():
	if (self.parent == null):
		return
		
	if (self.parent.is_connected("mouse_entered", self, "_on_Parent_mouse_entered")):
		self.parent.disconnect("mouse_entered", self, "_on_Parent_mouse_entered")
	
	if (self.parent.is_connected("mouse_exited", self, "_on_Parent_mouse_entered")):
		self.parent.disconnect("mouse_exited", self, "_on_Parent_mouse_exited")


func _on_Parent_mouse_entered():
	self._show()


func _on_Parent_mouse_exited():
	self._hide()


func set_text(value: String):
	text = value
	$HBoxContainer/VBoxContainer/PanelContainer/MarginContainer/Label.text = tr(value)


func set_placement(value):
	placement = value


func set_adaptive_position(value: bool):
	adaptive_position = value
