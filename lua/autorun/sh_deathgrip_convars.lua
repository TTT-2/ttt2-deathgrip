CreateConVar("ttt2_deathgrip", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_deathgrip_min_players", "4", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_deathgrip_reset_min_players", "3", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_deathgrip_chance", "0.5", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

hook.Add("TTTUlxInitCustomCVar", "TTTDeathgripInitRWCVar", function(name)
	ULib.replicatedWritableCvar("ttt2_deathgrip", "rep_ttt2_deathgrip", GetConVar("ttt2_deathgrip"):GetBool(), true, false, name)
	ULib.replicatedWritableCvar("ttt2_deathgrip_min_players", "rep_ttt2_deathgrip_min_players", GetConVar("ttt2_deathgrip_min_players"):GetInt(), true, false, name)
	ULib.replicatedWritableCvar("ttt2_deathgrip_reset_min_players", "rep_ttt2_deathgrip_reset_min_players", GetConVar("ttt2_deathgrip_reset_min_players"):GetInt(), true, false, name)
	ULib.replicatedWritableCvar("ttt2_deathgrip_chance", "rep_ttt2_deathgrip_chance", GetConVar("ttt2_deathgrip_chance"):GetFloat(), true, false, name)
end)

--[[
if SERVER then
	-- ConVar replication is broken in GMod, so we do this, at least Alf added a hook!
	-- I don't like it any more than you do, dear reader. Copycat!
	hook.Add("TTT2SyncGlobals", "ttt2_supersoda_sync_convars", function()
		SetGlobalFloat("ttt_soda_total_spawn_amount", GetConVar("ttt_soda_total_spawn_amount"):GetInt())
		SetGlobalBool("ttt_soda_limit_one_per_player", GetConVar("ttt_soda_limit_one_per_player"):GetBool())
		SetGlobalFloat("ttt_soda_speedup", GetConVar("ttt_soda_speedup"):GetFloat())
		SetGlobalFloat("ttt_soda_rageup", GetConVar("ttt_soda_rageup"):GetFloat())
		SetGlobalFloat("ttt_soda_shootup", GetConVar("ttt_soda_shootup"):GetFloat())
		SetGlobalFloat("ttt_soda_armorup", GetConVar("ttt_soda_armorup"):GetInt())
		SetGlobalFloat("ttt_soda_healup", GetConVar("ttt_soda_healup"):GetInt())
		SetGlobalFloat("ttt_soda_creditup", GetConVar("ttt_soda_creditup"):GetInt())
	end)

	-- sync convars on change
	cvars.AddChangeCallback("ttt_soda_total_spawn_amount", function(cv, old, new)
		SetGlobalInt("ttt_soda_total_spawn_amount", tonumber(new))
	end)
	cvars.AddChangeCallback("ttt_soda_limit_one_per_player", function(cv, old, new)
		SetGlobalBool("ttt_soda_limit_one_per_player", tobool(tonumber(new)))
	end)
	cvars.AddChangeCallback("ttt_soda_speedup", function(cv, old, new)
		SetGlobalFloat("ttt_soda_speedup", tonumber(new))
	end)
	cvars.AddChangeCallback("ttt_soda_rageup", function(cv, old, new)
		SetGlobalFloat("ttt_soda_rageup", tonumber(new))
	end)
	cvars.AddChangeCallback("ttt_soda_shootup", function(cv, old, new)
		SetGlobalFloat("ttt_soda_shootup", tonumber(new))
	end)
	cvars.AddChangeCallback("ttt_soda_armorup", function(cv, old, new)
		SetGlobalFloat("ttt_soda_armorup", tonumber(new))
	end)
	cvars.AddChangeCallback("ttt_soda_healup", function(cv, old, new)
		SetGlobalFloat("ttt_soda_healup", tonumber(new))
	end)
	cvars.AddChangeCallback("ttt_soda_creditup", function(cv, old, new)
		SetGlobalFloat("ttt_soda_creditup", tonumber(new))
	end)
end
]]

if CLIENT then
	hook.Add("TTTUlxModifyAddonSettings", "TTTDeathgripModifySettings", function(name)
		local tttrspnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

		-- Basic Settings
		local tttrsclp1 = vgui.Create("DCollapsibleCategory", tttrspnl)
		tttrsclp1:SetSize(390, 95)
		tttrsclp1:SetExpanded(1)
		tttrsclp1:SetLabel("Basic Settings")

		local tttrslst1 = vgui.Create("DPanelList", tttrsclp1)
		tttrslst1:SetPos(5, 25)
		tttrslst1:SetSize(390, 95)
		tttrslst1:SetSpacing(5)

		tttrslst1:AddItem(xlib.makecheckbox{
			label = "ttt2_deathgrip (Def. 1)",
			repconvar = "rep_ttt2_deathgrip",
			parent = tttrslst1
		})

		tttrslst1:AddItem(xlib.makeslider{
			label = "ttt2_deathgrip_min_players (Def. 4)",
			repconvar = "rep_ttt2_deathgrip_min_players",
			min = 2,
			max = 50,
			decimal = 0,
			parent = tttrslst1
		})

		tttrslst1:AddItem(xlib.makeslider{
			label = "ttt2_deathgrip_reset_min_players (Def. 3)",
			repconvar = "rep_ttt2_deathgrip_reset_min_players",
			min = 2,
			max = 50,
			decimal = 0,
			parent = tttrslst1
		})

		tttrslst1:AddItem(xlib.makeslider{
			label = "ttt2_deathgrip_chance (Def. 0.5)",
			repconvar = "rep_ttt2_deathgrip_chance",
			min = 0,
			max = 1,
			decimal = 2,
			parent = tttrslst1
		})

		-- add to ULX
		xgui.hookEvent("onProcessModules", nil, tttrspnl.processModules)
		xgui.addSubModule("Deathgrip", tttrspnl, nil, name)
	end)
end
