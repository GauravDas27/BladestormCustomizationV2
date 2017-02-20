class X2AbilityToHitCalc_BladestormAttack_BCV2 extends X2AbilityToHitCalc_StandardMelee config(XComBladestormCustomizationV2);

var float ReactionAimPenalty;

function AddReactionCritModifier(XComGameState_Unit Shooter, XComGameState_Unit Target)
{
	if (bAllowCrit)
	{
		return;
	}
	super.AddReactionCritModifier(Shooter, Target);
}

function float GetReactionAdjust(XComGameState_Unit Shooter, XComGameState_Unit Target)
{
	return ReactionAimPenalty;
}

DefaultProperties
{
	ReactionAimPenalty = class'X2AbilityToHitCalc_StandardMelee'.default.REACTION_FINALMOD;
}
