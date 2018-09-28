#define WCT_MAP_ENEMY_THEMED RACE PET CASTLE VILLAGE CHANCE
	[set_variables]
		name=enemy_themed
		[value]
			race={RACE}
			pet={PET}
			castle={CASTLE}
			village={VILLAGE}
			chance={CHANCE}
		[/value]
	[/set_variables]
	[fire_event]
		name=wct_enemy_themed
	[/fire_event]
#enddef

#define WORLD_CONQUEST_TEK_MAP_ENEMY_THEMED
	[event]
		name=wct_enemy_themed
		id=wct_enemy_themed
		first_time_only=no
		{RANDOM 0..99}
		[store_unit]
			[filter]
				side=4,5,6,7,8,9
				canrecruit=yes
				race=$enemy_themed.race
				## human means only outlaw
				[not]
					race=human
					[not]
						[filter_wml]
							alignment=chaotic
						[/filter_wml]
					[/not]
				[/not]
			[/filter]
			variable=enemy_themed.boss
		[/store_unit]
		[if]
			{VARIABLE_CONDITIONAL random less_than $enemy_themed.chance}
			{VARIABLE_CONDITIONAL enemy_themed.boss.length greater_than 0}
			[then]
				## give themed castle
				[terrain]
					x=$enemy_themed.boss.x
					y=$enemy_themed.boss.y
					terrain=K$enemy_themed.castle
					layer=base
				[/terrain]
				[terrain]
					terrain=C$enemy_themed.castle
					[and]
						terrain=C*,*^C*
						[and]
							[filter]
								x=$enemy_themed.boss.x
								y=$enemy_themed.boss.y
							[/filter]
							radius=999
							[filter_radius]
								terrain=K*^*,C*^*,*^K*,*^C*
							[/filter_radius]
						[/and]
					[/and]
				[/terrain]
				[terrain]
					terrain=Ket
					layer=base
					[and]
						terrain=Ke
					[/and]
				[/terrain]
				## extra tweak with trees to elvish castle
				[wc2_terrain]
					[change]
						[filter]
							terrain=Cv
							[filter_adjacent_location]
								terrain=Kv^*
							[/filter_adjacent_location]
						[/filter]
						terrain=Cv^Fet
						fraction_rand=2..3
					[/change]
				[/wc2_terrain]
				## adjacent themed villages
				[terrain]
					terrain=$enemy_themed.village
					[and]
						terrain=*^V*
						[filter_adjacent_location]
							terrain=C$enemy_themed.castle,K$enemy_themed.castle|^*
						[/filter_adjacent_location]
					[/and]
				[/terrain]
				## give pet
				[unit]
					x,y=$enemy_themed.boss.x,$enemy_themed.boss.y
					type=$enemy_themed.pet
					side=$enemy_themed.boss.side
					name= {STR_ENEMY_PET}
					role=hero
					overlays=misc/hero-icon.png
					[modifications]
						{WORLD_CONQUEST_II_TRAIT_HEROIC}
						{WORLD_CONQUEST_II_TRAIT_EXPERT}
					[/modifications]
				[/unit]
			[/then]
		[/if]
		{CLEAR_VARIABLE enemy_themed}
	[/event]
#enddef
