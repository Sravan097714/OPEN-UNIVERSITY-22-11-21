report 50111 "Standing Order Transactions"
{
    Caption = 'Standing Order Transactions';
    RDLCLayout = 'Report\Layout\StandingOrderTransactions.rdl';
    DefaultLayout = RDLC;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Standing Orders"; "Bank Standing Orders")
        {
            column(Companyinfo_PayName; Companyinfo."Payer Name")
            {

            }
            column(Name_Lbl; Name_Lbl)
            {

            }
            column(Standed_Lbl; Standed_Lbl)
            {

            }
            column(NameofProgrammes_Lbl; NameofProgrammes_Lbl)
            {

            }
            column(INTAKE_Lbl; INTAKE_Lbl)
            {

            }
            column(Year_Lbl; Year_Lbl)
            {

            }
            column(Semester_Lbl; Semester_Lbl)
            {

            }
            column(GLCode_Lbl; GLCode_Lbl)
            {

            }
            column(BankName_Lbl; BankName_Lbl)
            {

            }

            column(FROM_Lbl; FROM_Lbl)
            {

            }
            column(To_Lbl; To_Lbl)
            {

            }
            column(InvoiceNumber; InvoiceNumber)
            {

            }
            column(AmountPayable_Lbl; AmountPayable_Lbl)
            {

            }
            column(Instalments_Lbl; Instalments_Lbl)
            {

            }
            column(Period; Period)
            {

            }
            column(ReceiptNumber_Lbl; ReceiptNumber_Lbl)
            {

            }
            column(AmountPaid_Lbl; AmountPaid_Lbl)
            {

            }
            column(Date_Lbl; Date_Lbl)
            {

            }
            column(Remarks_Lbl; Remarks_Lbl)
            {

            }
            column(AmountDue_Lbl; AmountDue_Lbl)
            {

            }
            column(Full_Name_of_Applicant; "Full Name of Applicant")
            {

            }
            column(Programme; Programme)
            {

            }
            column(Intake; Intake)
            {

            }
            column(Year; Year)
            {

            }
            column(Semester; Semester)
            {

            }
            column(Name_of_Bank; "Name of Bank")
            {

            }
            column(From_Month; "From Month")
            {

            }
            column(To_Month; "To Month")
            {

            }
            column(Invoice_Number; "Invoice Number")
            {

            }
            column(Total_Fee_for_Installments; "Total Fee for Installments")
            {

            }
            column(No__of_Installments; "No. of Installments")
            {

            }
            column(GLCode; GLCode)
            {

            }
            column(ReceiptNumber; ReceiptNumber)
            {

            }
            column(ReceiptDate; ReceiptDate)
            {

            }
            column(PaidAmount; PaidAmount)
            {

            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Document No." = field("Invoice Number");
                DataItemTableView = where("Document Type" = const(Invoice));
                column(Customer_Posting_Group; "Customer Posting Group")
                {

                }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No." = field("Entry No.");
                    DataItemTableView = where("Document Type" = const(Payment), "Entry Type" = const(Application));
                    column(Document_No_; "Document No.")
                    {

                    }

                    column(Posting_Date; "Posting Date")
                    {

                    }
                    column(Amount; ABS(Amount))
                    {

                    }
                }
            }
            trigger OnPreDataItem()
            begin
                SetRange("From Month", FromDate, ToDate);
                Companyinfo.Get();
                Period := StrSubstNo(PERIOD_Lbl, format(FromDate), format(ToDate));
            end;

            /*trigger OnAfterGetRecord()
            var
                CustLedgerEntry: Record "Cust. Ledger Entry";
                DetailedCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
                SalesInvoiceLine: Record "Sales Invoice Line";
            begin
                Clear(PaidAmount);
                Clear(ReceiptDate);
                Clear(ReceiptNumber);
                Clear(GLCode);
                SalesInvoiceLine.Reset();
                SalesInvoiceLine.SetRange("Document No.", "Invoice Number");
                SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::"G/L Account");
                SalesInvoiceLine.SetFilter("No.", '<>%1', '');
                if SalesInvoiceLine.FindFirst() then
                    GLCode := SalesInvoiceLine."No.";
                CustLedgerEntry.Reset();
                CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                CustLedgerEntry.SetRange("Document No.", "Invoice Number");
                if CustLedgerEntry.FindFirst() then begin
                    DetailedCustLedgerEntry.Reset();
                    DetailedCustLedgerEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                    DetailedCustLedgerEntry.SetRange("Document Type", DetailedCustLedgerEntry."Document Type"::Payment);
                    DetailedCustLedgerEntry.SetRange("Entry Type", DetailedCustLedgerEntry."Entry Type"::Application);
                    if DetailedCustLedgerEntry.FindFirst() then begin
                        ReceiptNumber := DetailedCustLedgerEntry."Document No.";
                        ReceiptDate := DetailedCustLedgerEntry."Posting Date";
                    end;
                    if DetailedCustLedgerEntry.FindSet() then begin
                        DetailedCustLedgerEntry.CalcSums(Amount);
                        PaidAmount := Abs(DetailedCustLedgerEntry.Amount)
                    end;


                end;
            end;*/
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
                        ApplicationArea = all;
                    }
                    field("To Date"; ToDate)
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
        ReceiptNumber: Code[20];
        PaidAmount: Decimal;
        ReceiptDate: Date;
        GLCode: Code[20];
        Name_Lbl: Label 'Name';
        NameofProgrammes_Lbl: Label 'Name of Programmes';
        Intake_Lbl: Label 'Intake';
        Year_Lbl: Label 'Year';
        Semester_Lbl: Label 'Semester';
        GLCode_Lbl: Label 'GL Code';
        BankName_Lbl: Label 'Bank Name';
        From_Lbl: Label 'From';
        To_Lbl: Label 'To';
        InvoiceNumber: Label 'Invoice Number';
        AmountPayable_Lbl: Label 'Amount Payable';
        Instalments_Lbl: Label 'Instalments';
        ReceiptNumber_Lbl: Label 'Receipt Number';
        AmountPaid_Lbl: Label 'Amount Paid';
        Date_Lbl: Label 'Date';
        Remarks_Lbl: Label 'Remarks';
        AmountDue_Lbl: Label 'Amount Due';
        Standed_Lbl: Label 'STANDING ORDER TRANSACTIONS';
        FromDate: Date;
        ToDate: Date;
        PERIOD_Lbl: Label 'PERIOD OF %1 TO %2';
        Companyinfo: Record "Company Information";
        Period: Text;
}