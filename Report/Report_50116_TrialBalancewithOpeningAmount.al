report 50116 "Trial Bal with Opening Amount"
{
    Caption = 'Trial Balance with Opening Amount';
    RDLCLayout = 'Report\Layout\TrialBalancewithOpeningAmoun.rdl';
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = where("Account Type" = const(Posting));
            column(CompanyInfo; CompanyInfo.Name)
            {

            }
            column(No_; "No.")
            {

            }
            column(Name; Name)
            {

            }
            column(OpeningBal; OpeningBal)
            {

            }
            column(DebitAmount; DebitAmount)
            {

            }
            column(CreditAmount; CreditAmount)
            {

            }
            column(ClosingBal; ClosingBal)
            {

            }
            column(FromDate; format(FromDate))
            {

            }
            column(Todate; format(Todate))
            {

            }
            column(Filters; "G/L Account".GetFilters())
            {

            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.get();
            end;

            trigger OnAfterGetRecord()
            var
                GLEntry: Record "G/L Entry";
            begin
                Clear(OpeningBal);
                Clear(ClosingBal);
                Clear(DebitAmount);
                Clear(CreditAmount);
                GLEntry.Reset();
                GLEntry.SetRange("G/L Account No.", "No.");
                GLEntry.SetFilter("Posting Date", '<%1', FromDate);
                if GLEntry.FindSet() then begin
                    GLEntry.CalcSums(Amount);
                    OpeningBal := GLEntry.Amount;
                end;
                GLEntry.Reset();
                GLEntry.SetRange("G/L Account No.", "No.");
                GLEntry.SetRange("Posting Date", FromDate, Todate);
                if GLEntry.FindSet() then begin
                    GLEntry.CalcSums("Debit Amount");
                    DebitAmount := GLEntry."Debit Amount";
                end;
                GLEntry.Reset();
                GLEntry.SetRange("G/L Account No.", "No.");
                GLEntry.SetRange("Posting Date", FromDate, Todate);
                if GLEntry.FindSet() then begin
                    GLEntry.CalcSums("Credit Amount");
                    CreditAmount := GLEntry."Credit Amount";
                end;
                ClosingBal := OpeningBal + DebitAmount - CreditAmount;
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
                    field("From Date"; FromDate)
                    {
                        ApplicationArea = All;

                    }
                    field("To Date"; Todate)
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
    }

    var
        myInt: Integer;
        FromDate: Date;
        Todate: Date;
        OpeningBal: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        ClosingBal: Decimal;
        CompanyInfo: Record "Company Information";
}