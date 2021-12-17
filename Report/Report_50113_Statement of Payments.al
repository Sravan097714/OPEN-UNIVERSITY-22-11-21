report 50113 "Statement of Payments"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\StatementofPayments.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Vendor No.") where("Document Type" = const(Payment));
            CalcFields = "Original Amt. (LCY)";
            column(CompanyInfo_Name; CompanyInfo.Name)
            {

            }
            column(StartDate; format(StartDate))
            {

            }
            column(EndDate; format(EndDate))
            {

            }
            column(Vendor_No_; "Vendor No.")
            {

            }
            column(Vendor_Name; Vendor.Name)
            {

            }
            column(Vendor_Address; Vendor.Address + ',' + Vendor."Address 2")
            {

            }
            column(Vendor_BankAccno; Vendor."Bank Accout No.")
            {

            }
            column(Posting_Date; format("Posting Date"))
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(Original_Amt___LCY_; "Original Amt. (LCY)")
            {

            }
            column(DescriptionTxt; DescriptionTxt)
            {

            }
            column(PV_Number; "PV Number")
            {

            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.get();
                SetRange("Posting Date", StartDate, EndDate);
            end;

            trigger OnAfterGetRecord()
            var
                DetailedVenledgerEntry: Record "Detailed Vendor Ledg. Entry";
                PurchInvoiceLine: Record "Purch. Inv. Line";
                grecVendorLedgerEntry: Record "Vendor Ledger Entry";
            begin
                Clear(DescriptionTxt);
                Vendor.Get("Vendor No.");
                DetailedVenledgerEntry.Reset();
                DetailedVenledgerEntry.SetRange("Initial Document Type", DetailedVenledgerEntry."Initial Document Type"::Invoice);
                DetailedVenledgerEntry.SetRange("Entry Type", DetailedVenledgerEntry."Entry Type"::Application);
                DetailedVenledgerEntry.SetRange("Document No.", "Document No.");
                DetailedVenledgerEntry.SetRange("Vendor No.", "Vendor No.");
                if DetailedVenledgerEntry.FindSet() then
                    repeat
                        grecVendorLedgerEntry.Reset();
                        grecVendorLedgerEntry.SetRange("Entry No.", DetailedVenledgerEntry."Vendor Ledger Entry No.");
                        IF grecVendorLedgerEntry.FindFirst() then begin
                            PurchInvoiceLine.Reset();
                            PurchInvoiceLine.SetRange("Document No.", grecVendorLedgerEntry."Document No.");
                            PurchInvoiceLine.SetFilter("No.", '<>%1', '');
                            PurchInvoiceLine.SetFilter("Description 2", '<>%1', '');
                            if PurchInvoiceLine.FindFirst() then
                                DescriptionTxt := PurchInvoiceLine."Description 2";
                        end;
                    until DetailedVenledgerEntry.Next() = 0;
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
                    field("Start Date"; StartDate)
                    {
                        ApplicationArea = all;
                    }
                    field("End Date"; EndDate)
                    {
                        ApplicationArea = all;
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

    var
        myInt: Integer;
        StartDate: Date;
        EndDate: Date;
        CompanyInfo: Record "Company Information";
        Vendor: Record Vendor;
        DescriptionTxt: Text;
}