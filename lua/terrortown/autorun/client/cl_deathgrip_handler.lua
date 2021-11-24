local function DeathGripReset()
	LocalPlayer().DeathGripPartner = nil

	LANG.ProcessMsg("deathgrip_info_reset", nil, MSG_MSTACK_WARN)
end
net.Receive("TTT2DeathgripReset", DeathGripReset)

local function DeathGripPartner()
	local partner = net.ReadEntity()

	if partner ~= nil and partner ~= "NULL" then
		LocalPlayer().DeathGripPartner = partner

		LANG.ProcessMsg("deathgrip_info_select", {nick = partner:Nick()}, MSG_MSTACK_PLAIN)
	end
end
net.Receive("TTT2DeathgripPartner", DeathGripPartner)
