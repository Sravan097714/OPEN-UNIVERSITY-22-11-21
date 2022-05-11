/// <summary>
/// Report Cancelled Payment Listing (ID 50120).
/// </summary>
report 50120 "Cancelled Payment Listing"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\CancelledPaymentListing.rdl';
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {

            DataItemTableView = sorting("Entry No.") where(reversed = const(true), "source code" = const('PAYMENTJNL'));
            column(Report_Title; ReportTitle)
            {

            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {

            }
            column(StartDate; StrSubstNo(format(StartDate)))
            {

            }
            column(EndDate; StrSubstNo('..%1', format(EndDate)))
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(PV_Number; "PV Number")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Amount; Amount) { }
            column(reason; ReasonTxt)
            {

            }
            column(PayeeName; PayeeName)
            {

            }
            column(Record_Count; StrSubstNo(RecordCount, NoOfRec))
            {

            }
            trigger OnPreDataItem()
            begin
                SetFilter("Posting Date", '%1..%2', StartDate, EndDate);

            end;

            trigger OnAfterGetRecord()
            begin
                Clear(PayeeName);
                Clear(ReasonTxt);
                if VendorRec.get("Bal. Account No.") then
                    PayeeName := VendorRec.Name;

                GlEntries.SetRange("Document No.", "Document No.");
                GlEntries.SetFilter(Reason, '<>%1', '');
                if GlEntries.FindFirst() then
                    ReasonTxt := GlEntries.Reason;

                BankLedgerEntry.CopyFilters("Bank Account Ledger Entry");
                NoOfRec := BankLedgerEntry.Count;


            end;

            trigger OnPostDataItem()
            begin

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
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;

                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;

                    }
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
        ReportTitle: Label 'Cancelled Payment Listing';
        CompanyInfo: Record "Company Information";
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        GlEntries: Record "G/L Entry";
        ReasonTxt: Text;
        VendorRec: Record Vendor;
        StartDate: Date;
        EndDate: Date;
        PayeeName: Text;
        NoOfRec: Integer;
        RecordCount: Label 'Record Count: …………… %1';

}