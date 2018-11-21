function world_conquest_tek_map_postgeneration_4f()
	[event]
		name=prestart
		{WORLD_CONQUEST_TEK_ENEMY_ARMY_EVENT}
		{WORLD_CONQUEST_TEK_MAP_REPAINT_4F}
		{WILD_STORE_ROADS_IN_CAVE_ZONE}
		-- WORLD_CONQUEST_TEK_BONUS_POINTS uses map_data.road_in_cave
		world_conquest_tek_bonus_points("wild")
		
	[/event]
end

function world_conquest_tek_map_repaint_4f()
		{WILD_ZONES_DEFINITIONS}

	-- store and remove villages
	[store_locations]
		terrain=*^Vh
		variable=map_data.villages
	[/store_locations]
	[terrain]
		terrain=*
		layer=overlay
		[and]
			terrain=*^Vh
		[/and]
	[/terrain]

	wild_store_cave_zone()

	wild_zones_store()

	-- fix ocean water, add reefs
	[wc2_terrain]
		[change]
			[filter]
				terrain=Wog
				[filter_adjacent_location]
					terrain=!,Wog
				[/filter_adjacent_location]
				[filter_adjacent_location]
					terrain=W*^V*
					count=0
				[/filter_adjacent_location]
			[/filter]
			terrain="Wwrg"
			percentage="5"
			exact=no
		[/change]
	[/wc2_terrain]
if wesnoth.random(4) == 1 then
			[terrain]
				terrain=Ww
				layer=base
				[and]
					terrain=Wwg^*
				[/and]
			[/terrain]
			[terrain]
				terrain=Wwr
				[and]
					terrain=Wwrg
				[/and]
			[/terrain]
			[terrain]
				terrain=Wo
				[and]
					terrain=Wog
				[/and]
			[/terrain]
	end

	{WILD_ZONES_REPLACE}

	-- remove roads
	[terrain]
		terrain=Ur
		[and]
			terrain=Rr,Rrc
			[filter_adjacent_location]
				terrain=U*^*,Q*^*
				count=2-6
			[/filter_adjacent_location]
		[/and]
	[/terrain]
	[terrain]
		terrain=Gg
		[and]
			terrain=Rrc
		[/and]
	[/terrain]
	[terrain]
		terrain=Gs
		[and]
			terrain=Rr
		[/and]
	[/terrain]
	-- cave walls
	[terrain]
		terrain=Xu
		[and]
			terrain=*^Xm
		[/and]
		[filter_adjacent_location]
			terrain=U*^*,Q*^*,X*
			count=3-6
		[/filter_adjacent_location]
	[/terrain]
	[wc2_terrain]
		[change]
			[filter]
				terrain=*^Xm
				[filter_adjacent_location]
					terrain=U*^*,Q*^*,X*
					count=2
				[/filter_adjacent_location]
			[/filter]
			terrain="Xu"
			percentage="50"
			exact=no
		[/change]
	[/wc2_terrain]
	[wc2_terrain]
		[change]
			[filter]
				terrain=Uu,Uh,Uu^Uf,Uh^Uf
				[filter_adjacent_location]
					terrain=G*^*,H*^*
				[/filter_adjacent_location]
				[filter_adjacent_location]
					terrain=*^Xm
					count=0
				[/filter_adjacent_location]
			[/filter]
			terrain="Xu"
			percentage="50"
			exact=no
		[/change]
	[/wc2_terrain]
	-- wood castles
	[terrain]
		terrain=Ce
		[and]
			terrain=Ch
		[/and]
	[/terrain]

	wct_fill_lava_chasms()
	wct_volcanos()
	wct_volcanos_dirt()

	-- restore villages
	[terrain]
		terrain=*^Vo
		layer=overlay
		find_in=map_data.villages
		[not]
			terrain=Mv
		[/not]
	[/terrain]
	[terrain]
		terrain=*^Voa
		layer=overlay
		[and]
			terrain=A*^Vo,Ha^Vo,Ms^Vo
		[/and]
	[/terrain]
	[terrain]
		terrain=Uh^Vud
		[and]
			terrain=Uh^Vo
		[/and]
	[/terrain]
	[terrain]
		terrain=*^Vhs
		layer=overlay
		[and]
			terrain=S*^Vo
		[/and]
	[/terrain]
	[terrain]
		terrain=Ur^Vu
		[and]
			terrain=Q*^Vo,X*^Vo
		[/and]
	[/terrain]
	[terrain]
		terrain=*^Vd
		layer=overlay
		[and]
			terrain=Dd^Vo,Hd^Vo,Hhd^Vo,Md^Vo
		[/and]
	[/terrain]
	[terrain]
		terrain=*^Ve
		layer=overlay
		[and]
			terrain=Gg^Vo,Hh^Vo
			[filter_adjacent_location]
				terrain=*^F*
				count=2-6
			[/filter_adjacent_location]
		[/and]
		[or]
			terrain=Gll^V*
			[filter_adjacent_location]
				terrain=Gll^Uf
			[/filter_adjacent_location]
		[/or]
	[/terrain]
	[terrain]
		terrain=Wwf^Vht
		[and]
			terrain=Wwf^Vo
		[/and]
		[filter_adjacent_location]
			terrain=A*^*,Ha^*,Ms^*
			count=0
		[/filter_adjacent_location]
	[/terrain]
	[terrain]
		terrain=Ss^Vhs
		[and]
			terrain=Wwf^Vo
		[/and]
	[/terrain]
	[terrain]
		terrain=Ww^Vm
		[and]
			terrain=W*^Vo
		[/and]
	[/terrain]
	[wc2_terrain]
		[change]
			[filter]
				terrain=Gs^Vo,Ds^Vo
			[/filter]
			terrain="*^Vo,*^Vd,*^Vc,*^Vct"
			fraction="1"
			layer="overlay"
		[/change]
	[/wc2_terrain]
	[wc2_terrain]
		[change]
			[filter]
				terrain=Uu^Vo
			[/filter]
			terrain="Uu^Vo,Uu^Vu,Uu^Vud,Uu^Vud,Uu^Vud"
		[/change]
	[/wc2_terrain]
	[wc2_terrain]
		[change]
			[filter]
				terrain=Mm^Vo
			[/filter]
			terrain="Mm^Vo,Mm^Vu,Mm^Vd"
		[/change]
	[/wc2_terrain]
	[wc2_terrain]
		[change]
			[filter]
				terrain=Hh^Vo
				[filter_adjacent_location]
					terrain=D*^*,Gs^*,Md^*
				[/filter_adjacent_location]
			[/filter]
			terrain="Hh^Vo,Hh^Vd"
		[/change]
	[/wc2_terrain]
