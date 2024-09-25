codeunit 60102 PUG_StatusChange
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Main", 'OnCaseBeforeStatusChange', '', true, true)]
    procedure OnCaseBeforeStatusChange(StatusCodeFromRec: Record "PVS Status Code"; StatusCodeToRec: Record "PVS Status Code"; var CaseRec: Record "PVS Case"; var IsHandled: Boolean)
    var
        JobCostingRec: Record "PVS Job Costing Entry";
    begin
        if StatusCodeToRec.Code <> 'INVOICE' then
            exit;

        JobCostingRec.SetRange(ID, CaseRec.ID);

        if JobCostingRec.IsEmpty then
            Error('Job Costing is missing!');

    end;


}
