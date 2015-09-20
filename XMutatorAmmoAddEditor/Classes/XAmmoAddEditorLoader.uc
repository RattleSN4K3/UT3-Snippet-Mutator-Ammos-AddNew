class XAmmoAddEditorLoader extends BrushBuilder;

// with parenthesis, the field is shown in the dialog
var() string ProfileName;

// Build is called once the user clicks on the button 
// or chooses "Build" in the advanced menu
event bool Build()
{
	LoadAmmos();
	return false;
}

function LoadAmmos()
{
	local XAmmoAddLocationInfo LocInfo;
	local class<PickupFactory> AmmoFactoryClass;

	// ensure a profile exists
	if (!class'XAmmoAddLocationInfo'.static.Exists(LocInfo, ProfileName))
	{
		BadParameters("No stored profile for this map.");
		return;
	}

	// retrieve the specific factory class from the mutator properties
	AmmoFactoryClass = class'XAmmoAddMutator'.default.AmmoFactoryClass;

	// restroes and automatically create these in the editor instance
	LocInfo.RestoreFactories(AmmoFactoryClass);
}

DefaultProperties
{
	// not button icon for now
	//BitmapFilename="UnrealExTunnel" // Binaries\EditorRes\Cancel.png

	ToolTip="XMutatorAmmoAdd Loader"
}
