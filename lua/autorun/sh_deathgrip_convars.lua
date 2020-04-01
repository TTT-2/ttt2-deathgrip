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
