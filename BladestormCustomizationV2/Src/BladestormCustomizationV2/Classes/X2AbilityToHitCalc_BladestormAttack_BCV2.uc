class X2AbilityToHitCalc_BladestormAttack_BCV2 extends X2AbilityToHitCalc_StandardMelee config(XComBladestormCustomizationV2);

function InternalRollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, const out AbilityResultContext ResultContext, out EAbilityHitResult Result, out ArmorMitigationResults ArmorMitigated, out int HitChance)
{
	bReactionFire = class'Settings'.static.IsReactionAttack();
	super.InternalRollForAbilityHit(kAbility, kTarget, ResultContext, Result, ArmorMitigated, HitChance);
}

protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional bool bDebugLog=false)
{
	local float AimPenalty;

	bReactionFire = class'Settings'.static.IsReactionAttack();
	bAllowCrit = class'Settings'.static.IsCritAllowed();

	AimPenalty = class'Settings'.static.GetAimPenaltyDecimal();
	if (bReactionFire || AimPenalty == 0.0f)
	{
		FinalMultiplier = default.FinalMultiplier;
	}
	else
	{
		FinalMultiplier = AimPenalty;
	}

	return super.GetHitChance(kAbility, kTarget, bDebugLog);
}

function AddReactionCritModifier(XComGameState_Unit Shooter, XComGameState_Unit Target)
{
	if (class'Settings'.static.IsCritAllowed())
	{
		return;
	}
	super.AddReactionCritModifier(Shooter, Target);
}

function float GetReactionAdjust(XComGameState_Unit Shooter, XComGameState_Unit Target)
{
	return class'Settings'.static.GetAimPenaltyDecimal();
}
