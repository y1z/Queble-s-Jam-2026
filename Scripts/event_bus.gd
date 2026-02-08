extends Node
# class_name EventBus

signal clicked_on_target(data: clickedOnTargetData) ;


class clickedOnTargetData:
	var is_target: bool = false
	var the_node: Node = null
