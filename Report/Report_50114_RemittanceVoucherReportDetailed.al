report 50114 "Remittance Voucher Detailed"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\RemittanceVoucherDetailed.rdl';

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = where("Source Code" = filter('PAYMENTJNL'));
            CalcFields = "Original Amt. (LCY)";
            column(CompanyName; grecCompanyInfo.Name) { }
            column(CompanyAddress; grecCompanyInfo.Address) { }
            column(CompanyPhone; grecCompanyInfo."Phone No.") { }
            column(Posting_Date; format("Posting Date")) { }
            column(PV_Number; "PV Number") { }
            column(Vendor_Name; gtextVendorName) { }
            column(gtextAddress; gtextAddress) { }
            column(Original_Amt___LCY_; "Original Amt. (LCY)") { }
            column(gtextVendBankAcc; gtextVendBankAcc) { }
            column(gtextVendBank; gtextVendBank) { }
            column(vendorbankacc; vendorbankacc) { }
            column(vendorbank; vendorbank) { }
            column(Description; Description) { }
            column(gintEntryNo; gintEntryNo) { }
            column(Entry_No_; "Entry No.") { }
            column(Payment_Journal_No_; "Payment Journal No.") { }


            dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Document No." = field("Document No.");
                DataItemTableView = where("Initial Document Type" = filter('Payment'), "Entry Type" = filter('Application'));

                dataitem(DetailedVendorLedgEntry2; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Applied Vend. Ledger Entry No." = field("Applied Vend. Ledger Entry No.");
                    DataItemTableView = where("Initial Document Type" = filter('Invoice'));

                    dataitem(VendorLedgerEntry2; "Vendor Ledger Entry")
                    {
                        DataItemLink = "Entry No." = field("Vendor Ledger Entry No.");

                        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
                        {
                            DataItemLink = "Document No." = field("Document No.");
                            column(Document_No_; "Document No.") { }
                            column(Line_No_; "Line No.") { }
                            column(Description1; DescriptionVar) { }
                            column(PAYE1; "Line Amount") { }
                            column(gvendorinvno; gvendorinvno) { }

                            trigger OnAfterGetRecord()
                            var
                                PurchInvHeaderLRec: Record "Purch. Inv. Header";
                            begin
                                if "Description 2" <> '' then
                                    DescriptionVar := "Description 2"
                                else
                                    DescriptionVar := Description;


                                PurchInvHeaderLRec.Reset();
                                Clear(gvendorinvno);
                                PurchInvHeaderLRec.SetRange("No.", "Document No.");
                                if PurchInvHeaderLRec.FindFirst then
                                    gvendorinvno := PurchInvHeaderLRec."Vendor Invoice No.";
                            end;

                        }

                    }
                }

            }

            trigger OnAfterGetRecord()
            var
                VendLedEntry: Record "Vendor Ledger Entry";
                PurchInvLineLRec: Record "Purch. Inv. Line";

            begin

                Clear(gtextAddress);
                if grecVendor.get("Vendor No.") then begin
                    gtextVendorName := grecVendor.Name;
                    gtextAddress := grecVendor.Address + ' ' + grecVendor."Address 2";
                end;


                Clear(vendorbankacc);
                Clear(vendorbank);
                grecVendor.Reset();
                grecVendor.SetRange("No.", "Vendor No.");
                if grecVendor.FindFirst then begin
                    vendorbank := grecVendor."Bank Name";
                    vendorbankacc := grecVendor."Bank Accout No."
                end;
                VendLedEntry.Reset();
                VendLedEntry.SetRange("Closed by Entry No.", "Vendor Ledger Entry"."Entry No.");
                if VendLedEntry.FindFirst() then begin
                    PurchInvLineLRec.Reset();
                    PurchInvLineLRec.SetRange("Document No.", VendLedEntry."Document No.");

                end;


            end;

            trigger OnPreDataItem()
            begin
                if EntryNoGlobal <> 0 then
                    SetRange("Entry No.", EntryNoGlobal);
            end;

        }
    }


    trigger OnPreReport()
    begin
        grecCompanyInfo.get;
        gintEntryNo := 0;
    end;

    var
        grecCompanyInfo: Record "Company Information";
        grecVendor: Record Vendor;
        gtextAddress: Text;
        grecVendorBankAccount: Record 288;
        gtextVendBankAcc: Text;
        vendorbankacc: Text;
        vendorbank: Text;
        gtextVendBank: Text;
        gintEntryNo: Integer;
        gtextVendorName: Text;
        gtextDescription: Text;
        gdecTotal: Decimal;
        gdecAmount: Decimal;

        grecPurchInvLine: Record "Purch. Inv. Line";
        gdecTDSAmt: Decimal;
        DescriptionVar: Text;
        gvendorinvno: Text;

        EntryNoGlobal: Integer;

    procedure Setfilter(EntryNo: Integer)
    begin
        EntryNoGlobal := EntryNo;
    end;
}