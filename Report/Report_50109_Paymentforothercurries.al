report 50109 "Payment through Bank Trans. OC"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\Bank Transfer Report_vendor2OC.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Payment through Bank Transfer for other Currency';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = sorting("No.") where("Source Code" = filter('PAYMENTJNL'));
            //RequestFilterFields = "No.";
            column(gtextTypeofTransfer; gtextTypeofTransfer) { }
            column(gdatePaymentDate; format(gdatePaymentDate)) { }
            column(gtextPurposeofTransfer; gtextPurposeofTransfer) { }
            column(gtextMonth; gtextMonth) { }
            column(gdecCreditAmt; gdecCreditAmt) { }
            column(gintTransacNo; gintTransacNo) { }
            column(OurRefNo; OurRefNo) { }
            column(BankName; gtextBank) { }
            column(BankAccNo; BankAccount."Bank Account No.") { }

            column(Chairman; grecPurchPayableSetup."Bulk Bank Transfer – Chaiman") { }
            column(DirectorGeneral; grecPurchPayableSetup."Bank Trans – Director General") { }
            column(Enc; grecPurchPayableSetup."Bulk Bank Transfer – enc.") { }

            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                RequestFilterFields = "Document No.";
                column(Vendor_No_; "Vendor No.") { }
                column(Vendor_Name; Vendor.Name) { }
                column(Vendor_BankAccno; Vendor."Bank Accout No.") { }
                column(Vendor_BankName; Vendor."Bank Name") { }
                column(Vendor_BankAddress; Vendor."Bank Address") { }
                column(Vendor_SwiftCode; Vendor."SWIFT Code") { }
                column(Vendor_BranchCode; Vendor."BRANCH CODE") { }
                column(Vendor_IFSCCode; Vendor."IFSC CODE") { }
                column(Vendor_TelePhoneNo; Vendor."Telephone Number") { }
                column(BankLetterFor; BankLetterFor) { }
                column(CompanyInfo_Picture; CompanyInfo.Picture) { }
                column(CompanyInfo_PayerName; CompanyInfo."Payer Name") { }
                column(CompanyInfo_TelephoneNo; CompanyInfo."Telephone Number") { }
                column(PostingDate; "Posting Date") { }
                column(CurrencyCode; CurrCode) { }
                column(CurrentAccNo; Description) { }
                column(VendorAccNo; VendorAccNo) { }

                column(NoText; TextInWords[1]) { }
                column(Amt; Amt) { }
                column(AmountLCY; AmountLCY) { }

                trigger OnAfterGetRecord()
                var
                    DetailedVenledgerEntry: Record "Detailed Vendor Ledg. Entry";
                    PurchInvoiceHeader: Record "Purch. Inv. Header";
                begin
                    Vendor.Get("Vendor No.");
                    if BankAccount.Get("Bal. Account No.") then bankaccnum := BankAccount."Bank Account No.";
                    Clear(sumamount);
                    Clear(CurrCode);
                    Clear(AmountLCY);
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
                                PurchInvoiceHeader.Reset();
                                PurchInvoiceHeader.SetRange("No.", grecVendorLedgerEntry."Document No.");
                                if PurchInvoiceHeader.FindFirst() then
                                    if PurchInvoiceHeader."Currency Code" <> '' then begin
                                        PurchInvoiceHeader.CalcFields(Amount);
                                        CurrCode := PurchInvoiceHeader."Currency Code";
                                        if ABS(DetailedVenledgerEntry.Amount) = PurchInvoiceHeader.Amount then begin
                                            sumamount += PurchInvoiceHeader.Amount;
                                            AmountLCY += Abs(PurchInvoiceHeader.Amount / PurchInvoiceHeader."Currency Factor");
                                        end else begin
                                            sumamount += Abs(DetailedVenledgerEntry."Amount (LCY)") * PurchInvoiceHeader."Currency Factor";
                                            AmountLCY += Abs(DetailedVenledgerEntry."Amount (LCY)");
                                        end;

                                    end;
                            end;
                        until DetailedVenledgerEntry.Next() = 0;
                    if sumamount = 0 then
                        CurrReport.Skip();
                    Amt := ROUND(sumamount, 0.01);
                    AmountLCY := ROUND(AmountLCY, 0.01);
                    Check.InitTextVariable;
                    Check.FormatNoText(TextInWords, AmountLCY, '');


                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                    CompanyInfo.GET();

                    BankAccount.Reset();
                    BankAccount.SetRange(Name, gtextBank);
                    if BankAccount.FindFirst() then;

                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange("No.", gintGLRegisterNo);
            end;
        }
    }



    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field("G/L Register No."; gintGLRegisterNo)
                    {
                        ApplicationArea = All;
                        TableRelation = "G/L Register"."No." where("Source Code" = filter('PAYMENTJNL'));
                    }
                    field(Month; gtextMonth) { ApplicationArea = All; }
                    field(Bank; gtextBank)
                    {
                        //TableRelation = "Bank Account";
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            grecBankAccount: Record "Bank Account";
                            gpageBankAccList: Page "Bank Account List";
                        begin
                            grecBankAccount.Reset();
                            grecBankAccount.SetRange("No.");
                            if grecBankAccount.FindFirst() then begin
                                gpageBankAccList.SetRecord(grecBankAccount);
                                gpageBankAccList.SetTableView(grecBankAccount);
                                gpageBankAccList.LookupMode(true);
                                if gpageBankAccList.RunModal() = action::LookupOK then begin
                                    gpageBankAccList.GetRecord(grecBankAccount);
                                    gtextBank := grecBankAccount.Name;
                                end;
                            end;
                            gtextBank := grecBankAccount.Name;
                        end;
                    }
                    field("Type of Transfer"; gtextTypeofTransfer) { ApplicationArea = All; }
                    field("Payment Date"; gdatePaymentDate) { ApplicationArea = All; }
                    field("Purpose of Transfer"; gtextPurposeofTransfer) { ApplicationArea = All; }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        grecPurchPayableSetup.Get;

        /*
        IF CompanyInfo.Print1 THEN BEGIN
          Signature[1] := CompanyInfo."E-mail Payer";
          Signature[3] := CompanyInfo."Bank Letter Sign Title";
        END;

        IF CompanyInfo.Print2 THEN BEGIN
          IF (Signature[1] = '') THEN BEGIN
            Signature[1] := CompanyInfo."Bank Letter Sign 1";
            Signature[3] := CompanyInfo."Bank Letter Sign 1 Title";
          END ELSE BEGIN
            Signature[2] := CompanyInfo."Bank Letter Sign 1";
            Signature[4] := CompanyInfo."Bank Letter Sign 1 Title";
          END;
        END;

        IF CompanyInfo.Print3 THEN BEGIN
          IF Signature[1] = '' THEN BEGIN
            Signature[1] := CompanyInfo."Business Registration No.";
            Signature[3] := CompanyInfo."Bank Address";
          END ELSE BEGIN
            Signature[2] := CompanyInfo."Business Registration No.";
            Signature[4] := CompanyInfo."Bank Address";
          END;
        END;

        IF CompanyInfo.Print4 THEN BEGIN
          Signature[2] := CompanyInfo."Bank Address 2";
          Signature[4] := CompanyInfo."Bank City";
        END;
        */
    end;

    var
        BankAccount: Record 270;
        CheckBase: Report 1401;
        //TextInWords: array[2] of Text;
        Amt: Decimal;
        CompanyInfo: Record 79;
        BankAccName: Text[250];
        Vendor: Record 23;
        CurrentAccNo: Text[250];
        BankLetterFor: Text[250];
        VendorAccNo: Text[250];
        PostingDateCaption: Label 'Posting Date';
        DocNoCaption: Label 'Document No.';
        DocTypeCaption: Label 'Document Type';
        DescCaption: Label 'Description';
        AmtCaption: Label 'Amount';
        OurRefNo: Label 'OU/F/3/1.1';
        Language: Record 8;
        Vendor2: Record 23;
        CurrCode: Text;
        VendorBankAccount: Record 288;
        VendorSwiftCode: Text[250];
        VendorIBAN: Text[250];
        BankSwiftCode: Text[250];
        BankIBAN: Text[250];
        GenJnlLine: Record 81;
        Comment: Text[250];
        Signature: array[4] of Text;


        gintGLRegisterNo: Integer;
        gtextMonth: Text[15];
        gtextBank: Text;
        gtextTypeofTransfer: Text[50];
        gdatePaymentDate: Date;
        gtextPurposeofTransfer: Text[50];
        grecVendorLedgerEntry: Record "Vendor Ledger Entry";
        gdecCreditAmt: Decimal;
        gintTransacNo: Integer;

        grecVendorBankAcc: Record "Vendor Bank Account";
        gtextBeneficiaryAccNo: Text;
        gtextBankCode: Text;
        grecVendor: Record Vendor;

        grecPurchPayableSetup: Record "Purchases & Payables Setup";
        bankaccnum: Text;
        CheckAmountText: Text[30];
        Check: Report 50021;
        TextInWords: array[2] of Text;
        AmountLCY: Decimal;
        sumamount: Decimal;
        Transfer_Lbl: Label 'APPLICATION FORM FOR FUNDS TRANSFER /BANK DRAFT';
        Date_LBl: Label 'Date';
        CustomerRefNo_LBl: Label 'Customer Ref. No.';
        FillBlock_LBl: Label 'Please fill in using BLOCK LETTERS and () wherever applicable';
        applicant_LBl: Label 'Full name of applicant:';
        Contract_Lbl: Label 'Contact tel no:';
        Email_Lbl: Label 'e-mail:';
        PleaseEffect_Lbl: Label 'Please effect the following transaction (tick appropriate box)';
        SwiftTransfer_Lbl: Label 'Swift Transfer';
        BankDraft_Lbl: Label 'Bank Draft';

}