end

function wild_zones_definitions()
	[set_variables]
		name=map_data
		[literal]
			[height]
				[temperature]
					terrain=Wwrg
					{WILD_REPLACEMENT_CHANCES_ZONE_1_1}
				[/temperature]
				[temperature]
					terrain=Wwr
					{WILD_REPLACEMENT_CHANCES_ZONE_1_2}
				[/temperature]
				[temperature]
					terrain=Wwrt
					{WILD_REPLACEMENT_CHANCES_ZONE_1_3}
				[/temperature]
				[temperature]
					terrain=Ds
					{WILD_REPLACEMENT_CHANCES_ZONE_1_4}
				[/temperature]
			[/height]
			[height]
				[temperature]
					terrain=Gll
					{WILD_REPLACEMENT_CHANCES_ZONE_2_1}
				[/temperature]
				[temperature]
					terrain=Gg
					{WILD_REPLACEMENT_CHANCES_ZONE_2_2}
				[/temperature]
				[temperature]
					terrain=Gs
					{WILD_REPLACEMENT_CHANCES_ZONE_2_3}
				[/temperature]
				[temperature]
					terrain=Gd
					{WILD_REPLACEMENT_CHANCES_ZONE_2_4}
				[/temperature]
			[/height]
			[height]
				[temperature]
					terrain=Aa
					{WILD_REPLACEMENT_CHANCES_ZONE_3_1}
				[/temperature]
				[temperature]
					terrain=Ss
					{WILD_REPLACEMENT_CHANCES_ZONE_3_2}
				[/temperature]
				[temperature]
					terrain=Sm
					{WILD_REPLACEMENT_CHANCES_ZONE_3_3}
				[/temperature]
				[temperature]
					terrain=Dd
					{WILD_REPLACEMENT_CHANCES_ZONE_3_4}
				[/temperature]
			[/height]
			[height]
				[temperature]
					terrain=Ha
					{WILD_REPLACEMENT_CHANCES_ZONE_4_1}
				[/temperature]
				[temperature]
					terrain=Hh
					{WILD_REPLACEMENT_CHANCES_ZONE_4_2}
				[/temperature]
				[temperature]
					terrain=Hhd
					{WILD_REPLACEMENT_CHANCES_ZONE_4_3}
				[/temperature]
				[temperature]
					terrain=Hd
					{WILD_REPLACEMENT_CHANCES_ZONE_4_4}
				[/temperature]
			[/height]
			[height]
				[temperature]
					terrain=Ms
					{WILD_REPLACEMENT_CHANCES_ZONE_5_1}
				[/temperature]
				[temperature]
					terrain=Mm
					{WILD_REPLACEMENT_CHANCES_ZONE_5_2}
				[/temperature]
				[temperature]
					terrain=Md
					{WILD_REPLACEMENT_CHANCES_ZONE_5_3}
				[/temperature]
				[temperature]
					terrain=Mv
					{WILD_REPLACEMENT_CHANCES_ZONE_5_4}
				[/temperature]
			[/height]
			[height]
				[temperature]
					terrain=Ms^Xm
					{WILD_REPLACEMENT_CHANCES_ZONE_6_1}
				[/temperature]
				[temperature]
					terrain=Mm^Xm
					{WILD_REPLACEMENT_CHANCES_ZONE_6_2}
				[/temperature]
				[temperature]
					terrain=Md^Xm
					{WILD_REPLACEMENT_CHANCES_ZONE_6_3}
				[/temperature]
				[temperature]
					terrain=Md^Dr
					{WILD_REPLACEMENT_CHANCES_ZONE_6_4}
				[/temperature]
			[/height]
			[height]
				[temperature]
					terrain=Xu
					{WILD_REPLACEMENT_CHANCES_ZONE_7_1}
				[/temperature]
				[temperature]
					terrain=Xuc
					{WILD_REPLACEMENT_CHANCES_ZONE_7_2}
				[/temperature]
				[temperature]
					terrain=Xue
					{WILD_REPLACEMENT_CHANCES_ZONE_7_3}
				[/temperature]
				[temperature]
					terrain=Xuce
					{WILD_REPLACEMENT_CHANCES_ZONE_7_4}
				[/temperature]
			[/height]
			[height]
				[temperature]
					terrain=Ww,Wwf
					{WILD_REPLACEMENT_CHANCES_ZONE_8_1}
				[/temperature]
			[/height]
		[/literal]
	[/set_variables]
