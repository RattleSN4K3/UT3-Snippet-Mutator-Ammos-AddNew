/** 
 * Basic ammo factory to spawn in the level on runtime
 */
class XAmmoAddFactory extends UTAmmoPickupFactory
	//hidedropdown // in general the class should be hidden in dropdowns, but we want to use it for the Saver
	;

/** Ammo factory to transform the spawned ammo factory to on runtime */
var() transient class<UTAmmoPickupFactory> AmmoClass;

function SetAmmoType(class<UTAmmoPickupFactory> InAmmoClass)
{
	// transform ammo factory
	AmmoClass = InAmmoClass;
	TransformAmmoType(InAmmoClass);
}

// Simulated. To be called clientsided as well (on replication of TransformedClass)
simulated function TransformAmmoType(class<UTAmmoPickupFactory> NewAmmoClass)
{
	local bool bHadBaseMaterial;

	// re-create the BaseMaterialInstance which is required as transforming the
	// ammo pickup factory clear that instance. This would result into a hidden
	// factory after the ammo is taken once

	if (NewAmmoClass == none)
	{
		NewAmmoClass = AmmoClass;
	}

	bHadBaseMaterial = BaseMaterialInstance != none;
	super.TransformAmmoType(NewAmmoClass);

	if (bHadBaseMaterial && BaseMaterialInstance == none)
	{
		if ( WorldInfo.NetMode != NM_DedicatedServer && BaseMesh != none )
		{
			BaseMaterialInstance = BaseMesh.CreateAndSetMaterialInstanceConstant(0);
		}
	}

	bOnlyReplicateHidden = default.bOnlyReplicateHidden;
}

// We only want to change basic properties to allow runtime spawning
// and additional support for multiple ammo. Special replication is set
// to support scaling, rotation and mirroring. Factory are replicated fine
DefaultProperties
{
	Begin Object Name=AmmoMeshComp
		StaticMesh=StaticMesh'PICKUPS.Base_Powerup.Mesh.S_Pickups_Base_Powerup01_Disc'
		Scale=2.0
		Translation=(X=0.0,Y=0.0,Z=-20.0)
	End Object

	// allow dynamic spawn
	bStatic=false
	bNoDelete=false

	// allow basing on moveable actors (such as lifts)
	bMovable=true

	// replicate initial rotation
	bNetInitialRotation=true
	bNeverReplicateRotation=false // just set is for safety

	// replicate all other props (not only the 'hidden' flag)
	bOnlyReplicateHidden=false
}
