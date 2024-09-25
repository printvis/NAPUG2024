tableextension 60100 "PUG OpenQuote" extends "PVS Quote Analysis"
{

    fields
    {
        field(60100; State; Code[20])
        {
            Caption = 'Sell-To State';
        }
    }
}

pageextension 60101 "PUGOpenQute" extends "PVS Open Quote Analysis"
{
    layout
    {
        addafter("Sell-To Name")
        {
            field(State; Rec.State)
            {
                ApplicationArea = all;
            }
        }
    }
}

codeunit 60100 PUFOpenQuote
{
    [EventSubscriber(ObjectType::Table, Database::"PVS Quote Analysis", 'OnBeforeInsertAnalysis', '', true, false)]
    local procedure OnBeforeInsertAnalysis(var in_Rec: Record "PVS Quote Analysis"; in_CaseRec: Record "PVS Case"; var IsHandled: Boolean);
    begin
        if in_CaseRec."Sell-to Country/Region Code" = 'US' then begin
            if in_CaseRec."Sell-To County" = '' then
                in_Rec.State := 'N/A'
            else
                in_Rec.State := in_CaseRec."Sell-To County";
        end else
            in_Rec.State := in_CaseRec."Sell-to Country/Region Code";

    end;
}