end

function wild_zones_store()
	{FOREACH map_data.height height_i}
		{FOREACH map_data.height[$height_i].temperature temp_i}
			[store_locations]
				terrain=$map_data.height[$height_i].temperature[$temp_i].terrain
				variable=terrain_to_change
			[/store_locations]
			[set_variables]
				name=map_data.height[$height_i].temperature[$temp_i].regions
				to_variable=terrain_to_change
			[/set_variables]
			-- split terrain_to_change into connected components.
			{VARIABLE zone_i 0}
			[while]
				[variable]
					name=terrain_to_change.length
					greater_than=0
				[/variable]
				[do]
					[store_locations]
						terrain=$map_data.height[$height_i].temperature[$temp_i].terrain
						[and]
							x=$terrain_to_change.x
							y=$terrain_to_change.y
							radius=999
							[filter_radius]
								terrain=$map_data.height[$height_i].temperature[$temp_i].terrain
							[/filter_radius]
						[/and]
						variable=map_data.height[$height_i].temperature[$temp_i].zone[$zone_i].loc
					[/store_locations]
					[store_locations]
						find_in=terrain_to_change
						[not]
							find_in=map_data.height[$height_i].temperature[$temp_i].zone[$zone_i].loc
						[/not]
						variable=terrain_to_change
					[/store_locations]
					{VARIABLE_OP zone_i add 1}
				[/do]
			[/while]
			{CLEAR_VARIABLE zone_i}
		{NEXT temp_i}
	{NEXT height_i}
end

