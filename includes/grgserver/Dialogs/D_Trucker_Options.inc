ShowDialog:TRUCKER_OPTIONS(playerID)
{
	FormatNew:options[50]("Auftr�ge");
	Format:options("%s\nFinanzen", options);
	Format:options("%s\nK�ndigen", options);
	Format:options("%s\nBewerbungs�bersicht", options);
	CreateDialog(playerID, "TRUCKER_OPTIONS", DIALOG_STYLE_LIST, "Trucker �bersicht", options, "OK", LanguageString(playerID, 165));
}

DialogResponse:TRUCKER_OPTIONS(playerID, response, listItem, inputText[])
{
	if (response)
	{
		switch (listItem)
		{
			case 0: // Auftr�ge
			{
				ShowDialog:ACCEPT(playerID);
			}
			case 1: // Finanzen
			{
				// TODO: Finanzen f�r jeden Job erstellen: Job Guthaben
				SendClientMessage(playerID, COLOR_SYSTEM, "Work in progress");
			}
			case 2: // K�ndigen
			{
				SendClientMessage(playerID, COLOR_SYSTEM, "Work in progress");
			}
			case 3: // Bewerbungs �bersicht
			{
				SendClientMessage(playerID, COLOR_SYSTEM, "Work in progress");
			}
		}
	}
}