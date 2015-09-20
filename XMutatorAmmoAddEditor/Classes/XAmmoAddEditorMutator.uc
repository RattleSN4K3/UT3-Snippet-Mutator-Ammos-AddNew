/**
 * A editor mutator to be placed into a map in the Editor. Won't work otherwise.
 * By placing the actor into a map and run PIE, the custom ammo factories will
 * be saved into a map profile of the currently running instance.
 */
class XAmmoAddEditorMutator extends XAmmoAddMutator
	HideCategories(Mutator, Advanced, Attachment, Debug, Physics)
	hidedropdown
	placeable;

var private bool bPreInitialized;

//**********************************************************************************
// Inherited funtions
//**********************************************************************************

function PreBeginPlay()
{
	local string Error;

	// don't allow having this mutator enabled for any other instance than PIE
	if (!WorldInfo.IsPlayInEditor())
	{
		Destroy();
		return;
	}

	// just a requirement for an embedded mutator
	if (!bPreInitialized )
	{
		bPreInitialized = true;

		NextMutator = WorldInfo.Game.BaseMutator; 

		WorldInfo.Game.BaseMutator = self;
		InitMutator(WorldInfo.Game.ServerOptions,Error);
	}

	super.PreBeginPlay();
}

function AddMutator(Mutator M)
{
	// skip calling AddMutator twice
	if (M == self) {
		return;
	}

	super.AddMutator(M);
}

// called when gameplay actually starts
function MatchStarting()
{
	super.MatchStarting();

	`Log(name$"::MatchStarting - Call saving factories",,'XMutatorAmmoAdd');
	SaveAmmos();
}

function Mutate(string MutateString, PlayerController Sender)
{
	local string command, profilename;
	super.Mutate(MutateString, Sender);

	if (Sender == none)
		return;

	command = "SaveAmmos"; // "SaveAmmos ProfileName"
	if (Left(MutateString, Len(command)) ~= command)
	{
		profilename = Mid(MutateString, Len(command)+1); // "ProfileName"
		SaveAmmos(profilename);
		return;
	}
}

//**********************************************************************************
// Private funtions
//**********************************************************************************

// skip loading for editor mode
function LoadAmmos(optional string ProfileName = "");

function SaveAmmos(optional string ProfileName = "")
{
	local string MapName;
	local XAmmoAddLocationInfo LocInfo;

	MapName = ProfileName != "" ? ProfileName : GetMapName();
	`Log(name$"::PostBeginPlay - Map:"@MapName,,'XMutatorAmmoAdd');

	if (!class'XAmmoAddLocationInfo'.static.Create(LocInfo, MapName))
	{
		WorldInfo.Game.Broadcast(none, "Unable to create map profile.");
		return;
	}

	LocInfo.ClearConfig();
	LocInfo.StoreFactories(AmmoFactoryClass);
	LocInfo.SaveConfig();
	WorldInfo.Game.Broadcast(none, "Map profile data saved ("$LocInfo.FactoryCount()$" factories).");
}

function string GetMapName()
{
	local string MapName;

	MapName = WorldInfo.GetMapName(true);

	// strip the UEDPIE_ from the filename, if it exists (meaning this is a Play in Editor game)
	if (Left(MapName, 7) ~= "UEDPIE_")
	{
		MapName = Right(MapName, Len(MapName) - 7);
	}
	else if (Left(MapName, 10) ~= "UEDPOC_PS3")
	{
		MapName = Right(MapName, Len(MapName) - 10);
	}
	else if (Left(MapName, 12) ~= "UEDPOC_Xenon")
	{
		MapName = Right(MapName, Len(MapName) - 12);
	}

	return MapName;
}

DefaultProperties
{
	bExportMenuData=false
}