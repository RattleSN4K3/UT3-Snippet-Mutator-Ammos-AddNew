class XAmmoAddEditorSaver extends BrushBuilder;

// with parenthesis, the field is shown in the dialog
var() string ProfileName;

// Build is called once the user clicks on the button 
// or chooses "Build" in the advanced menu
event bool Build()
{
	SaveAmmos();
	return false;
}

function SaveAmmos()
{
	local XAmmoAddLocationInfo LocInfo;

	// don't save any data for invalid maps (when no map is loaded for instance)
	if (!class'XAmmoAddLocationInfo'.static.Create(LocInfo, ProfileName))
	{
		BadParameters("Unable to create AmmoFactory profile.");
		return;
	}

	// clear old data, store new data and save it
	LocInfo.ClearConfig();
	LocInfo.StoreFactories(true);
	LocInfo.SaveConfig();
}

DefaultProperties
{
	// not button icon for now
	//BitmapFilename="UnrealExTunnel" // Binaries\EditorRes\Cancel.png

	ToolTip="XMutatorAmmoAdd Saver"
}
