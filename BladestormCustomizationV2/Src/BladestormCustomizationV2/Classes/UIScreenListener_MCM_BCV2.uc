class UIScreenListener_MCM_BCV2 extends UIScreenListener;

`include(BladestormCustomizationV2/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(BladestormCustomizationV2/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

var localized string PageTitle;
var localized string GroupDefaultLabel;

var localized string AttackTypeLabel;
var localized string AttackTypeTooltip;
var localized array<string> AttackTypeOptions;
var localized string AllowCritLabel;
var localized string AllowCritTooltip;
var localized string AimPenaltyLabel;
var localized string AimPenaltyTooltip;
var localized string TriggerOnMoveAwayLabel;
var localized string TriggerOnMoveAwayTooltip;
var localized string AttackRangeLabel;
var localized string AttackRangeTooltip;

var Settings Settings;

event OnInit(UIScreen Screen)
{
	// Everything out here runs on every UIScreen. Not great but necessary.
	if (MCM_API(Screen) != none)
	{
		// Everything in here runs only when you need to touch MCM.
		`MCM_API_Register(Screen, ClientModCallback);
	}
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	local MCM_API_SettingsPage Page;
	local MCM_API_SettingsGroup GroupDefault;

	LoadSettings();

	Page = ConfigAPI.NewSettingsPage(PageTitle);
	Page.SetPageTitle(PageTitle);
	Page.SetSaveHandler(SaveSettings);

	GroupDefault = Page.AddGroup('GroupDefault', GroupDefaultLabel);
	GroupDefault.AddDropdown('AttackType', AttackTypeLabel, AttackTypeTooltip, AttackTypeOptions, AttackTypeOptions[Settings.GetAttackType()], AttackTypeSaveHandler);
	GroupDefault.AddCheckbox('AllowCrit', AllowCritLabel, AllowCritTooltip, Settings.IsCritAllowed(), AllowCritSaveHandler);
	GroupDefault.AddCheckbox('TriggerOnMoveAway', TriggerOnMoveAwayLabel, TriggerOnMoveAwayTooltip, Settings.isTriggeredOnMoveAway(), TriggerOnMoveAwaySaveHandler);
	GroupDefault.AddSlider('AttackRange', AttackRangeLabel, AttackRangeTooltip, Settings.GetMinAttackRange(), Settings.GetMaxAttackRange(), Settings.GetAttackRangeStep(), Settings.GetAttackRange(), AttackRangeSaveHandler);
	GroupDefault.AddSlider('AimPenalty', AimPenaltyLabel, AimPenaltyTooltip, Settings.GetMinAimPenalty(), Settings.GetMaxAimPenalty(), Settings.GetAimPenaltyStep(), Settings.GetAimPenalty(), AimPenaltySaveHandler);

	Page.ShowSettings();
}

function LoadSettings()
{
	Settings = new class'Settings';
}

simulated function SaveSettings(MCM_API_SettingsPage Page)
{
	Settings.Save();
}

simulated function AttackTypeSaveHandler(MCM_API_Setting Setting, string SettingValue)
{
	local string AttackTypeOption;
	local int Index;

	foreach AttackTypeOptions(AttackTypeOption, Index)
	{
		if (AttackTypeOption == SettingValue)
		{
			Settings.SetAttackType(Index);
		}
	}
}

simulated function AllowCritSaveHandler(MCM_API_Setting Setting, bool SettingValue)
{
	Settings.SetCritAllowed(SettingValue);
}

simulated function AimPenaltySaveHandler(MCM_API_Setting Setting, float SettingValue)
{
	Settings.SetAimPenalty(SettingValue);
}

simulated function TriggerOnMoveAwaySaveHandler(MCM_API_Setting Setting, bool SettingValue)
{
	Settings.SetTriggerOnMoveAway(SettingValue);
}

simulated function AttackRangeSaveHandler(MCM_API_Setting Setting, float SettingValue)
{
	Settings.SetAttackRange(SettingValue);
}

defaultproperties
{
	ScreenClass = none;
}
