pageextension 60100 "PUG Case Card" extends "PVS Case Card"
{
    ContextSensitiveHelpPage = 'about-printvis/printvis-user-group-meeting-cleveland-2024/';
    layout
    {

        addafter(WorkflowGroup)
        {
            group(Quantities)
            {
                Caption = 'Total Quantities';

                Field(QuoteQty; QuoteQuantity())
                {
                    Caption = 'Quotes';
                    ApplicationArea = All;
                }

                Field(OrderQty; OrderQuantity())
                {
                    Caption = 'Orders';
                    ApplicationArea = All;
                }
            }


            /*
                    modify(ECOLabelCode)
                    {
                        Visible = false;
                    }
                    modify(ProductConfigurationCode)
                    {
                        Visible = false;
                    }
                    modify(FinishedGoodsItemNo)
                    {
                        Visible = false;
                    }
                    moveafter(WebFrontEndCode; JobName)
                    moveafter(InvoiceNoControl; CreationTime)
                    modify(CreationTime)
                    {
                        Visible = true;
                    }
            */
        }

    }
    local procedure QuoteQuantity() qty: Integer
    var
        JobRec: Record "PVS Job";
    begin
        JobRec.SetRange(ID, rec.ID);
        JobRec.SetRange(Active, true);
        JobRec.SetRange("Quote Calculation", true);
        JobRec.LoadFields(Quantity);
        // JobRec.SetRange(Status,JobRec.Status::Quote);
        if JobRec.FindSet() then
            repeat
                qty := qty + JobRec.Quantity;
            until JobRec.next = 0;
    end;

    local procedure OrderQuantity() qty: Integer
    var
        JobRec: Record "PVS Job";
    begin
        JobRec.SetRange(ID, rec.ID);
        JobRec.SetRange(Active, true);
        JobRec.SetRange("Production Calculation", true);
        // JobRec.SetRange(Status,JobRec.Status::Quote);
        if JobRec.FindSet() then
            repeat
                qty := qty + JobRec.Quantity;
            until JobRec.next = 0;
    end;

}
