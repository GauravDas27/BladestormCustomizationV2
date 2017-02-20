class X2Condition_BladestormRange_BCV2 extends X2Condition;

var bool CheckAdjacency;
var int MaxRange;

function name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local XComGameState_Unit Source;
    local XComGameState_Unit Target;
    local int Tiles;

    Source = XComGameState_Unit(kSource);
    Target = XComGameState_Unit(kTarget);
    Tiles = Source.TileDistanceBetween(Target);

    if (Tiles <= MaxRange)
    {
        return 'AA_Success';
    }
	else if (--Tiles == MaxRange && CheckAdjacency)
	{
		return DoAdjacencyCheck(Source, Target);
	}
	return 'AA_NotInRange';
}

function name DoAdjacencyCheck(XComGameState_Unit Source, XComGameState_Unit Target)
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

DefaultProperties
{
	CheckAdjacency = false;
	MaxRange = 1;
}