function wild_zones_replace()
	{FOREACH map_data.height height_i}
		{FOREACH map_data.height[$height_i].temperature temp_i}
			-- even when it may become redundant, it speeds filtering doing first a replacement for whole zone
			-- warning: map generation becomes quite slow if alternative chances for microzones have high frecuency
			[set_variables]
				name=terrain_to_change
				to_variable=map_data.height[$height_i].temperature[$temp_i].regions
			[/set_variables]
			[insert_tag]
				name=command
				variable=map_data.height[$height_i].temperature[$temp_i].default
			[/insert_tag]
			{FOREACH map_data.height[$height_i].temperature[$temp_i].zone zone_i}
				[set_variables]
					name=terrain_to_change
					to_variable=map_data.height[$height_i].temperature[$temp_i].zone[$zone_i].loc
				[/set_variables]
				{VARIABLE_OP wild_dice rand 0..99}
				#{VARIABLE wild_dice 99} --test default
				{FOREACH map_data.height[$height_i].temperature[$temp_i].chance chance_i}
					[if]
						[variable]
							name=wild_dice
							less_than=$map_data.height[$height_i].temperature[$temp_i].chance[$chance_i].value
						[/variable]
						[then]
							[insert_tag]
								name=command
								variable=map_data.height[$height_i].temperature[$temp_i].chance[$chance_i].command
							[/insert_tag]
							{VARIABLE chance_i 100}--exit loop
						[/then]
						[else]
							{VARIABLE_OP wild_dice sub $map_data.height[$height_i].temperature[$temp_i].chance[$chance_i].value}
						[/else]
					[/if]
				{NEXT chance_i}
			{NEXT zone_i}
		{NEXT temp_i}
	{NEXT height_i}
	{CLEAR_VARIABLE wild_dice}
end

