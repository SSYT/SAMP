public OnVehicleMod(playerid, vehicleid, componentid)
{
	if (VehicleProperty:vehicleid[SAVEID])
	{
		MySQLQuery("REPLACE INTO `vehiclecomponents` (`vehicleID`, `slot`, `component`) VALUES('%d', '%d', '%d')", VehicleProperty:vehicleid[SAVEID], GetVehicleComponentType(componentid), componentid);
	}
	return true;
}