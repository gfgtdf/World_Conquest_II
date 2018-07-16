#define WORLD_CONQUEST_TEK_MAP_BONUS_POINTS_EVENTS
	{WORLD_CONQUEST_TEK_MAP_GENERATE_BONUS_POINTS}
#enddef

#define WORLD_CONQUEST_TEK_BONUS_POINTS
	[fire_event]
		name=wct_map_generate_points
	[/fire_event]
#enddef

#define WORLD_CONQUEST_TEK_MAP_GENERATE_BONUS_POINTS
	[event]
		name=wct_map_generate_points
		[store_map_dimensions]
			variable=point.limit
		[/store_map_dimensions]
		[random_placement]
			num_items=$players
			variable=point.location
			min_distance="$(9+$scenario)"
			[filter_location]
				{WCT_BONUS_LOCATION_FILTER}
			[/filter_location]
			[command]
				{WCT_BONUS_CHOSE_SCENERY}
				{WCT_PLACE_BONUS}
			[/command]
		[/random_placement]
		{CLEAR_VARIABLE point}
	[/event]
#enddef

#define WCT_BONUS_LOCATION_FILTER
		terrain= G*,Hh,Uu,Uh,Dd,Ds,R*,Mm,Md,Ss,Hd,Hhd,Ww,Wwt,Wwg,Ds^Esd,Ur
		## no adjacent to village, deep water, chasm or walls
		[filter_adjacent_location]
			terrain=Wo*,M*^Xm,Xu*,Q*,Mv,*^V*
			count=0
		[/filter_adjacent_location]
		[and]
			## no out/at map borders
			[not]
				x=0,1,$point.limit.width,"$($point.limit.width+1)"
			[/not]
			[not]
				y=0,1,$point.limit.height,"$($point.limit.height+1)"
			[/not]
			## not too close to a keep
			[not]
				terrain=K*^*
				radius="$(4+$scenario)"
			[/not]
			## not too close to other bonus
			[not]
				find_in=bonus.point
				radius="$(9+$scenario)"
			[/not]
			## just isolated mountains
			[not]
				terrain=M*
				[filter_adjacent_location]
					terrain=M*
				[/filter_adjacent_location]
			[/not]
			## no swamps near sand or water
			[not]
				terrain=Ss
				[filter_adjacent_location]
					terrain=Wo*,Ww,Wwg,Wwt,Ds,Ds^Esd
				[/filter_adjacent_location]
			[/not]
			## no river/lake water next to 2 coast, bridge or frozen
			## (it means restrict lilies image)
			[not]
				terrain=Ww*
				[and]
					[filter_adjacent_location]
						terrain=Ha^*,A*^*,Ms^*,*^B*,C*
					[/filter_adjacent_location]
					[filter_adjacent_location]
						terrain=W*^*
						count=0-3
					[/filter_adjacent_location]
					[or]
						[filter_adjacent_location]
							terrain=W*^*
							count=4
						[/filter_adjacent_location]
					[/or]
				[/and]
				[and]
					[not]
						{WCT_MAP_FILTER_OCEANIC}
					[/not]
				[/and]
			[/not]
		[/and]

#enddef

#define ADD_SCENERY SCENERY
	{VARIABLE point.scenery "{SCENERY},$point.scenery"}
#enddef

