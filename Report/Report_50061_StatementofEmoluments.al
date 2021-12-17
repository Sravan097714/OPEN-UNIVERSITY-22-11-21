report 50061 "Statement Emoluments Finance"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Statement of Emoluments Finance';
    RDLCLayout = 'Report\Layout\Emoluments.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Vendor No.", "Posting Date", "Currency Code") where("Document Type" = filter(Invoice));
            column(gdateStartDate; format(gdateStartDate)) { }
            column(gdateEndDate; format(gdateEndDate)) { }

            column(CompanyName; grecCompanyInfo."Payer Name") { }
            column(CompanyBRN; grecCompanyInfo."Employer Registration No.") { }

            column(gtextNID; gtextNID) { }
            column(gtextVendorName; gtextVendorName) { }
            column(gtextVendorAddress; gtextVendorAddress) { }

            column(gdecEmolument; gdecEmolument) { }
            column(gdecPAYEAmt; gdecPAYEAmt) { }

            column(Sign; CompanyInfo."Name Of Declarant") { }

            trigger OnPreDataItem()
            begin
                if gcodeVendor <> '' then
                    SetRange("Vendor No.", gcodeVendor);
                SetRange("Posting Date", gdateStartDate, gdateEndDate);
                CompanyInfo.Get();
            end;

            trigger OnAfterGetRecord()
            var
                PurchasePaybleSetup: Record "Purchases & Payables Setup";
            begin
                if grecVendor2.get("Vendor No.") then begin
                    if grecVendor2."Vendor Category" <> 'TUTOR' then
                        CurrReport.Skip();
                end;
                PurchasePaybleSetup.Get();
                if gtextVendor <> "Vendor No." then begin
                    clear(gtextNID);
                    clear(gtextVendorName);
                    Clear(gtextVendorAddress);
                    if grecVendor.get("Vendor No.") then begin
                        gtextNID := grecVendor.NID;
                        gtextVendorName := grecVendor.Name;
                        gtextVendorAddress := grecVendor.Address;
                    end;

                    Clear(gdecEmolument);
                    Clear(gdecPAYEAmt);
                    grecVendLedgerEntry.Reset();
                    grecVendLedgerEntry.SetCurrentKey("Entry No.");
                    grecVendLedgerEntry.SetRange("Document Type", grecVendLedgerEntry."Document Type"::Invoice);
                    grecVendLedgerEntry.SetRange("Posting Date", gdateStartDate, gdateEndDate);
                    grecVendLedgerEntry.SetRange("Vendor No.", "Vendor No.");
                    if grecVendLedgerEntry.FindSet then begin
                        repeat
                            grecPurchInvLine.Reset();
                            grecPurchInvLine.SetRange("Document No.", grecVendLedgerEntry."Document No.");
                            grecPurchInvLine.SetFilter(Amount, '>%1', 0);
                            if (gdateStartDate <> 0D) and (gdateEndDate <> 0D) then
                                grecPurchInvLine.SetRange("Posting Date", gdateStartDate, gdateEndDate);
                            if grecPurchInvLine.FindSet() then
                                repeat
                                    if grecPurchInvLine.VAT then
                                        gdecEmolument += grecPurchInvLine."Line Amount Excluding VAT"
                                    else
                                        gdecEmolument += Abs(Round(grecPurchInvLine."Line Amount", 1, '='));
                                until grecPurchInvLine.Next() = 0;

                            grecPurchInvLine.Reset();
                            grecPurchInvLine.SetRange("Document No.", grecVendLedgerEntry."Document No.");
                            grecPurchInvLine.SetRange(PAYE, true);
                            grecPurchInvLine.SetRange(Type, grecPurchInvLine.Type::"G/L Account");
                            grecPurchInvLine.SetRange("No.", PurchasePaybleSetup."PAYE Claims");
                            if (gdateStartDate <> 0D) and (gdateEndDate <> 0D) then
                                grecPurchInvLine.SetRange("Posting Date", gdateStartDate, gdateEndDate);
                            if grecPurchInvLine.FindSet() then begin
                                grecPurchInvLine.CalcSums(grecPurchInvLine."Line Amount");
                                gdecPAYEAmt += Abs(Round(grecPurchInvLine."Line Amount", 1, '='));
                            end;
                        until grecVendLedgerEntry.Next = 0;
                    end;
                    gtextVendor := "Vendor No.";
                end else
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
                group("Date Filter")
                {
                    field("Start Date"; gdateStartDate) { ApplicationArea = All; }
                    field("End Date"; gdateEndDate) { ApplicationArea = All; }
                    field("Vendor No."; gcodeVendor)
                    {
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            Clear(gpageVendor);
                            grecVendor3.Reset();
                            grecVendor3.SetRange("Vendor Category", 'TUTOR');
                            if grecVendor3.FindFirst() then begin
                                gpageVendor.SetRecord(grecVendor3);
                                gpageVendor.SetTableView(grecVendor3);
                                gpageVendor.LookupMode(true);
                                if gpageVendor.RunModal() = Action::LookupOK then begin
                                    gpageVendor.GetRecord(grecVendor3);
                                    gcodeVendor := grecVendor3."No.";
                                end;
                            end;
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if (gdateStartDate = 0D) or (gdateEndDate = 0D) then
            Error('Both dates should be filled in.');

        if gdateStartDate > gdateEndDate then
            Error('Start Date cannot be greater than End Date.');

        grecCompanyInfo.get;
        grecPurchPayableSetup.Get;
    end;

    var
        gtextVendor: Text;
        gtextVendorAddress: Text;
        gtextNID: text;
        grecCompanyInfo: Record "Company Information";
        gdateStartDate: Date;
        gdateEndDate: Date;
        grecVendor: Record Vendor;
        gtextVendorName: Text;
        grecVendLedgerEntry: Record "Vendor Ledger Entry";
        gdecEmolument: Decimal;
        grecGLEntry: Record "G/L Entry";
        gdecPAYEAmt: Decimal;
        grecPurchPayableSetup: Record "Purchases & Payables Setup";
        grecDetailedVendLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        grecDetailedVendLedgerEntry2: Record "Detailed Vendor Ledg. Entry";
        grecVendLedgerEntry2: Record "Vendor Ledger Entry";
        grecPurchInvLine: Record "Purch. Inv. Line";
        grecVendor2: Record Vendor;
        gcodeVendor: Code[20];
        grecVendor3: Record Vendor;
        gpageVendor: Page "Vendor List";
        CompanyInfo: Record "Company Information";
}