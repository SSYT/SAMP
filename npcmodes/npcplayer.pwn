#include <a_npc>
#include <sscanf>
#include <grgserver/config>

new recordingName[256];
new playbackType;
new autoRepeat;
new isPaused;
new isTimer;
new timer;

forward Timer();

public OnClientMessage(color, text[])
{
	/*
	Accepted content for "text":
	<recordingName> <playbackType> <autoRepeat>
	pause
	resume
	stop
	teleport
	*/
	if (color != COLOR_NPCCOMMAND)
	{
		return false;
	}
	new string[256];
	format(string, sizeof(string), "I've received a command: %s", text);
	SendChat(string);
	if (!sscanf(text, "sdd", recordingName, playbackType, autoRepeat))
	{
		StartNPC();
		return true;
	}
	new command[256];
	if (!sscanf(text, "s", command))
	{
		if (!strcmp(command, "pause", true))
		{
			StopTimer();
			PauseNPC(true);
		}
		if (!strcmp(command, "resume", true))
		{
			PauseNPC(true);
			StartTimer();
		}
		if (!strcmp(command, "stop", true))
		{
			StopRecordingPlayback();
		}
		if (!strcmp(command, "teleport", true))
		{
			new Float:posX;
			new Float:posY;
			new Float:posZ;
			new Float:angle;
			sscanf(text, "sffff", command, posX, posY, posZ, angle);
			SetMyPos(posX, posY, posZ);
			SetMyFacingAngle(angle);
			format(string, sizeof(string), "I got teleported to %f x %f x %f", posX, posY, posZ);
			SendChat(string);
		}
		return true;
	}
	return false;
}

public OnNPCEnterVehicle(vehicleid,seatid)
{
	if (playbackType == PLAYER_RECORDING_TYPE_DRIVER)
	{
		StartNPC();
	}
}

public OnNPCExitVehicle()
{
	if (playbackType == PLAYER_RECORDING_TYPE_DRIVER)
	{
		StopRecordingPlayback();
	}
}

public OnRecordingPlaybackEnd()
{
	if (autoRepeat)
	{
		StartNPC();
	}
	else
	{
		SendCommand("/npccmd stopped");
	}
}

public Timer()
{
	new pause;
	for (new playerID = 0; playerID < MAX_PLAYERS; playerID++)
	{
		if (IsPlayerConnected(playerID))
		{
			new playerName[MAX_PLAYER_NAME];
			GetPlayerName(playerID, playerName, sizeof(playerName));
			strdel(playerName, 4, strlen(playerName));
			if (strcmp(playerName, "NPC_", true))
			{
				new Float:posX;
				new Float:posY;
				new Float:posZ;
				new Float:distance;
				GetPlayerPos(playerID, posX, posY, posZ);
				GetDistanceFromMeToPoint(posX, posY, posZ, distance);
				if (distance <= NPC_PAUSEDISTANCE)
				{
					pause = true;
					break;
				}
			}
		}
	}
	if (pause)
	{
		if (!isPaused)
		{
			PauseNPC(true);
		}
	}
	else
	{
		if (isPaused)
		{
			PauseNPC(false);
		}
	}
}

PauseNPC(newState)
{
	if (newState)
	{
		isPaused = true;
		PauseRecordingPlayback();
	}
	else
	{
		isPaused = false;
		ResumeRecordingPlayback();
	}
}

StartNPC()
{
	isPaused = false;
	StartRecordingPlayback(playbackType, recordingName);
	// StartTimer();
}

StartTimer()
{
	if (!isTimer)
	{
		timer = SetTimer("Timer", 200, true);
		isTimer = true;
	}
}

StopTimer()
{
	if (isTimer)
	{
		KillTimer(timer);
		isTimer = false;
	}
}