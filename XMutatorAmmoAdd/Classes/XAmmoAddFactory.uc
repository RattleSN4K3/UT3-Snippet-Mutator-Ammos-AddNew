/** 
 * Basic ammo factory to spawn in the level on runtime
 */
class XAmmoAddFactory extends UTAmmoPickupFactory
	hidedropdown;

/** Ammo factory to transform the spawned ammo factory to on runtime */
var() transient class<UTAmmoPickupFactory> AmmoClass;

simulated function PostBeginPlay()
{
	if ( bIsDisabled )
	{
		return;
	}

	// transform ammo factory and re-apply changed properties
	TransformAmmoType(AmmoClass);
	bOnlyReplicateHidden = default.bOnlyReplicateHidden;

	Super.PostBeginPlay();
}

// We only want to change basic properties to allow runtime spawning
// and additional support for multiple ammo. Special replication is set
// to support scaling, rotation and mirroring. Factory are replicated fine
DefaultProperties
{
	// set the initial ammo as we don't set it elsewhere in the code (currently)
	AmmoClass=class'UTAmmo_ShockRifle'


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
