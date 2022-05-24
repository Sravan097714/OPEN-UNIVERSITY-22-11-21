report 50072 "List of Cancelled Receipts "
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\ListofCancelledReceipts.rdl';

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            RequestFilterFields = "Bank Account No.";
            DataItemTableView = sorting("Bank Account No.", "Posting Date") where("Source Code" = filter('REVERSAL'), "Bal. Account Type" = Filter('Çustomer'));
            column(Bank_Account_No_; "Bank Account No.") { }
            column(ReceiptNo_; "Bank Account Ledger Entry"."Document No.") { }
            column(No_; "Bal. Account No.") { }
            column(Name_; CustomerRec.Name) { }
            column(CompanyInfoName; grecCompanyInfo.Name) { }
            column(BankAccountName; grecBankAccount.Name) { }
            column(Posting_Date; format("Posting Date")) { }
            column(Description; Description) { }
            column(Amount; abs(Amount)) { }
            column(Currency_Code; "Currency Code") { }
            column(Amount__LCY_; abs("Amount (LCY)")) { }
            column(Programme; gtextProgramme) { }
            column(Intake; gtextIntake) { }
            column(User_ID; "User ID") { }
            column(ReportFilters; ReportFilters) { }
            column(gdateStartDate; gdateStartDate) { }
            column(gdateEndDate; gdateEndDate) { }

            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", gdateStartDate, gdateEndDate);
            end;

            trigger OnAfterGetRecord()
            begin
                if not grecBankAccount.get("Bank Account No.") then
                    Clear(grecBankAccount);
                if not grecBankAccount."Receipts Only" then
                    CurrReport.Skip();

                if grecDimValue.Get(grecGeneralLedgerSetup."Global Dimension 1 Code", "Global Dimension 1 Code") then
                    gtextProgramme := grecDimValue."Name 2";

                if grecDimValue.Get(grecGeneralLedgerSetup."Global Dimension 2 Code", "Global Dimension 2 Code") then
                    gtextIntake := grecDimValue.Name;

                CustomerRec.Reset();
                if CustomerRec.get("Bal. Account No.") then;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Date)
                {
                    field("Start Date"; gdateStartDate) { ApplicationArea = All; }
                    field("End Date"; gdateEndDate) { ApplicationArea = All; }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        ReportFilters := "Bank Account Ledger Entry".GetFilters;
        grecCompanyInfo.get;
        grecGeneralLedgerSetup.Get;
        if (gdateStartDate = 0D) OR (gdateEndDate = 0D) then
            Error('Please insert both Starting Date and Ending Date.');

        if gdateEndDate < gdateStartDate then
            Error('Starting Date should be less or equal to Ending Date.');
    end;

    var
        grecCompanyInfo: Record "Company Information";
        gdateStartDate: Date;
        gdateEndDate: Date;
        CusName: Text;
        grecBankAccount: Record "Bank Account";
        gtextProgramme: Text;
        gtextIntake: Text;
        grecDimValue: Record "Dimension Value";
        grecGeneralLedgerSetup: Record "General Ledger Setup";
        ReportFilters: Text;
        CustomerRec: Record Customer;
}