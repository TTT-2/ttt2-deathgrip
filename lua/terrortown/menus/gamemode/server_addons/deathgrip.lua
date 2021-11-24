CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_server_addons_deathgrip_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_addons_deathgrip")

	local masterEnb = form:MakeCheckBox({
		serverConvar = "ttt2_deathgrip",
		label = "label_deathgrip"
	})

	form:MakeSlider({
		serverConvar = "ttt2_deathgrip_min_players",
		label = "label_deathgrip_min_players",
		min = 2,
		max = 64,
		decimal = 0,
		master = masterEnb
	})

	form:MakeSlider({
		serverConvar = "ttt2_deathgrip_reset_min_players",
		label = "label_deathgrip_reset_min_players",
		min = 2,
		max = 64,
		decimal = 0,
		master = masterEnb
	})

	form:MakeSlider({
		serverConvar = "ttt2_deathgrip_chance",
		label = "label_deathgrip_chance",
		min = 0,
		max = 1,
		decimal = 2,
		master = masterEnb
	})
end
