//Inventory Obsolescence Report
/// <summary>
/// Report Inventory Obsolescence Report (ID 50124).
/// </summary>
report 50125 "Inventory Dormant Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\InventoryDormant.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code";
            DataItemTableView = sorting("No.") where("Dormant Period" = filter(<> ''));
            column(CompanyInfo_Name; CompanyInfo.Name) { }
            column(PeriodText; PeriodText) { }
            column(ItemCodeLBL; ItemCodeLBL) { }
            column(No_; "No.") { }
            column(DescriptionLBl; DescriptionLBl) { }
            column(Description; Description) { }
            column(QuantityOnHandLBL; QuantityOnHandLBL) { }
            column(Inventory; Inventory) { }
            column(BaseUnitMeasureLBL; BaseUnitMeasureLBL) { }
            column(Base_Unit_of_Measure; "Base Unit of Measure") { }
            column(UnitCostLbl; UnitCostLbl) { }
            column(Unit_Cost; "Unit Cost") { }
            column(LastTransactionPostingDateLBL; LastTransactionPostingDateLBL) { }
            column(LastTransactionPostingdate; LastTransactionPostingdate) { }
            column(LastTransactionEntryTypeLBL; LastTransactionEntryTypeLBL) { }

            column(LastTransactionEntryType; LastTransactionEntryType) { }
            column(LastTransactionDocumentNoLBL; LastTransactionDocumentNoLBL) { }
            column(LastTransactionDocumentNo; LastTransactionDocumentNo) { }

            trigger OnAfterGetRecord()
            begin
                clear(LastTransactionPostingdate);
                clear(LastTransactionEntryType);
                clear(LastTransactionDocumentNo);

                ItemLedgerEntryRec.Reset();
                ItemLedgerEntryRec.SetCurrentKey("Entry No.");
                ItemLedgerEntryRec.SetAscending("Entry No.", false);
                ItemLedgerEntryRec.SetRange("Item no.", "No.");
                if ItemLedgerEntryRec.FindLast() then begin
                    LastTransactionDocumentNo := ItemLedgerEntryRec."Document No.";
                    LastTransactionEntryType := Format(ItemLedgerEntryRec."Entry Type");
                    LastTransactionPostingdate := ItemLedgerEntryRec."Posting Date";
                end;

            end;

            trigger OnPreDataItem()
            begin
                setrange("Dormant Period", DormantPeriod);
            end;

        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group("")
                {
                    field("Dormant Period"; DormantPeriod)
                    {
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            Periodtext := FnGetDateFormulaDescription(DormantPeriod)
                        end;

                    }
                }
            }
        }


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        myInt: Integer;
        DormantPeriod: DateFormula;
        CompanyInfo: Record "Company Information";
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        ItemCodeLBL: Label 'Item Code';
        DescriptionLBl: Label 'Description';
        QuantityOnHandLBL: Label 'Quantity on hand(Inventory)';
        BaseUnitMeasureLBL: Label 'Base Unit of Measure';
        UnitCostLbl: label 'Unit Cost';
        LastTransactionPostingDateLBL: Label 'Last Transaction Posting date';
        LastTransactionEntryTypeLBL: Label 'Last Transaction Entry Type';
        LastTransactionDocumentNoLBL: Label 'Last Transaction Document No';

        LastTransactionPostingdate: Date;
        LastTransactionEntryType: Text;
        LastTransactionDocumentNo: Text;
        PeriodText: text;


    Procedure FnGetDateFormulaDescription(DF: DateFormula): Text
    var
        ODF: DateFormula;
        Projected: Date;
        NoOfDays: Integer;
        Period: Text;
        NewString: Text;
        CurrDf: DateFormula;
        Pos: Integer;
        Length: Integer;
        LastString: Integer;
        NewPeriod: Text;
        PeriodFinal: text;
        lengthofText: Integer;
    begin
        IF DF = ODF THEN
            EXIT;

        CurrDf := ODF;

        Period := '';
        NewString := FORMAT(DF);
        Length := STRLEN(NewString);
        LastString := Length - 1;
        Pos := STRPOS(NewString, '+');

        WHILE Pos <> 0 DO BEGIN
            EVALUATE(CurrDf, COPYSTR(NewString, 1, Pos - 1));
            Period += FnGetFormulaDescription(CurrDf);

            NewString := COPYSTR(NewString, Pos + 1);
            Pos := STRPOS(NewString, '+');
        END;

        EVALUATE(CurrDf, COPYSTR(NewString, 1));
        Period := FnGetFormulaDescription(CurrDf);
        lengthofText := STRLEN(Period);

        Evaluate(NewPeriod, CopyStr(NewString, 1, LastString));
        if NewPeriod = '1' then
            PeriodFinal := NewPeriod + copystr(FnGetFormulaDescriptionSingle(CurrDf), 2, lengthofText - 1)
        else
            PeriodFinal := NewPeriod + copystr(FnGetFormulaDescription(CurrDf), 2, lengthofText - 1);

        EXIT(PeriodFinal);
    END;

    //where period is more than 1 i.e 2 days 2 months , 2 years
    LOCAL procedure FnGetFormulaDescription(DF: DateFormula): Text

    var
        DFStr: Text;
    Begin
        DFStr := FORMAT(DF);

        IF STRPOS(DFStr, 'D') <> 0 THEN
            EXIT(COPYSTR(DFStr, 1, 1) + ' Days ');
        if StrPos(DFStr, 'W') <> 0 then
            exit(COPYSTR(DFStr, 1, 1) + ' Weeks ');

        IF STRPOS(DFStr, 'M') <> 0 THEN
            EXIT(COPYSTR(DFStr, 1, 1) + ' Months ');

        IF STRPOS(DFStr, 'Q') <> 0 THEN
            EXIT(COPYSTR(DFStr, 1, 1) + ' Quarters ');

        IF STRPOS(DFStr, 'Y') <> 0 THEN
            EXIT(COPYSTR(DFStr, 1, 1) + ' Years ');

        IF STRPOS(DFStr, 'CM') <> 0 THEN
            EXIT(COPYSTR(DFStr, 1, 1) + ' Current Month ');

    End;

    //where period is a Single  i.e 1 day 1 month , 1 year
    LOCAL procedure FnGetFormulaDescriptionSingle(DF: DateFormula): Text

    var
        DFStr: Text;
    Begin
        DFStr := FORMAT(DF);

        IF STRPOS(DFStr, 'D') <> 0 THEN
            EXIT(COPYSTR(DFStr, 1, 1) + ' Day ');
        if StrPos(DFStr, 'W') <> 0 then
            exit(COPYSTR(DFStr, 1, 1) + ' Week ');

        IF STRPOS(DFStr, 'M') <> 0 THEN
            EXIT(COPYSTR(DFStr, 1, 1) + ' Month ');

        IF STRPOS(DFStr, 'Q') <> 0 THEN
            EXIT(COPYSTR(DFStr, 1, 1) + ' Quarter ');

        IF STRPOS(DFStr, 'Y') <> 0 THEN
            EXIT(COPYSTR(DFStr, 1, 1) + ' Year ');

        IF STRPOS(DFStr, 'CM') <> 0 THEN
            EXIT(COPYSTR(DFStr, 1, 1) + ' Current Month ');

    End;

}