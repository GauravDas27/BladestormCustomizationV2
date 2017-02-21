class X2AmbientNarrativeCriteria_BCV2 extends X2AmbientNarrativeCriteria config(BladestormCustomizationV2Defaults);

var config bool MOD_DISABLED;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	local XComGameStateHistory History;
	local XComGameStateContext_StrategyGameRule StrategyStartContext;
	local XComGameState StartState;
	local XComGameState_CampaignSettings Settings;
	local int DifficultyIndex;

	if (default.MOD_DISABLED)
	{
		`log("BCV2: mod disabled");
		return Templates;
	}

	History = `XCOMHISTORY;

	StrategyStartContext = XComGameStateContext_StrategyGameRule(class'XComGameStateContext_StrategyGameRule'.static.CreateXComGameStateContext());
	StrategyStartContext.GameRuleType = eStrategyGameRule_StrategyGameStart;
	StartState = History.CreateNewGameState(false, StrategyStartContext);
	History.AddGameStateToHistory(StartState);

	Settings = new class'XComGameState_CampaignSettings';
	StartState.AddStateObject(Settings);

	for (DifficultyIndex = `MIN_DIFFICULTY_INDEX; DifficultyIndex <= `MAX_DIFFICULTY_INDEX; ++DifficultyIndex )
	{
		Settings.SetDifficulty(DifficultyIndex);

		ModifyBladestormAttack();
	}

	History.ResetHistory();

	return Templates;
}

static function ModifyBladestormAttack()
{
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate Template;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AbilityTemplateManager.FindAbilityTemplate('BladestormAttack');

	ModifyAttack(Template);
	ModifyTriggers(Template);
}

static function ModifyAttack(X2AbilityTemplate Template)
{
	local X2Ability_BCV2 Ability;
	local X2Condition_BladestormRange_BCV2 RangeCondition;
	local X2AbilityToHitCalc_BladestormAttack_BCV2 ToHitCalc;

	Ability = new class'X2Ability_BCV2';

	// recreate target conditions array with all standard attack target conditions
	Template.AbilityTargetConditions.Length = 0;
	AddStandardAttackTargetConditions(Template, Ability);

	// switch from melee to regular single target style and add range based condition
	Template.AbilityTargetStyle = Ability.GetSimpleSingleTarget();
	RangeCondition = new class'X2Condition_BladestormRange_BCV2';
	RangeCondition.CheckAdjacency = class'Settings'.default.TRIGGER_ON_MOVE_AWAY;
	RangeCondition.MaxRange = class'Settings'.default.ATTACK_RANGE;
	Template.AbilityTargetConditions.AddItem(RangeCondition);

	ToHitCalc = new class 'X2AbilityToHitCalc_BladestormAttack_BCV2';
	ToHitCalc.bReactionFire = class'Settings'.default.ATTACK_TYPE == 0;
	ToHitCalc.bAllowCrit = class'Settings'.default.ALLOW_CRIT;
	if (class'Settings'.default.ATTACK_TYPE == 0)
	{
		ToHitCalc.ReactionAimPenalty = class'Settings'.default.AIM_PENALTY;
		// add overwatch target condition for reaction attacks
		Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	}
	else if (class'Settings'.default.AIM_PENALTY != 0.0f)
	{
		// we do not set FinalMultiplier when penalty is 0.0f because we do not want user to see
		// a modifier of -0% if there was ever a way to see bladestorm attack hit chances
		ToHitCalc.FinalMultiplier = class'Settings'.default.AIM_PENALTY;
	}

	Template.AbilityToHitCalc = ToHitCalc;
}

static function ModifyTriggers(X2AbilityTemplate Template)
{
	local X2AbilityTrigger_Event Trigger;
	local X2AbilityTrigger_EventListener EventListener;

	Template.AbilityTriggers.Length = 0;
	if (class'Settings'.default.TRIGGER_ON_MOVE)
	{
		Trigger = new class'X2AbilityTrigger_Event';
		Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
		Trigger.MethodName = 'InterruptGameState';
		Template.AbilityTriggers.AddItem(Trigger);
		Trigger = new class'X2AbilityTrigger_Event';
		Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
		Trigger.MethodName = 'PostBuildGameState';
		Template.AbilityTriggers.AddItem(Trigger);
	}
	if (class'Settings'.default.TRIGGER_ON_ATTACK)
	{
		Trigger = new class'X2AbilityTrigger_Event';
		Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
		Trigger.MethodName = 'InterruptGameState';
		Template.AbilityTriggers.AddItem(Trigger);
	}

	// I couldn't figure out what this trigger does, but it's present in X2Ability_RangerAbilitySet.uc, so I am keeping it
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitConcealmentBroken';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'X2Ability_RangerAbilitySet'.static.BladestormConcealmentListener;
	EventListener.ListenerData.Priority = 55;
	Template.AbilityTriggers.AddItem(EventListener);
}

static function AddStandardAttackTargetConditions(X2AbilityTemplate Template, X2Ability_BCV2 Ability)
{
	// all TargetConditions except overwatch condition; copied straight from X2Ability_RangerAbilitySet.uc

	local X2Condition_Visibility TargetVisibilityCondition;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;

	Template.AbilityTargetConditions.AddItem(Ability.GetLivingHostileUnitDisallowMindControlProperty());

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BladestormTargetCondition.AddExcludeEffect('BladestormTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);
}