#define WCT_BONUS_CHOSE_SCENERY
	## determine possible scenery values based on terrain
	[switch]
		variable=point.location.terrain
		[case]
			value=Re,Rd,Rb,Rr,Rrc
			{VARIABLE point.scenery "well_r,signpost,rock_cairn,obelisk,dolmen,monolith2,temple2,shop"}
		[/case]
		[case]
			value=Ww,Wwt,Wwg
			{VARIABLE point.scenery "ship1,ship2"}
		[/case]
		[case]
			value=Hh,Hhd
			{VARIABLE point.scenery "temple,shelter,village,monolith1,monolith4"}
		[/case]
		[case]
			value=Mm,Md
			{VARIABLE point.scenery "mine,mine,mine,mine,mine,mine,doors,doors,doors,doors,doors,doors,temple3,temple4"}
		[/case]
		[case]
			value=Uu
			{VARIABLE point.scenery "altar,coffin,bones,rock_cairn_c,trapdoor,crystal,monolith2"}
		[/case]
		[case]
			value=Ur
			{VARIABLE point.scenery "altar,bones,rock_cairn_c,well,monolith2,monolith3,tent1"}
		[/case]
		[case]
			value=Uh
			{VARIABLE point.scenery "altar,coffin,bones,rock_cairn_c,trapdoor,monolith2,crystal3,burial_c"}
		[/case]
		[case]
			value=Ds,Ds^Esd,Dd
			{VARIABLE point.scenery "rock1,rock4,bones,tent2,tent1,burial_s"}
		[/case]
		[case]
			value=Hd
			{VARIABLE point.scenery "tower_r1,tower_r4,bones,tent2,tent1,rock1,rock4"}
		[/case]
		[case]
			value=Ss
			{VARIABLE point.scenery "bones_s,rock3,rock3,burial,lilies,bones_s"}
		[/case]
		[else]
			{VARIABLE point.scenery "well_g,temple,tent2_g,tent1,village,monolith3,burial"}
		[/else]
	[/switch]
	## chance of rock cairn on isolated hills
	[if]
		[have_location]
			terrain=Hh,Hhd
			find_in=point.location
			[filter_adjacent_location]
				terrain=H*^*
				count=0
			[/filter_adjacent_location]
		[/have_location]
		[then]
			{ADD_SCENERY rock_cairn}
		[/then]
	[/if]
	## chance of dolmen on grass not next to forest
	[if]
		[have_location]
			terrain=G*
			find_in=point.location
			[filter_adjacent_location]
				terrain=*^F*
				count=0
			[/filter_adjacent_location]
		[/have_location]
		[then]
			{ADD_SCENERY dolmen_g}
		[/then]
	[/if]
	## chances of green temple on gras next to swamp, hills and forest
	[if]
		[have_location]
			terrain=G*
			find_in=point.location
			[filter_adjacent_location]
				terrain=Ss
			[/filter_adjacent_location]
			[filter_adjacent_location]
				terrain=Hh^*,Ha^*
			[/filter_adjacent_location]
			[filter_adjacent_location]
				terrain=G*^F*,A*^F*,G*^Uf
			[/filter_adjacent_location]
		[/have_location]
		[then]
			{ADD_SCENERY temple_green_g,temple_green_g,temple_green_g,temple_green_g2,temple_green_g2}
		[/then]
	[/if]
	## chances of green temple in hills next to swamp or cold
	[if]
		[have_location]
			terrain=Hh
			find_in=point.location
			[filter_adjacent_location]
				terrain=Ss,Ai,A*^*,Ha^*,Ms^*
			[/filter_adjacent_location]
		[/have_location]
		[then]
			{ADD_SCENERY temple_green_h,temple_green_h,temple_green_h,temple_green_h2,temple_green_h2}
		[/then]
	[/if]
	## chance of temple in hills next to mountain
	[if]
		[have_location]
			terrain=Hh,Hhd
			find_in=point.location
			[filter_adjacent_location]
				terrain=M*^*
			[/filter_adjacent_location]
		[/have_location]
		[then]
			{ADD_SCENERY temple4,temple4}
		[/then]
	[/if]
	## chances of detritus and lilies on some swamps
	[if]
		[have_location]
			terrain=Ss
			find_in=point.location
			[filter_adjacent_location]
				terrain=*^F*,C*^*,K*^*
				count=0
			[/filter_adjacent_location]
		[/have_location]
		[then]
			{ADD_SCENERY detritus,detritus2,lilies_s}
		[/then]
	[/if]
	## chances of buildings next to road
	[if]
		[variable]
			name=bonus.theme
			not_equals=volcanic
		[/variable]
		[variable]
			name=bonus.theme
			not_equals=clayey
		[/variable]
		[variable]
			name=bonus.theme
			not_equals=wild
		[/variable]
		[have_location]
			terrain=G*,Hh*
			find_in=point.location
			[filter_adjacent_location]
				terrain=R*^*,W*^Bsb*
				count=2-6
			[/filter_adjacent_location]
			[filter_adjacent_location]
				terrain=*^F*
				count=0
			[/filter_adjacent_location]
			[and]
				terrain=*^Vh,*^Vhh,*^Ve,*^Vl,*^Vhc,*^Vd,*^Vy*,*^Vz*
				radius=7
			[/and]
		[/have_location]
		[then]
			{ADD_SCENERY rock_cairn,temple2_g,shop_g}
		[/then]
	[/if]
	## chance of fancy shop on road
	[if]
		[variable]
			name=bonus.theme
			not_equals=volcanic
		[/variable]
		[variable]
			name=bonus.theme
			not_equals=clayey
		[/variable]
		[variable]
			name=bonus.theme
			not_equals=wild
		[/variable]
		[have_location]
			terrain=R*^*
			find_in=point.location
			[and]
				terrain=*^Vh,*^Vhh,*^Ve,*^Vl,*^Vhc,*^Vd,*^Vy*,*^Vz*
				radius=5
			[/and]
		[/have_location]
		[then]
			{ADD_SCENERY tent2_r}
		[/then]
	[/if]
	## high chances of windmill and oak surronded by flat
	[if]
		[have_location]
			terrain=Gg,Gs,Gll
			find_in=point.location
			[filter_adjacent_location]
				terrain= G*,R*,R*^Em,G*^Efm,Wwf,G*^Em,G*^Eff,*^Gvs,W*^B*,Ce,Ch
				count=6
			[/filter_adjacent_location]
		[/have_location]
		[then]
			{ADD_SCENERY windmill,windmill,windmill,windmill,windmill,windmill,windmill,oak1,oak2,oak3,oak4,oak5,oak6,oak7}
		[/then]
	[/if]
	## remove chances of ships on river/lake coast for lilies
	[if]
		[have_location]
			terrain=Ww,Wwt,Wwg
			find_in=point.location
			[not]
				{WCT_MAP_FILTER_OCEANIC}
			[/not]
			[filter_adjacent_location]
				terrain=W*^*
				count=0-3
			[/filter_adjacent_location]
		[/have_location]
		[then]
			{VARIABLE point.scenery "lilies"}
		[/then]
	[/if]
	## different meaning for roads in some maps
	[if]
		[variable]
			name=bonus.theme
			equals=clayey
		[/variable]
		[or]
			[variable]
				name=bonus.theme
				equals=wild
			[/variable]
		[/or]
		[then]
			[if]
				[have_location]
					terrain=R*
					find_in=point.location
				[/have_location]
				[then]
					{VARIABLE point.scenery "well_g,temple,tent2_g,tent1,village,monolith3,burial"}
				[/then]
			[/if]
		[/then]
	[/if]
	[if]
		[variable]
			name=bonus.theme
			equals=wild
		[/variable]
		[then]
			[if]
				[have_location]
					find_in=point.location
					[and]
						find_in=map_data.road_in_cave
					[/and]
				[/have_location]
				[then]
					{VARIABLE point.scenery "altar,bones,rock_cairn,well,monolith2,monolith3,tent1"}
				[/then]
			[/if]
		[/then]
	[/if]
	[if]
		[variable]
			name=bonus.theme
			equals=volcanic
		[/variable]
		[then]
			[if]
				[have_location]
					terrain=Rd,Rb
					find_in=point.location
				[/have_location]
				[then]
					{VARIABLE point.scenery "bones,rock_cairn,well_g,monolith2,tent1,tent1,tent2,tent2_g,monolith3,well_g,rock_cairn,dolmen,monolith2,temple,dolmen_g,monolith1_r,monolith4_r"}
				[/then]
			[/if]
			[if]
				[have_location]
					terrain=Ur
					find_in=point.location
				[/have_location]
				[then]
					{VARIABLE point.scenery "bones,rock_cairn,well_g,monolith2,tent1,monolith3,well_g,dolmen,monolith2,temple,monolith1_r,monolith4_r"}
				[/then]
			[/if]
		[/then]
	[/if]
	## high chances of lighthouse next to ocean
	[if]
		[have_location]
			terrain=Ww*
			[filter_adjacent_location]
				find_in=point.location
				terrain=!,Ww*,U*,Ss
			[/filter_adjacent_location]
			[and]
				{WCT_MAP_FILTER_OCEANIC}
			[/and]
		[/have_location]
		[then]
			{ADD_SCENERY lighthouse,lighthouse,lighthouse,lighthouse,lighthouse}
			[if]
				[have_location]
					find_in=point.location
					terrain=G*^*,R*^*
				[/have_location]
				[then]
					{ADD_SCENERY lighthouse,lighthouse}
				[/then]
			[/if]
			## high chances of light signal on cliff next to ocean
			[if]
				[have_location]
					find_in=point.location
					terrain=Hh,Hhd,Mm,Md
				[/have_location]
				[then]
					{ADD_SCENERY campfire,campfire,campfire,campfire,lighthouse,lighthouse,lighthouse,lighthouse}
					[if]
						[have_location]
							find_in=point.location
							terrain=Mm,Md
						[/have_location]
						[then]
							{ADD_SCENERY campfire,campfire,campfire,campfire,lighthouse,lighthouse,lighthouse,lighthouse}
						[/then]
					[/if]
				[/then]
			[/if]
		[/then]
	[/if]
	## chances of tower on dessert far from village
	[if]
		[have_location]
			terrain=Dd,Hd
			find_in=point.location
			[and]
				[not]
					terrain=*^V*
					radius=5
				[/not]
			[/and]
		[/have_location]
		[then]
			{ADD_SCENERY tower_r1,tower_r4}
		[/then]
	[/if]
	## chance of outpost in sands
	[if]
		[have_location]
			terrain=Ds,Hd,Dd
			find_in=point.location
			[filter_adjacent_location]
				terrain=D*^*,Hd,G*,R*,Ur
				adjacent=se
				count=1
			[/filter_adjacent_location]
			[filter_adjacent_location]
				terrain=D*^*,H*^*,G*^*,R*,Ur,M*^*
				adjacent=nw,sw,n,s,ne
				count=5
			[/filter_adjacent_location]
			[filter_adjacent_location]
				terrain=D*^*,Hd*^*
				count=1-6
			[/filter_adjacent_location]
		[/have_location]
		[then]
			{ADD_SCENERY outpost,outpost}
		[/then]
	[/if]
	## chances of dead oak in desolated
	[if]
		[have_location]
			terrain=Dd
			find_in=point.location
			[filter_adjacent_location]
				terrain=Dd,Ds*^*,Hd,S*
				count=4-6
			[/filter_adjacent_location]
			[filter_adjacent_location]
				terrain=*^F*,C*^*,K*^*
				count=0
			[/filter_adjacent_location]
			[or]
				terrain=Ds,Rd
				find_in=point.location
				[filter_adjacent_location]
					terrain=Dd,Ds*^*,Hd,S*,Rd
					count=6
				[/filter_adjacent_location]
				[and]
					[not]
						terrain=W*^*
						radius=2
					[/not]
				[/and]
			[/or]
		[/have_location]
		[then]
			{ADD_SCENERY oak_dead,oak_dead,oak_dead,oak_dead,oak_dead2,oak_dead2,oak_dead2,oak_dead2}
		[/then]
	[/if]
	## pick random scenery value from our list
	{VARIABLE_OP point.scenery rand $point.scenery}
#enddef

#define WCT_PLACE_BONUS
	[wc2_place_bonus]
		x,y=$point.location.x,$point.location.y
		scenery = $point.scenery
	[/wc2_place_bonus]
#enddef
