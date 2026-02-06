class_name Debug extends RefCounted


static func d_print(...args: Array) -> void:
	if not OS.is_debug_build(): return
	print(args)


static func d_printerr(...args: Array) -> void:
	if not OS.is_debug_build(): return
	printerr(args)


static func d_print_rich(...args: Array) -> void:
	if not OS.is_debug_build(): return
	print_rich(args)


static func d_print_debug(... args: Array) -> void:
	if not OS.is_debug_build(): return
	print_debug(args)


static func d_print_verbose(... args: Array) -> void:
	if not OS.is_debug_build(): return
	print_verbose(args)
