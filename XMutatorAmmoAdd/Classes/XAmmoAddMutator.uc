/**
 * Mutator to initialize the map profile containing the locations 
 * for the new ammo factories
 */

class XAmmoAddMutator extends UTMutator;

var class<PickupFactory> AmmoFactoryClass;

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
		LocInfo.RestoreFactories(AmmoFactoryClass);
	}
}

function Mutate(string MutateString, PlayerController Sender)
{
	local string command;
	local XAmmoAddFactory AmmoFac;
	super.Mutate(MutateString, Sender);

	if (Sender == none)
		return;

	command = "FixAmmos";
	if (Left(MutateString, Len(command)) ~= command)
	{
		LogInternal(command);
		foreach WorldInfo.DynamicActors(class'XAmmoAddFactory', AmmoFac)
		{
			AmmoFac.SetResOut();
			//AmmoFac.LastRenderTime = WorldInfo.TimeSeconds;
			//if (AmmoFac.MIC_Visibility != none)
			//{
			//	AmmoFac.MIC_Visibility.SetScalarParameterValue(AmmoFac.VisibilityParamName, 0.0f);
			//}
		}
		
		return;
	}
}

Defaultproperties
{
	AmmoFactoryClass=class'XAmmoAddFactory'
}