function wild_replacement_chances_zone_1_1()
	[default]
		{WCT_TERRAIN_REPLACE Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds^Es}
	[/default]
	[chance]
		value=4
		[command]
			{WCT_TERRAIN_REPLACE Wwf,Ai,Ai,Aa,Aa,Aa,Ha,Ha,Ms,Ha,Ha,Ms}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Wwf,Wwf,Ds}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Wwg,Ds}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Wwg,Wwrg,Wwrg,Ds,Ds}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_1_2()
	[default]
		{WCT_TERRAIN_REPLACE Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds^Esd}
	[/default]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ds,Ss}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Wwf,Ds}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Wwrg
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Wwg,Wwrg,Wwrg,Ds,Ds,Wwrg,Wwrg,Ds,Ds,Wwf}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Gg,Gg,Gg,Gg,Gg^Fds,Hh,Hh^Fds,Mm}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_1_3()
	[default]
		{WCT_TERRAIN_REPLACE Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds^Esd}
	[/default]
	[chance]
		value=2
		[command]
			{WCT_TERRAIN_REPLACE Ds,Ss}
		[/command]
	[/chance]
	[chance]
		value=2
		[command]
			{WCT_TERRAIN_REPLACE Ds^Esd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Do}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Wwr
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_1_4()
	[default]
		{WCT_TERRAIN_REPLACE Ds^Esd,Ds}
	[/default]
	[chance]
		value=9
		[command]
			{WCT_TERRAIN_REPLACE Dd^Esd,Dd}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Uue^Esd,Uue,Uue,Uue^Es}
			{WILD_VOLCANO_FOR_LAVA_ZONE}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ds,Sm}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Dd,Dd,Dd,Dd^Esd,Hd,Hd,Md}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ds,Ds,Ds,Ds,Ds,Ds^Esd,Ds^Ftd,Ds^Do,Hhd}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ds^Esd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Do}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_2_1()
	[default]
		[terrain]
			terrain=Gg
			find_in=terrain_to_change
		[/terrain]
		{WCT_CHANCE_REPLACE 20 Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Gg^Fmf}
	[/default]
	[chance]
		value=8
		[command]
			{WCT_TERRAIN_REPLACE Aa,Aa,Aa,Aa,Aa,Aa,Aa,Aa,Ai,Gg,Wwf,Rb}
			{WCT_CHANCE_REPLACE 23 Aa^Fpa,Aa^Fpa,Ha,Ha,Ha^Fpa,Gg^Fp,Aa^Fpa,Ha,Ha,Ha^Fpa,Ms,Ms,Aa^Fmwa,Ha,Aa^Fmf}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ss,Wwf,Ss,Wwf,Ww}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_2_2()
	[default]
		{WCT_TERRAIN_REPLACE Gg,Gg,Gg,Ss}
		{WCT_CHANCE_REPLACE 20 Gg^Fp,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Fms,Gg^Fds,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Gg^Fds,Gg^Fp}
	[/default]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ss,Ss,Ss,Ss,Ss,Ss,Ss^Uf}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_2_3()
	[default]
		{WCT_TERRAIN_REPLACE Gg,Gs,Ss}
		{WCT_CHANCE_REPLACE 20 Gg^Fds,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Ftr,Gg^Ftr,Hh,Hh,Hh^Fds,Mm,Hh^Uf,Gs^Ftp,Gs^Fds,Gs^Ftp}
	[/default]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ss^Fts,Ss^Fts,Ss^Fts,Ss^Fts,Ss}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_2_4()
	[default]
		[terrain]
			terrain=Gs
			find_in=terrain_to_change
		[/terrain]
		{WCT_CHANCE_REPLACE 20 Gs^Fds,Gs^Ftp,Hh,Hh,Hh^Ftp,Gs^Fts,Gs^Ft,Hh,Hh,Hh^Fds,Md,Hh^Uf,Gs^Ftp,Gs^Ftd}
	[/default]
	[chance]
		value=2
		[command]
			{WCT_TERRAIN_REPLACE Ds,Sm}
		[/command]
	[/chance]
	[chance]
		value=17
		[command]
			{WCT_TERRAIN_REPLACE Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hhd,Dd,Dd,Dd,Md}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Hhd,Ur}
			{WILD_VOLCANO_FOR_LAVA_ZONE}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_3_1()
	[default]
		[terrain]
			terrain=Gg
			find_in=terrain_to_change
		[/terrain]
		{WCT_CHANCE_REPLACE 25 Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Gg^Fmf}
	[/default]
	[chance]
		value=11
		[command]
			{WCT_TERRAIN_REPLACE Aa,Aa,Aa,Aa,Aa,Aa,Aa,Aa,Ai,Gg,Wwf,Rb}
			{WCT_CHANCE_REPLACE 30 Aa^Fpa,Aa^Fpa,Ha,Ha,Ha^Fpa,Gg^Fp,Aa^Fpa,Ha,Ha,Ha^Fpa,Ms,Ms,Aa^Fmwa,Ha,Aa^Fmf}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ss,Wwf,Ss,Wwf,Ww}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_3_2()
	[default]
		[terrain]
			terrain=Gg
			find_in=terrain_to_change
		[/terrain]
		{WCT_CHANCE_REPLACE 25 Gg^Fp,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Fms,Gg^Fds,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Gg^Fds,Gg^Fp}
	[/default]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ss,Ss,Ss,Ss,Ss,Ss,Ss^Uf}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_3_3()
	[default]
		{WCT_TERRAIN_REPLACE Gg,Gg,Gs}
		{WCT_CHANCE_REPLACE 25 Gg^Fds,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Ftr,Gg^Ftr,Hh,Hh,Hh^Fds,Mm,Hh^Uf,Gs^Ftp,Gs^Fds,Gs^Ftp}
	[/default]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ss^Fts,Ss^Fts,Ss^Fts,Ss^Fts,Ss^Fts,Ss}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_3_4()
	[default]
		[terrain]
			terrain=Gs
			find_in=terrain_to_change
		[/terrain]
		{WCT_CHANCE_REPLACE 25 Gs^Fds,Gs^Ftp,Hh,Hh,Hh^Ftp,Gs^Fts,Gs^Ft,Hh,Hh,Hh^Fds,Md,Hh^Uf,Gs^Ftp,Gs^Ftd}
	[/default]
	[chance]
		value=18
		[command]
			{WCT_TERRAIN_REPLACE Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hhd,Dd,Dd,Dd,Md}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Sm^Fdw,Sm^Fdw,Sm,Sm,Wwf}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Hhd,Ur,Hhd,Ur,Hhd,Ur,Hhd,Ql}
			{WILD_VOLCANO_FOR_LAVA_ZONE}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Gd,Gd,Gd,Hhd,Gd,Gd,Gd,Hhd,Gd,Gd,Gd,Hh,Gd,Gd,Gd,Hh^Fts}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_4_1()
	[default]
		[terrain]
			terrain=Gg
			find_in=terrain_to_change
		[/terrain]
		{WCT_CHANCE_REPLACE 52 Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Hh,Hh,Hh^Fp,Ms,Hh,Hh,Hh^Fp,Gg^Fmf}
	[/default]
	[chance]
		value=14
		[command]
			{WCT_TERRAIN_REPLACE Ms,Ms,Ha,Ha,Ha,Ha,Ha^Fpa,Aa,Aa^Fpa}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_4_2()
	[default]
		{WCT_TERRAIN_REPLACE Gg,Gg^Efm}
		{WCT_CHANCE_REPLACE 52 Gg^Fp,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Fms,Gg^Fds,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Hh,Hh,Hh^Fp,Mm,Hh,Hh,Hh^Fp,Gg^Fds,Gg^Fp}
	[/default]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ss,Ss,Ss,Ss,Ss,Ss,Ss^Uf}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_4_3()
	[default]
		{WCT_TERRAIN_REPLACE Gg,Gg,Gs}
		{WCT_CHANCE_REPLACE 52 Gg^Fds,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Ftr,Gg^Ftr,Hh,Hh,Hh^Fds,Mm,Hh^Uf,Hh,Hh,Hh^Fds,Mm,Hh,Hh,Hh^Fds,Gs^Fds,Gs^Ftp}
	[/default]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ss^Fts,Ss^Fts,Ss^Fts,Ss^Fts,Ss^Fts,Hh^Ft,Ss}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_4_4()
	[default]
		[terrain]
			terrain=Gs
			find_in=terrain_to_change
		[/terrain]
		{WCT_CHANCE_REPLACE 52 Gs^Fds,Gs^Ftp,Hh,Hh,Hh^Ftp,Gs^Fts,Gs^Ft,Hh,Hh,Hh^Fds,Md,Hh^Uf,Hh,Hh,Hh^Fds,Md,Hh,Hh,Hh^Fds,Gs^Ftp}
	[/default]
	[chance]
		value=9
		[command]
			{WCT_TERRAIN_REPLACE Dd,Dd,Dd,Dd,Hd,Hd,Hhd,Md}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Sm^Fdw,Sm^Fdw,Sm^Fdw,Sm,Wwf}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Hhd,Ur,Hhd,Ur,Hhd,Ql}
			{WILD_VOLCANO_FOR_LAVA_ZONE}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Gd,Hhd,Gd,Hhd,Gd,Hh,Gd,Hh^Fts,Gd,Md}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_5_1()
	[default]
		{WCT_TERRAIN_REPLACE Gg^Fp,Aa^Fpa,Hh,Hh,Hh^Fp,Gg^Fp,Gg^Fp,Ha,Ha,Ha^Fpa,Ms,Aa^Fpa,Ms,Ms,Ms,Ms,Ms,Ms,Ms,Ms,Gg,Gg,Gg,Gg,Gg,Gg,Wwf,Gg^Fmf,Hh^Fmw,Ha^Fpa,Ha}
	[/default]
	[chance]
		value=17
		[command]
			{WCT_TERRAIN_REPLACE Ms,Ha,Ms,Ms,Ha^Fdwa,Ha^Fmwa,,Ha^Fpa,Aa^Fmwa,Aa^Fdwa,Aa}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Ww
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_5_2()
	[default]
		{WCT_TERRAIN_REPLACE Gg^Fp,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Fms,Gg^Fds,Hh,Hh,Hh^Fp,Hh^Fp,Mm,Gg^Uf,Mm,Mm,Mm,Mm,Mm,Mm,Mm,Mm,Gg,Gg,Gg,Gg,Gg,Gg,Gg,Hh^Fp,Gg^Fds,Hh}
	[/default]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ww,Hh,Mm}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_5_3()
	[default]
		{WCT_TERRAIN_REPLACE Gg^Fds,Gg^Fms,Hh,Hh,Hh^Fms,Hh^Fms,Gg^Ftr,Gg^Ftr,Hh,Hh,Hh^Fds,Mm,Hh^Uf,Mm,Mm,Mm,Mm,Mm,Mm,Mm,Mm,Gg,Gg,Gs,Gg,Gg,Gs,Gg,Gs^Ftp,Gs^Fds,Hh}
	[/default]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ss^Fts,Ss,Ss,Hh^Ft}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_5_4()
	[default]
		{WCT_TERRAIN_REPLACE Gs^Fds,Gs^Ftp,Hh,Hh,Hh^Ftp,Gs^Fts,Gs^Ft,Hh,Hh,Hh^Fds,Hh^Fds,Md,Hh^Uf,Md,Md,Md,Md,Md,Md,Md,Md,Gg,Gs,Gg,Gs,Gg,Gs,Gs,Gs^Ftp,Gs^Ftr,Hh}
	[/default]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Ql
				find_in=terrain_to_change
			[/terrain]
			{WILD_VOLCANO_FOR_LAVA_ZONE}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Gd,Hhd,Gd,Hhd,Gd,Hh,Gd,Hh^Fts,Gd,Md,Md,Md}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Sm^Fdw,Sm^Fdw,Sm^Fdw,Sm,Wwf,Hh,Hh^Fds}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_6_1()
	[default]
		{WCT_TERRAIN_REPLACE Ms,Ms^Xm,Ms^Xm,Ms^Xm,Ms,Ms^Xm,Ms^Xm,Ms^Xm,Ms,Ms^Xm,Ms^Xm,Ms^Xm,Ha,Ha^Fpa,Aa,Ha^Fpa,Ha}
	[/default]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Ai
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_6_2()
	[default]
		{WCT_TERRAIN_REPLACE Mm,Ms^Xm,Mm^Xm,Mm^Xm,Mm,Ms^Xm,Mm^Xm,Mm^Xm,Mm,Ms^Xm,Mm^Xm,Mm^Xm,Hh^Fp,Hh^Uf,Gg,Hh^Fms,Hh}
	[/default]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Wwg
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_6_3()
	[default]
		{WCT_TERRAIN_REPLACE Mm,Mm^Xm,Mm^Xm,Mm^Xm,Mm,Mm^Xm,Mm^Xm,Mm^Xm,Mm,Mm^Xm,Mm^Xm,Mm^Xm,Hh^Fms,Hh^Uf,Gg,Hh^Fds,Hh}
	[/default]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ss^Fts,Ss,Hh^Ft,Mm}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_6_4()
	[default]
		{WCT_TERRAIN_REPLACE Md,Md^Xm,Md^Xm,Md^Xm,Md,Md^Xm,Md^Xm,Md^Xm,Md,Md^Xm,Md^Xm,Md^Xm,Hh^Fds,Hh^Uf,Gs,Hh^Ftp,Hh}
	[/default]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Ql
				find_in=terrain_to_change
			[/terrain]
			{WILD_VOLCANO_FOR_LAVA_ZONE}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Gd,Hhd,Gd,Hhd,Gd,Hh,Gd,Hh^Fts,Gd,Md,Md,Md,Hhd,Md}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Sm,Sm,Sm,Sm,Sm,Sm^Uf,Mm,Hh}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_7_1()
	[default]
		{WCT_TERRAIN_REPLACE Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uu,Rb,Wwg,Ai,Qxu,Uh,Uu,Uu,Uh,Uu,Uu^Em}
	[/default]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Qxu
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Ai
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Wwg
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Uh,Ai}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_7_2()
	[default]
		{WCT_TERRAIN_REPLACE Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uu,Re,Ww,Wwf,Qxu,Uu^Uf,Uh,Uu,Uu,Uh,Uu,Uu^Em,Uu^Uf}
	[/default]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Ww
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Ww,Wwf}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Wwf
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Uh,Ww}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Uu,Qxu}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_7_3()
	[default]
		{WCT_TERRAIN_REPLACE Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uu^Uf,Uu,Uu,Re,Uh^Uf,Wwf,Ql,Uu^Uf,Uh,Uu,Uu,Uh,Uu,Uu^Em,Uu^Uf}
	[/default]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Gll^Uf
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			[terrain]
				terrain=Ss
				find_in=terrain_to_change
			[/terrain]
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_7_4()
	[default]
		{WCT_TERRAIN_REPLACE Ql,Uh,Uu,Uu^Uf,Uh^Uf,Uh,Uu,Ql,Uh,Uu,Re,Ur,Uh,Uu,Uu,Uh,Uu,Uu^Em,Uu^Uf}
	[/default]
	[chance]
		value=2
		[command]
			[terrain]
				terrain=Ql
				find_in=terrain_to_change
			[/terrain]
			{WILD_VOLCANO_FOR_LAVA_ZONE}
		[/command]
	[/chance]
	[chance]
		value=1
		[command]
			{WCT_TERRAIN_REPLACE Sm,Sm,Sm,Sm,Sm,Sm,Sm^Uf}
		[/command]
	[/chance]
