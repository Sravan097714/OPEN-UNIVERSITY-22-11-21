report 50122 "List of Fixed AssetDisposal"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\ListofFixedAssetDisposal.rdl';
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'List of Fixed Asset Disposals';

    dataset
    {
        dataitem(FixedAsset; "Fixed Asset")
        {
            // DataItemTableView = sorting("No.") where("Write off" = const(true));
            DataItemTableView = sorting("No.");

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
            column(DisposalAmount; DisposalAmount)
            {




            }
            column(Reason_for_Write_Off; "Reason for Write Off")
            {

            }
            trigger OnAfterGetRecord()
            begin
                AcquisitionCost := 0;
                BookValue := 0;
                DisposalAmount := 0;
                DateOfPurchase := 0D;

                FADepriciationBook.SetRange("FA No.", "No.");
                if FADepriciationBook.Findlast() then begin
                    FADepriciationBook.CalcFields("Acquisition Cost", "Book Value");
                    AcquisitionCost := FADepriciationBook."Acquisition Cost";
                    BookValue := FADepriciationBook."Book Value";
                end;

                DateOfPurchase := "Date of Purchase";
                if DateOfPurchase = 0D then begin
                    FALedgerEntry.reset;
                    FALedgerEntry.SetRange("FA No.", "No.");
                    FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::"Acquisition Cost");
                    FALedgerEntry.SetRange(Reversed, false);
                    FALedgerEntry.SetCurrentKey("Posting Date", "Entry No.");
                    FALedgerEntry.SetAscending("Posting Date", false);
                    if FALedgerEntry.FindLast() then
                        DateOfPurchase := FALedgerEntry."Posting Date";
                end;

                FALedgerEntry.reset;
                FALedgerEntry.SetRange("FA No.", "No.");
                FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::"Proceeds on Disposal");
                // FALedgerEntry.SetRange(Reversed, false);
                // FALedgerEntry.SetCurrentKey("Posting Date", "Entry No.");
                // FALedgerEntry.SetAscending("Posting Date", false);
                if FALedgerEntry.Findlast() then
                    DisposalAmount := FALedgerEntry.Amount;
                if DisposalAmount = 0 then
                    CurrReport.Skip();


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
        ReportTitle: Label ' List of Fixed Asset Write Disposals';
        CompanyInfo: Record "Company Information";
        FADepriciationBook: Record "FA Depreciation Book";
        FALedgerEntry: record "FA Ledger Entry";
        AcquisitionCost: Decimal;
        DisposalAmount: decimal;
        BookValue: Decimal;
        DateOfPurchase: Date;
}