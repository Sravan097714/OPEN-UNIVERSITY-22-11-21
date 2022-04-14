report 50117 "Statement of GL Accounts PV"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\StatementofGLAccountsWithPV.rdl';
    AdditionalSearchTerms = 'payment due,order status';
    ApplicationArea = All;
    Caption = 'Statement of GL Accounts With PV';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = WHERE("Account Type" = CONST(Posting));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Income/Balance", "Debit/Credit", "Date Filter";
            column(PeriodGLDtFilter; StrSubstNo(Text000, GLDateFilter))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(ExcludeBalanceOnly; ExcludeBalanceOnly)
            {
            }
            column(PrintReversedEntries; PrintReversedEntries)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(PrintClosingEntries; PrintClosingEntries)
            {
            }
            column(PrintOnlyCorrections; PrintOnlyCorrections)
            {
            }
            column(GLAccTableCaption; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(EmptyString; '')
            {
            }
            column(No_GLAcc; "No.")
            {
            }
            column(DetailTrialBalCaption; DetailTrialBalCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(PeriodCaption; PeriodCaptionLbl)
            {
            }
            column(OnlyCorrectionsCaption; OnlyCorrectionsCaptionLbl)
            {
            }
            column(NetChangeCaption; NetChangeCaptionLbl)
            {
            }
            column(GLEntryDebitAmtCaption; GLEntryDebitAmtCaptionLbl)
            {
            }
            column(GLEntryCreditAmtCaption; GLEntryCreditAmtCaptionLbl)
            {
            }
            column(GLBalCaption; GLBalCaptionLbl)
            {
            }
            dataitem(PageCounter; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(Name_GLAcc; "G/L Account".Name)
                {
                }
                column(StartBalance; StartBalance)
                {
                    AutoFormatType = 1;
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "G/L Account No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Business Unit Code" = FIELD("Business Unit Filter");
                    DataItemLinkReference = "G/L Account";
                    //DataItemTableView = SORTING("G/L Account No.", "Posting Date");
                    RequestFilterFields = "Global Dimension 1 Code", "Global Dimension 2 Code";
                    column(VATAmount_GLEntry; "VAT Amount")
                    {
                        IncludeCaption = true;
                    }
                    column(DebitAmount_GLEntry; "Debit Amount")
                    {
                    }
                    column(CreditAmount_GLEntry; "Credit Amount")
                    {
                    }
                    column(PostingDate_GLEntry; "Posting Date")
                    {
                    }
                    column(DocumentNo_GLEntry; "Document No.")
                    {
                    }
                    column(ExtDocNo_GLEntry; "External Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_GLEntry; Description)
                    {
                    }
                    column(PV_Number; "PV Number")
                    {
                    }
                    column(GLBalance; GLBalance)
                    {
                        AutoFormatType = 1;
                    }
                    column(EntryNo_GLEntry; "Entry No.")
                    {
                    }
                    column(ClosingEntry; ClosingEntry)
                    {
                    }
                    column(Reversed_GLEntry; Reversed)
                    {
                    }
                    column(gtextName; gtextName) { }
                    column(PVNumber; PVNumber) { }
                    column(BankCheckNo; BankCheckNo) { }
                    column(TotalDebitAmount; TotalDebitAmount) { }
                    column(TotalcreditAmount; TotalcreditAmount) { }
                    dataitem("Dimension Set Entry"; "Dimension Set Entry")
                    {
                        DataItemTableView = SORTING("Dimension Set ID", "Dimension Code") ORDER(Ascending);
                        DataItemLink = "Dimension Set ID" = FIELD("Dimension Set ID");
                        DataItemLinkReference = "G/L Entry";
                        CalcFields = "Dimension Value Name";
                        column(Dimension_Code; "Dimension Code") { }
                        column(Dimension_Value_Code; "Dimension Value Code") { }
                        column(Dimension_Value_Name; "Dimension Value Name") { }
                        column(DimensionName2; DimensionName2) { }
                        trigger OnAfterGetRecord()
                        var
                            DimensionValueLRec: Record "Dimension Value";
                        begin
                            If not DimensionValueLRec.Get("Dimension Code", "Dimension Value Code") then
                                Clear(DimensionName2);

                            if DimensionValueLRec."Name 2" <> '' then
                                DimensionName2 := DimensionValueLRec."Name 2"
                            else
                                DimensionName2 := DimensionValueLRec.Name;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    Var
                        VendorLedgerEntry: Record "Vendor Ledger Entry";
                        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                        VendorLedgerEntry2: Record "Vendor Ledger Entry";
                        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
                    begin
                        Clear(PVNumber);
                        Clear(BankCheckNo);
                        if PrintOnlyCorrections then
                            if not (("Debit Amount" < 0) or ("Credit Amount" < 0)) then
                                CurrReport.Skip();
                        if not PrintReversedEntries and Reversed then
                            CurrReport.Skip();

                        GLBalance := GLBalance + Amount;
                        if ("Posting Date" = ClosingDate("Posting Date")) and
                           not PrintClosingEntries
                        then begin
                            "Debit Amount" := 0;
                            "Credit Amount" := 0;
                        end;

                        if "Posting Date" = ClosingDate("Posting Date") then
                            ClosingEntry := true
                        else
                            ClosingEntry := false;


                        clear(gtextName);
                        if "Source Type" = "Source Type"::Customer then begin
                            if grecCustomer.get("Source No.") then
                                gtextName := grecCustomer.Name;
                        end;
                        if "Source Type" = "Source Type"::Vendor then begin
                            if grecVendor.get("Source No.") then
                                gtextName := grecVendor.Name;
                        end;
                        if "Source Type" = "Source Type"::"Bank Account" then begin
                            if grecBankAccountNo.get("Source No.") then
                                gtextName := grecBankAccountNo."Bank Account No.";
                        end;
                        if "Source Type" = "Source Type"::"Fixed Asset" then begin
                            if grecFixedAsset.get("Source No.") then
                                gtextName := grecFixedAsset.Description;
                        end;
                        TotalDebitAmount += "Debit Amount";
                        TotalcreditAmount += "Credit Amount";

                        VendorLedgerEntry2.Reset();
                        VendorLedgerEntry2.SetRange("Document No.", "Document No.");
                        VendorLedgerEntry2.SetRange("Vendor No.", "Source No.");
                        VendorLedgerEntry2.SetRange("Transaction No.", "Transaction No.");
                        if VendorLedgerEntry2.FindFirst() then begin
                            DtldVendLedgEntry.Reset();
                            DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendorLedgerEntry2."Entry No.");
                            //DtldVendLedgEntry.SetRange(Unapplied, false);
                            if DtldVendLedgEntry.FindSet() then
                                repeat
                                    IF DtldVendLedgEntry."Vendor Ledger Entry No." = DtldVendLedgEntry."Applied Vend. Ledger Entry No." THEN BEGIN
                                        DtldVendLedgEntry2.INIT;
                                        DtldVendLedgEntry2.SETCURRENTKEY("Applied Vend. Ledger Entry No.", "Entry Type");
                                        DtldVendLedgEntry2.SETRANGE("Applied Vend. Ledger Entry No.", DtldVendLedgEntry."Applied Vend. Ledger Entry No.");
                                        DtldVendLedgEntry2.SETRANGE("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                                        //DtldVendLedgEntry2.SetRange(Unapplied, false);
                                        IF DtldVendLedgEntry2.FIND('-') THEN
                                            REPEAT
                                                IF DtldVendLedgEntry2."Vendor Ledger Entry No." <>
                                                   DtldVendLedgEntry2."Applied Vend. Ledger Entry No."
                                                THEN BEGIN
                                                    VendorLedgerEntry.SETCURRENTKEY("Entry No.");
                                                    VendorLedgerEntry.SETRANGE("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                                    IF VendorLedgerEntry.FIND('-') THEN
                                                        VendorLedgerEntry.MARK(TRUE);
                                                END;
                                            UNTIL DtldVendLedgEntry2.NEXT = 0;
                                    END ELSE BEGIN
                                        VendorLedgerEntry.SETCURRENTKEY("Entry No.");
                                        VendorLedgerEntry.SETRANGE("Entry No.", DtldVendLedgEntry."Applied Vend. Ledger Entry No.");
                                        IF VendorLedgerEntry.FIND('-') THEN
                                            VendorLedgerEntry.MARK(TRUE);
                                    END;
                                until DtldVendLedgEntry.Next() = 0;
                        end;
                        /*
                        if VendorLedgerEntry2."Closed by Entry No." <> 0 then begin
                            VendorLedgerEntry.SetCurrentKey("Closed by Entry No.");
                            VendorLedgerEntry.SetRange("Closed by Entry No.", VendorLedgerEntry2."Entry No.");
                            if VendorLedgerEntry.Find('-') then
                                VendorLedgerEntry.Mark(true);
                        end;
                        */

                        VendorLedgerEntry.MarkedOnly(true);
                        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Payment);
                        if VendorLedgerEntry.FindFirst() then begin
                            PVNumber := VendorLedgerEntry."PV Number";
                            BankCheckNo := VendorLedgerEntry."Document No.";
                        end;
                        if PVNumber = '' then
                            PVNumber := "PV Number";
                    end;

                    trigger OnPreDataItem()
                    begin
                        Clear(TotalcreditAmount);
                        Clear(TotalDebitAmount);
                        GLBalance := StartBalance;

                        OnAfterOnPreDataItemGLEntry("G/L Entry");
                        SetCurrentKey("Posting Date");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PrintOnlyIfDetail := ExcludeBalanceOnly or (StartBalance = 0);
                end;
            }

            trigger OnAfterGetRecord()
            var
                GLEntry: Record "G/L Entry";
                Date: Record Date;
            begin
                StartBalance := 0;
                if GLDateFilter <> '' then begin
                    Date.SetRange("Period Type", Date."Period Type"::Date);
                    Date.SetFilter("Period Start", GLDateFilter);
                    if Date.FindFirst then begin
                        SetRange("Date Filter", 0D, ClosingDate(Date."Period Start" - 1));
                        CalcFields("Net Change");
                        StartBalance := "Net Change";
                        SetFilter("Date Filter", GLDateFilter);
                    end;
                end;

                if PrintOnlyOnePerPage then begin
                    GLEntry.Reset();
                    GLEntry.SetRange("G/L Account No.", "No.");
                    if CurrReport.PrintOnlyIfDetail and GLEntry.FindFirst then
                        PageGroupNo := PageGroupNo + 1;
                end;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewPageperGLAcc; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per G/L Acc.';
                        ToolTip = 'Specifies if each G/L account information is printed on a new page if you have chosen two or more G/L accounts to be included in the report.';
                    }
                    field(ExcludeGLAccsHaveBalanceOnly; ExcludeBalanceOnly)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exclude G/L Accs. That Have a Balance Only';
                        MultiLine = true;
                        ToolTip = 'Specifies if you do not want the report to include entries for G/L accounts that have a balance but do not have a net change during the selected time period.';
                    }
                    field(InclClosingEntriesWithinPeriod; PrintClosingEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Closing Entries Within the Period';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want the report to include closing entries. This is useful if the report covers an entire fiscal year. Closing entries are listed on a fictitious date between the last day of one fiscal year and the first day of the next one. They have a C before the date, such as C123194. If you do not select this field, no closing entries are shown.';
                    }
                    field(IncludeReversedEntries; PrintReversedEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Reversed Entries';
                        ToolTip = 'Specifies if you want to include reversed entries in the report.';
                    }
                    field(PrintCorrectionsOnly; PrintOnlyCorrections)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Corrections Only';
                        ToolTip = 'Specifies if you want the report to show only the entries that have been reversed and their matching correcting entries.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        PostingDateCaption = 'Posting Date';
        DocNoCaption = 'Document No.';
        DescCaption = 'Description';
        VATAmtCaption = 'VAT Amount';
        EntryNoCaption = 'Entry No.';
    }

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters;
        GLDateFilter := "G/L Account".GetFilter("Date Filter");

        OnAfterOnPreReport("G/L Account");
    end;

    var
        Text000: Label 'Period: %1';
        GLDateFilter: Text;
        GLFilter: Text;
        GLBalance: Decimal;
        StartBalance: Decimal;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        PrintClosingEntries: Boolean;
        PrintOnlyCorrections: Boolean;
        PrintReversedEntries: Boolean;
        PageGroupNo: Integer;
        ClosingEntry: Boolean;
        DetailTrialBalCaptionLbl: Label 'Statement of GL Accounts with PV';
        PageCaptionLbl: Label 'Page';
        BalanceCaptionLbl: Label 'This also includes general ledger accounts that only have a balance.';
        PeriodCaptionLbl: Label 'This report also includes closing entries within the period.';
        OnlyCorrectionsCaptionLbl: Label 'Only corrections are included.';
        NetChangeCaptionLbl: Label 'Net Change';
        GLEntryDebitAmtCaptionLbl: Label 'Debit';
        GLEntryCreditAmtCaptionLbl: Label 'Credit';
        GLBalCaptionLbl: Label 'Balance';
        gtextName: Text;
        grecVendor: Record Vendor;
        grecCustomer: Record Customer;
        grecBankAccountNo: Record "Bank Account";
        grecFixedAsset: Record "Fixed Asset";
        DimensionName2: Text;
        TotalDebitAmount: Decimal;
        TotalcreditAmount: Decimal;
        PVNumber: Code[20];
        BankCheckNo: code[20];

    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean; NewExcludeBalanceOnly: Boolean; NewPrintClosingEntries: Boolean; NewPrintReversedEntries: Boolean; NewPrintOnlyCorrections: Boolean)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        ExcludeBalanceOnly := NewExcludeBalanceOnly;
        PrintClosingEntries := NewPrintClosingEntries;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintOnlyCorrections := NewPrintOnlyCorrections;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnPreDataItemGLEntry(var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnPreReport(var GLAccount: Record "G/L Account")
    begin
    end;
}