end

function wild_replacement_chances_zone_8_1()
	[default]
		-- do nothing
	[/default]
	[chance]
		value=5
		[command]
			{WCT_CHANCE_REPLACE 30 Wwf}
		[/command]
	[/chance]
	[chance]
		value=10
		[command]
			[terrain]
				terrain=Ss
				find_in=terrain_to_change
				[not]
					terrain=Wwf
				[/not]
			[/terrain]
		[/command]
	[/chance]
	[chance]
		value=8
		[command]
			[terrain]
				terrain=Wwg
				find_in=terrain_to_change
				[not]
					terrain=Wwf
				[/not]
			[/terrain]
		[/command]
	[/chance]
	[chance]
		value=7
		[command]
			[terrain]
				terrain=Wwt
				find_in=terrain_to_change
				[not]
					terrain=Wwf
				[/not]
			[/terrain]
		[/command]
	[/chance]
	[chance]
		value=3
		[command]
			[terrain]
				terrain=Qlf
				find_in=terrain_to_change
				[not]
					terrain=Wwf
					radius=1
				[/not]
			[/terrain]
			[terrain]
				terrain=Ur^Es
				find_in=terrain_to_change
				[and]
					terrain=W*
				[/and]
			[/terrain]
			[terrain]
				terrain=Ur^Es
				[and]
					terrain=W*
				[/and]
				[filter_adjacent_location]
					find_in=terrain_to_change
				[/filter_adjacent_location]
			[/terrain]
			{WILD_VOLCANO_FOR_LAVA_ZONE}
			[store_locations]
				terrain=G*^*
				[filter_adjacent_location]
					find_in=terrain_to_change
				[/filter_adjacent_location]
				variable=terrain_to_change
			[/store_locations]
			{WCT_LAYER_REPLACE Ur,Re,Re,Gd,Gd,Gd base}
			[terrain]
				terrain=*^Fdw
				layer=overlay
				find_in=terrain_to_change
				[and]
					terrain=*^F*
				[/and]
			[/terrain]
			[terrain]
				terrain=*
				layer=overlay
				find_in=terrain_to_change
				[and]
					terrain=*^Efm
				[/and]
			[/terrain]
		[/command]
	[/chance]
