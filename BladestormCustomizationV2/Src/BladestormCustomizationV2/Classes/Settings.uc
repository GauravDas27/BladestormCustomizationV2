class Settings extends Settings_Defaults config(BladestormCustomizationV2);

function Save()
{
	default.ATTACK_TYPE = ATTACK_TYPE;
	default.ALLOW_CRIT = ALLOW_CRIT;
	default.AIM_PENALTY = AIM_PENALTY;
	default.TRIGGER_ON_MOVE_AWAY = TRIGGER_ON_MOVE_AWAY;
	default.ATTACK_RANGE = ATTACK_RANGE;

	StaticSaveConfig();
}

//getters

static function bool IsReactionAttack()
{
	return GetAttackType() == 0;
}

static function int GetAttackType()
{
	return Clamp(0, default.ATTACK_TYPE, 1);
}

static function bool IsCritAllowed()
{
	return default.ALLOW_CRIT;
}

static function float GetMinAimPenalty()
{
	return 0.0f;
}

static function float GetMaxAimPenalty()
{
	return 100.0f;
}

static function float GetAimPenaltyStep()
{
	return 1.0f;
}

static function float GetAimPenaltyDecimal()
{
	return FClamp(0.0f, default.AIM_PENALTY, 1.0f);
}

static function float GetAimPenalty()
{
	return FClamp(GetMinAimPenalty(), default.AIM_PENALTY * GetMaxAimPenalty(), GetMaxAimPenalty());
}

static function bool IsTriggeredOnMoveAway()
{
	return default.TRIGGER_ON_MOVE_AWAY;
}

static function int GetMinAttackRange()
{
	return 1;
}

static function int GetMaxAttackRange()
{
	return 12;
}

static function int GetAttackRangeStep()
{
	return 1;
}

static function int GetAttackRange()
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
	AIM_PENALTY = FClamp(0.0f, AimPenalty / GetMaxAimPenalty(), 1.0f);
}

function SetTriggerOnMoveAway(bool TriggerOnMoveAway)
{
	TRIGGER_ON_MOVE_AWAY = TriggerOnMoveAway;
}

function SetAttackRange(int AttackRange)
{
	ATTACK_RANGE = Clamp(GetMinAttackRange(), AttackRange, GetMaxAttackRange());
}
