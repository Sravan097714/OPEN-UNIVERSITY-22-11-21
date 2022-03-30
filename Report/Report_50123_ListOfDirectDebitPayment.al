report 50123 "List of Direct Debit Payments"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\ListofDirectDebitPayments.rdl';


    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            RequestFilterFields = "Posting Date";
            DataItemTableView = sorting("Entry No.") where("Document type" = const(Payment), "Payment Method Code" = Filter('DIRECTDEBT'));
            column(CompanyName_; CompanyInfo.Name)
            {

            }
            column(UserName; UserName)
            {

            }
            column(ReportTitle; ReportTitle)
            {

            }
            column(DateFilter; DateFilter)
            {

            }
            column(Posting_Date; "Posting Date")
            {
                IncludeCaption = true;
            }
            column(Document_No_; "Document No.")
            {
                IncludeCaption = true;
            }
            column(External_Document_No_; "External Document No.")
            {
                IncludeCaption = true;
            }
            column(AccountTypeLbl; AccountTypeLbl)
            {

            }
            column(Bal__Account_Type; "Bal. Account Type")
            {

            }
            column(AccountNolbl; AccountNolbl)
            {

            }
            column(Bal__Account_No_; "Bal. Account No.")
            {

            }
            column(Description; Description)
            {
                IncludeCaption = true;
            }
            column(Payment_Method_Code; "Payment Method Code")
            {
                IncludeCaption = true;
            }
            column(Amount; AmountVar)
            {

            }
            column(BalAccountNoLbl; BalAccountNoLbl)
            {

            }

            column(Bank_Account_No_; "Bank Account No.")
            {

            }
            trigger OnAfterGetRecord()
            begin
                AmountVar := 0;
                if Amount < 0 then
                    AmountVar := -amount
                else
                    AmountVar := amount;
            end;

        }
    }

    requestpage
    {
        /*
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; SourceExpression)
                    {
                        ApplicationArea = All;
                        
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
        */
    }

    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);

        DateFilter := "Bank Account Ledger Entry".GetFilter("Posting Date");
        UserRec.SetRange("User Name", UserId);
        if UserRec.FindFirst() then
            UserName := UserRec."Full Name";
        if UserName = '' then
            UserName := UserId;
    end;

    var
        CompanyInfo: Record "Company Information";
        UserName: text;
        UserRec: Record User;
        DateFilter: Text;
        AmountVar: Decimal;
        ReportTitle: Label 'List of Direct Debit Payments';
        AccountTypeLbl: Label 'Account Type';
        AccountNolbl: Label 'Account No.';
        BalAccountNoLbl: Label 'Bal. Account No.';

}