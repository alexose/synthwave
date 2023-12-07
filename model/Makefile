.PHONY: all base base_no_lid electrode_holder pump_bracket container_cover top_shelf

all: base base_no_lid electrode_holder pump_bracket container_cover top_shelf

base:
	openscad synthwave.scad -D render_base=1 -D render_base_no_lid=0 -D render_electrode_holder=0 -D render_pump_bracket=0 -D render_container_cover=0 -D render_top_shelf=0 -o base.stl --enable=fast-csg

base_no_lid:
	openscad synthwave.scad -D render_base=0 -D render_base_no_lid=1 -D render_electrode_holder=0 -D render_pump_bracket=0 -D render_container_cover=0 -D render_top_shelf=0 -o base.stl --enable=fast-csg

electrode_holder:
	openscad synthwave.scad -D render_base=0 -D render_base_no_lid=0 -D render_electrode_holder=1 -D render_pump_bracket=0 -D render_container_cover=0 -D render_top_shelf=0 -o electrode_holder.stl --enable=fast-csg

pump_bracket:
	openscad synthwave.scad -D render_base=0 -D render_base_no_lid=0 -D render_electrode_holder=0 -D render_pump_bracket=1 -D render_container_cover=0 -D render_top_shelf=0 -o pump_bracket.stl --enable=fast-csg

container_cover:
	openscad synthwave.scad -D render_base=0 -D render_base_no_lid=0 -D render_electrode_holder=0 -D render_pump_bracket=0 -D render_container_cover=1 -D render_top_shelf=0 -o container_cover.stl --enable=fast-csg

top_shelf:
	openscad synthwave.scad -D render_base=0 -D render_base_no_lid=0 -D render_electrode_holder=0 -D render_pump_bracket=0 -D render_container_cover=0 -D render_top_shelf=1 -o top_shelf.stl --enable=fast-csg
