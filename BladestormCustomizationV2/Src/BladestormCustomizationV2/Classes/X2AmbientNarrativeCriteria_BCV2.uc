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
	// ModifyTriggers(Template);
}

static function ModifyAttack(X2AbilityTemplate Template)
{
	local X2Ability_BCV2 Ability;
	local X2Condition_BladestormRange_BCV2 RangeCondition;
	local X2Condition_ReactionExclusion_BCV2 ReactionCondition;
	local X2AbilityToHitCalc_BladestormAttack_BCV2 ToHitCalc;

	Ability = new class'X2Ability_BCV2';

	// recreate target conditions array with all standard attack target conditions
	Template.AbilityTargetConditions.Length = 0;
	AddStandardAttackTargetConditions(Template, Ability);

	// switch from melee to regular single target style and add range based condition
	Template.AbilityTargetStyle = Ability.GetSimpleSingleTarget();
	RangeCondition = new class'X2Condition_BladestormRange_BCV2';
	Template.AbilityTargetConditions.AddItem(RangeCondition);

	// add overwatch target condition for reaction attacks
	ReactionCondition = new class'X2Condition_ReactionExclusion_BCV2';
	ReactionCondition.OverwatchExclusion = class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition();
	Template.AbilityTargetConditions.AddItem(ReactionCondition);

	ToHitCalc = new class 'X2AbilityToHitCalc_BladestormAttack_BCV2';
	Template.AbilityToHitCalc = ToHitCalc;
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
