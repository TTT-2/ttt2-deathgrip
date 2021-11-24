util.AddNetworkString("TTT2DeathgripAnnouncement")
util.AddNetworkString("TTT2DeathgripPartner")
util.AddNetworkString("TTT2DeathgripAnnouncementDeath")
util.AddNetworkString("TTT2DeathgripReset")

local function ResetDeathGrip()
	local plys = player.GetAll()
	for _, v in ipairs(plys) do
		v.DeathGripPartner = nil
	end

	net.Start("TTT2DeathgripReset")
	net.Broadcast()
end

cvars.AddChangeCallback("ttt2_deathgrip", function(name, old, new)
	SetGlobalBool(name, tobool(new))
	if tobool(new) == false then
		ResetDeathGrip()
	end
end, "TTT2DeathGripEnabledChange")

local function NotifyPlayerDeathgrip(ply)
	net.Start("TTT2DeathgripPartner")
	net.WriteEntity(ply.DeathGripPartner)
	net.Send(ply)
end

local function AnnounceDeathgrip()
	net.Start("TTT2DeathgripAnnouncement")
	net.Broadcast()
end

local function AnnounceDeathgripDeath()
	net.Start("TTT2DeathgripAnnouncementDeath")
	net.Broadcast()
end

local function SelectDeathgripPlayers()
	if not TTT2 or not GetConVar("ttt2_deathgrip"):GetBool() then return end

	math.randomseed(os.time())

	if math.Rand(0, 1) > GetConVar("ttt2_deathgrip_chance"):GetFloat() then return end

	local players = util.GetFilteredPlayers(function (ply)
		return ply:IsTerror() and (not SHINIGAMI or not ply:IsRole(ROLE_SHINIGAMI)) and (not HITMAN or not ply:IsRole(ROLE_HITMAN))
	end)

	-- minimum 2 players to work
	if #players < 2 or #players < GetConVar("ttt2_deathgrip_min_players"):GetInt() then return end

	local p1index = math.random(1, #players)
	local p1 = players[p1index]

	table.remove(players, p1index)

	local p2index = math.random(1, #players)
	local p2 = players[p2index]

	--Set DeathGrip relation
	p1.DeathGripPartner = p2
	p2.DeathGripPartner = p1

	NotifyPlayerDeathgrip(p1)
	NotifyPlayerDeathgrip(p2)

	AnnounceDeathgrip()
end

local function OnPlayerDisconnected(ply)
	if ply.DeathGripPartner then
		ResetDeathGrip()
	end
end

local function OnPlayerDeath(ply, inflictor, attacker)
	if IsValid(ply.DeathGripPartner) then
		local isPlayer = attacker:IsPlayer() or inflictor:IsPlayer()

		if ply.DeathGripPartner:IsTerror() and isPlayer and attacker ~= ply and inflictor ~= ply then
			-- kill the other player
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(10000)
			dmginfo:SetAttacker(game.GetWorld())
			dmginfo:SetDamageType(DMG_GENERIC)
			ply.DeathGripPartner:TakeDamageInfo(dmginfo)

			MsgN("[TTT2][DeathGrip] Killed the DeathGrip Partner.")

			AnnounceDeathgripDeath()
		end

		MsgN("[TTT2][DeathGrip] Reset DeathGrip after death...")

		ResetDeathGrip()
	end

	if (#util.GetAlivePlayers() - 1) <= GetConVar("ttt2_deathgrip_reset_min_players"):GetInt() then
		ResetDeathGrip()
	end
end

hook.Add("PlayerDisconnected", "TTT2RemoveDeathGrip", OnPlayerDisconnected)
hook.Add("TTTBeginRound", "TTT2DeathGripSelectPlayers", SelectDeathgripPlayers)
hook.Add("TTTPrepareRound", "TTT2DeathGripReset", ResetDeathGrip)
hook.Add("TTTEndRound", "TTT2DeathGripReset", ResetDeathGrip)
hook.Add("PlayerDeath", "TTT2DeathGripDeathCheck", OnPlayerDeath)
