class Settings extends Settings_Defaults config(BladestormCustomizationV2);

function Save()
{
	default.ATTACK_TYPE = ATTACK_TYPE;
	default.ALLOW_CRIT = ALLOW_CRIT;
	default.AIM_PENALTY = AIM_PENALTY;

	default.TRIGGER_ON_MOVE = TRIGGER_ON_MOVE;
	default.TRIGGER_ON_ATTACK = TRIGGER_ON_ATTACK;
	default.TRIGGER_ON_MOVE_AWAY = TRIGGER_ON_MOVE_AWAY;

	default.ATTACK_RANGE = ATTACK_RANGE;

	StaticSaveConfig();
}

//getters

// returns 0 for reaction attack and 1 for standard attack
function int GetAttackType()
{
	return Clamp(0, default.ATTACK_TYPE, 1);
}

function bool IsCritAllowed()
{
	return default.ALLOW_CRIT;
}

function float GetMinAimPenalty()
{
	return 0.0f;
}

function float GetMaxAimPenalty()
{
	return 100.0f;
}

function float GetAimPenaltyStep()
{
	return 1.0f;
}

function float GetAimPenalty()
{
	return FClamp(GetMinAimPenalty(), default.AIM_PENALTY * GetMaxAimPenalty(), GetMaxAimPenalty());
}

function bool IsTriggeredOnMove()
{
	return default.TRIGGER_ON_MOVE;
}

function bool IsTriggeredOnAttack()
{
	return default.TRIGGER_ON_ATTACK;
}

function bool IsTriggeredOnMoveAway()
{
	return default.TRIGGER_ON_MOVE_AWAY;
}

function int GetMinAttackRange()
{
	return 1;
}

function int GetMaxAttackRange()
{
	return 10;
}

function int GetAttackRangeStep()
{
	return 1;
}

function int GetAttackRange()
{
	return Clamp(GetMinAttackRange(), default.ATTACK_RANGE, GetMaxAttackRange());
}

//setters

function SetAttackType(int AttackType)
{
	ATTACK_TYPE = Clamp(0, AttackType, 1);
}

function SetCritAllowed(bool CritAllowed)
{
	ALLOW_CRIT = CritAllowed;
}

function SetAimPenalty(float AimPenalty)
{
	AIM_PENALTY = FClamp(GetMinAimPenalty(), AimPenalty, GetMaxAimPenalty()) / 100.0f;
}

function SetTriggerOnMove(bool TriggerOnMove)
{
	TRIGGER_ON_MOVE = TriggerOnMove;
}

function SetTriggerOnAttack(bool TriggerOnAttack)
{
	TRIGGER_ON_ATTACK = TriggerOnAttack;
}

function SetTriggerOnMoveAway(bool TriggerOnMoveAway)
{
	TRIGGER_ON_MOVE_AWAY = TriggerOnMoveAway;
}

function SetAttackRange(int AttackRange)
{
	ATTACK_RANGE = Clamp(GetMinAttackRange(), AttackRange, GetMaxAttackRange());
}
