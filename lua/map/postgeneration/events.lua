-- to reduce scenarios consuming resources, some very used utilities are defined as core events

#define WORLD_CONQUEST_TEK_MAP_POSTGENERATION_EVENTS
	{WCT_VOLCANOS_EVENT}
	{WCT_VOLCANOS_DIRT_EVENT}
	[event]
		name=prestart
		{WCT_SUFFLE_PLAYERS_KEEPS}
		{WCT_FIX_IMPASSIBLE_ITEM_SPAWN}
	[/event]
#enddef

#define WCT_SUFFLE_PLAYERS_KEEPS
	-- Fix [generator] glitch
	-- note: the current wc2_shuffle_locations implementation is
	-- based on starting locations so i currently used for shuffeling
	-- the ai sides because they are placed on different starting locations.
	[wc2_shuffle_locations]
		side=1,2,3
		[has_unit]
		[/has_unit]
	[/wc2_shuffle_locations]
#enddef

-- for items spawned by invest
function wct_fix_impassible_item_spawn()
	[terrain]
		terrain=Mm
		[and]
			terrain=*^X*,X*^*
			[filter_adjacent_location]
				[filter]
					side=1,2,3
					canrecruit=yes
				[/filter]
				adjacent=n
			[/filter_adjacent_location]
		[/and]
	[/terrain]
	[terrain]
		terrain=Ww
		[and]
			terrain=Wo
			[filter_adjacent_location]
				[filter]
					side=1,2,3
					canrecruit=yes
				[/filter]
				adjacent=n
			[/filter_adjacent_location]
		[/and]
	[/terrain]
	[terrain]
		terrain=Wwt
		[and]
			terrain=Wot
			[filter_adjacent_location]
				[filter]
					side=1,2,3
					canrecruit=yes
				[/filter]
				adjacent=n
			[/filter_adjacent_location]
		[/and]
	[/terrain]
	[terrain]
		terrain=Wwg
		[and]
			terrain=Wog
			[filter_adjacent_location]
				[filter]
					side=1,2,3
					canrecruit=yes
				[/filter]
				adjacent=n
			[/filter_adjacent_location]
		[/and]
	[/terrain]
end

#define WCT_FRACTION_LAYER_REPLACE FACTOR TERRAIN LAYER
	[wc2_terrain]
		[change]
			[filter]
				find_in=terrain_to_change
			[/filter]
			terrain="{TERRAIN}"
			fraction="{FACTOR}"
			layer="{LAYER}"
		[/change]
	[/wc2_terrain]
#enddef

#define WCT_FRACTION_REPLACE FACTOR TERRAIN
	[wc2_terrain]
		[change]
			[filter]
				find_in=terrain_to_change
			[/filter]
			terrain="{TERRAIN}"
			fraction="{FACTOR}"
		[/change]
	[/wc2_terrain]
#enddef

#define WCT_CHANCE_REPLACE CHANCE TERRAIN
	[wc2_terrain]
		[change]
			[filter]
				find_in=terrain_to_change
			[/filter]
			terrain="{TERRAIN}"
			percentage="{CHANCE}"
			strict=no
		[/change]
	[/wc2_terrain]
#enddef

#define WCT_TERRAIN_REPLACE TERRAIN
	[wc2_terrain]
		[change]
			[filter]
				find_in=terrain_to_change
			[/filter]
			terrain="{TERRAIN}"
		[/change]
	[/wc2_terrain]
#enddef

#define WCT_LAYER_REPLACE TERRAIN LAYER
	[wc2_terrain]
		[change]
			[filter]
				find_in=terrain_to_change
			[/filter]
			terrain="{TERRAIN}"
			layer="{LAYER}"
		[/change]
	[/wc2_terrain]
#enddef

function wct_volcanos()
	set_terrain { "Mv",
		f.all(
			f.terrain("Ql,Qlf"),
			f.adjacent(f.terrain("M*,M*^Xm,X*"), "se,s,sw", 3)
		),
	}
	set_terrain { "Md^Xm",
		f.all(
			f.terrain("X*,M*^Xm"),
			f.adjacent(f.terrain("Mv"), "n,ne,nw", nil)
		),
	}
	set_terrain { "Md",
		f.all(
			f.terrain("Ms,Mm"),
			f.adjacent(f.terrain("Mv"), "n,ne,nw", nil)
		),
	}
	local terrain_to_change = get_locations(f.terrain("Mv"))
	--todo figure out whether there is a differnce between many sound_source and on with a hige x,y list.
		{FOREACH terrain_to_change volcano_i}
			[sound_source]
				id=volcano$volcano_i
				sounds=rumble.ogg
				delay=550000
				chance=1
				x=$terrain_to_change[$volcano_i].x
				y=$terrain_to_change[$volcano_i].y
				full_range=5
				fade_range=5
				loop=0
			[/sound_source]
		{NEXT volcano_i}
end

function wct_volcanos_dirt()
	set_terrain { "*^Dr",
		f.all(
			f.terrain("Hh,Hd,Hhd"),
			f.radius(3, f.terrain("Mv"))
		),
		fraction = 3,
		layer = "overlay",
	}
	set_terrain { "Dd^Dc",
		f.all(
			f.terrain("Ds,Dd"),
			f.radius(4, f.terrain("Mv"))
		),
		fraction = 2,
	}
end

function wct_reduce_wall_clusters(cave_terrain)
set_terrain { cave_terrain,
	f.all(
		f.terrain("Xu"),
		f.adjacent(f.terrain("Xu,M*^Xm"), nil, "3-6")
	),
}

end

