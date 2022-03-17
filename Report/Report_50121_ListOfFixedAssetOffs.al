report 50121 "List of Fixed AssetOffs"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\ListofFixedAssetOff.rdl';
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'List of Fixed Asset Write Offs';


    dataset
    {
        dataitem(FixedAsset; "Fixed Asset")
        {
            DataItemTableView = sorting("No.") where("Write off" = const(true));
            RequestFilterFields = "No.", "FA Class Code";
            column(Report_Title; ReportTitle)
            {

            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {

            }
            column(No_; "No.")
            {

            }
            column(Description; Description)
            {

            }
            column(FA_Class_Code; "FA Class Code")
            {

            }
            column(DateOfPurchase; DateOfPurchase)
            {

            }
            column(Cost; AcquisitionCost)
            {

            }
            column(NBV; BookValue)
            {

            }
            column(Reason_for_Write_Off;
            "Reason for Write Off")
            {

            }
            trigger OnAfterGetRecord()
            begin
                AcquisitionCost := 0;
                BookValue := 0;
                DateOfPurchase := 0D;

                FADepriciationBook.SetRange("FA No.", "No.");
                if FADepriciationBook.Findlast() then begin
                    FADepriciationBook.CalcFields("Acquisition Cost", "Book Value");
                    AcquisitionCost := FADepriciationBook."Acquisition Cost";
                    BookValue := FADepriciationBook."Book Value";
                end;

                DateOfPurchase := "Date of Purchase";
                if DateOfPurchase = 0D then begin
                    FALedgerEntry.SetRange("FA No.", "No.");
                    FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::"Acquisition Cost");
                    FALedgerEntry.SetRange(Reversed, false);
                    FALedgerEntry.SetCurrentKey("Posting Date", "Entry No.");
                    FALedgerEntry.SetAscending("Posting Date", false);
                    if FALedgerEntry.FindLast() then
                        DateOfPurchase := FALedgerEntry."Posting Date";
                end;


            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
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
        ReportTitle: Label 'List of Fixed Asset Write Offs';
        CompanyInfo: Record "Company Information";
        FADepriciationBook: Record "FA Depreciation Book";
        FALedgerEntry: record "FA Ledger Entry";
        AcquisitionCost: Decimal;
        BookValue: Decimal;
        DateOfPurchase: Date;
}