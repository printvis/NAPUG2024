codeunit 60101 PUGCustomFormula
{

    trigger OnRun()
    begin
        SingleInstance.Get_Current_CalcUnitDetailRec(JobCalculationDetail); // Get the Current Calc. Detail record

        // only use this if needed - this can take performance if formula is called many times
        // SingleInstance.Get_CalcUnitDetailsRecTmp(JobCalculationDetailTemp); // Maybe get all the Calc. Detail records if needed
        // SingleInstance.Get_SheetRecTmp(JobSheetTemp); // Use this if you need information from the sheet
        // SingleInstance.Get_JobProcessTemp(JobProcessTemp); // Use this if you need information from the process
        // SingleInstance.Get_JobItemRecTmp(JobItemTemp);

        JobCalculationDetail."Qty. Calculated" := 0; // Clear the field to be calculated

        // If the same report is used for multible formulas:
        CalculateFormulaValue();

        SingleInstance.Set_Current_CalcUnitDetailRec(JobCalculationDetail); // Push back the result
    end;


    local procedure CalculateFormulaValue()
    var
        Job: Record "PVS Job";
        JobItem: Record "PVS Job Item";
        //          Item: Record Item;
        Quantity_Result: Decimal;
    begin
        if not Job.get(JobCalculationDetail.ID, JobCalculationDetail.Job, JobCalculationDetail.Version) then
            exit;

        JobItem.SetRange(ID, job.ID);
        JobItem.SetRange(Job, Job.Job);
        JobItem.SetRange(Version, job.Version);

        if JobItem.FindSet() then
            repeat
                Quantity_Result := Quantity_Result + (JobItem.Length * JobItem.Width * JobItem."No. Of Leaves" * Job.Quantity) / 1000;
            until JobItem.next = 0;


        JobCalculationDetail."Qty. Calculated" := Quantity_Result;


        // This will change the unit on the calc. line IF the unit on the user formula is set to "Custom"
        JobCalculationDetail.Unit := JobCalculationDetail.Unit::"Area";

        // This will change the item no. on the calc. line
        JobCalculationDetail."Item No." := Job."Item No.";

    end;

    var
        JobItemTemp: Record "PVS Job Item" temporary;
        JobSheetTemp: Record "PVS Job Sheet" temporary;
        JobProcessTemp: Record "PVS Job Process" temporary;
        JobCalculationDetail: Record "PVS Job Calculation Detail";
        JobCalculationDetailTemp: Record "PVS Job Calculation Detail" temporary;
        SingleInstance: Codeunit "PVS SingleInstance";

}
