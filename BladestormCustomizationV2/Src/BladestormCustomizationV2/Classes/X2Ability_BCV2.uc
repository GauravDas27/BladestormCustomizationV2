// dirty hack to expose X2Ability protected variables
class X2Ability_BCV2 extends X2Ability;

function X2Condition_UnitProperty GetLivingHostileUnitDisallowMindControlProperty()
{
	return default.LivingHostileUnitDisallowMindControlProperty;
}

function X2AbilityTarget_Single GetSimpleSingleTarget()
{
	return default.SimpleSingleTarget;
}

function X2AbilityTarget_Single GetSimpleSingleMeleeTarget()
{
	return default.SimpleSingleMeleeTarget;
}
