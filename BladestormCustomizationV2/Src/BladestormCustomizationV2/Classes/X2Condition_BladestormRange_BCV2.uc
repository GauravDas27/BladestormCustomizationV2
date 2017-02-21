class X2Condition_BladestormRange_BCV2 extends X2Condition;

function name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local XComGameState_Unit Source;
    local XComGameState_Unit Target;
    local int Tiles;
	local int MaxRange;

    Source = XComGameState_Unit(kSource);
    Target = XComGameState_Unit(kTarget);
    Tiles = Source.TileDistanceBetween(Target);
	MaxRange = class'Settings'.static.GetAttackRange();

    if (Tiles <= MaxRange)
    {
        return 'AA_Success';
    }
	else if (--Tiles == MaxRange && class'Settings'.static.IsTriggeredOnMoveAway())
	{
		return DoAdjacencyCheck(Source, Target, MaxRange);
	}
	return 'AA_NotInRange';
}

function name DoAdjacencyCheck(XComGameState_Unit Source, XComGameState_Unit Target, int MaxRange)
{
	local XComGameStateHistory History;
	local int Tiles;

	History = `XCOMHISTORY;
	Target = XComGameState_Unit(History.GetPreviousGameStateForObject(Target));
	Tiles = Source.TileDistanceBetween(Target);

    if (Tiles <= MaxRange)
    {
        return 'AA_Success';
    }
	return 'AA_NotInRange';
}
