class X2Condition_ReactionExclusion_BCV2 extends X2Condition;

var X2Condition_UnitEffects OverwatchExclusion;

function name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	if (!class'Settings'.static.IsReactionAttack() || OverwatchExclusion == none)
	{
		return 'AA_Success';
	}
	return OverwatchExclusion.MeetsCondition(kTarget);;
}
