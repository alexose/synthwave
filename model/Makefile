.PHONY: all base electode_holder breadboard_cover pump_bracket container_cover strain_relief

all: base electode_holder breadboard_cover pump_bracket container_cover strain_relief

base:
	openscad synthwave.scad -D render_base=1 -D render_electrode_holder=0 -D render_breadboard_cover=0 -D render_pump_bracket=0 -D render_container_cover=0 -D render_strain_relief=0 -o base.stl --enable=fast-csg

electrode_holder:
	openscad synthwave.scad -D render_base=0 -D render_electrode_holder=1 -D render_breadboard_cover=0 -D render_pump_bracket=0 -D render_container_cover=0 -D render_strain_relief=0 -o electrode_holder.stl --enable=fast-csg

breadboard_cover:
	openscad synthwave.scad -D render_base=0 -D render_electrode_holder=0 -D render_breadboard_cover=1 -D render_pump_bracket=0 -D render_container_cover=0 -D render_strain_relief=0 -o breadboard_cover.stl --enable=fast-csg

pump_bracket:
	openscad synthwave.scad -D render_base=0 -D render_electrode_holder=0 -D render_breadboard_cover=0 -D render_pump_bracket=1 -D render_container_cover=0 -D render_strain_relief=0 -o pump_bracket.stl --enable=fast-csg

container_cover:
	openscad synthwave.scad -D render_base=0 -D render_electrode_holder=0 -D render_breadboard_cover=0 -D render_pump_bracket=0 -D render_container_cover=1 -D render_strain_relief=0 -o container_cover.stl --enable=fast-csg

strain_relief:
	openscad synthwave.scad -D render_base=0 -D render_electrode_holder=0 -D render_breadboard_cover=0 -D render_pump_bracket=0 -D render_container_cover=0 -D render_strain_relief=1 -o strain_relief.stl --enable=fast-csg