end

function wild_volcano_for_lava_zone()
	[store_locations]
		find_in=terrain_to_change
		[filter_adjacent_location]
			find_in=terrain_to_change
			count=3
			adjacent=se,s,sw
		[/filter_adjacent_location]
		variable=map_data.possible_volcano
	[/store_locations]
	[if]
		[variable]
			name=map_data.possible_volcano.length
			greater_than=0
		[/variable]
		[then]
			{RANDOM_INDEX map_data.possible_volcano}
			[terrain]
				terrain=Md^Xm
				[filter_adjacent_location]
					x=$map_data.possible_volcano[$random].x
					y=$map_data.possible_volcano[$random].y
					adjacent=ne,n,nw
				[/filter_adjacent_location]
			[/terrain]
			[terrain]
				terrain=Ql
				x=$map_data.possible_volcano[$random].x
				y=$map_data.possible_volcano[$random].y
			[/terrain]
		[/then]
	[/if]
end

-- to place right image in bonus points
function wild_store_cave_zone()
	[store_locations]
		terrain=X*^*
		variable=map_data.road_in_cave
	[/store_locations]
end

function wild_store_roads_in_cave_zone()
	[store_locations]
		terrain=R*,Ur
		find_in=map_data.road_in_cave
		variable=map_data.road_in_cave
	[/store_locations]
end
