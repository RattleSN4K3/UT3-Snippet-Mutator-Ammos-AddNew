/**
 * Mutator to initialize the map profile containing the locations 
 * for the new ammo factories
 */

class XAmmoAddMutator extends UTMutator;

function PostBeginPlay()
{
	// once this mutator gets loaded, it will initialize loading the ammos

	super.PostBeginPlay();
	LoadAmmos();
}

function LoadAmmos(optional string ProfileName = "")
{
	local XAmmoAddLocationInfo LocInfo;
	// "Exists" automatically checks for a valid profile and returns that one in LocInfo
	if (class'XAmmoAddLocationInfo'.static.Exists(LocInfo, ProfileName))
	{
		// ... we enforce to restores factories with our custom factory
		LocInfo.RestoreFactories();
	}
}

Defaultproperties
{
}