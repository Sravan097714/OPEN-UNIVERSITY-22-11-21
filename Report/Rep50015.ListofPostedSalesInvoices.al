report 50015 "List of Posted Sales Invoices"
{
    ApplicationArea = All;
    Caption = 'List of Posted Sales Invoices';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\ListofPostedSalesInvoices.rdl';
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.", "Posting Date", "Pre-Assigned No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "From OU Portal";
            CalcFields = Amount, "Amount Including VAT", "Remaining Amount";
            column(No; "No.")
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(PostingDescription; "Posting Description")
            {
                IncludeCaption = true;
            }
            column(CurrencyCode; "Currency Code")
            {
                IncludeCaption = true;
            }
            column(DueDate; "Due Date")
            {
                IncludeCaption = true;
            }
            column(Amount; Amount)
            {
                IncludeCaption = true;
            }
            column(AmountIncludingVAT; "Amount Including VAT")
            {
                IncludeCaption = true;
            }
            column(RemainingAmount; "Remaining Amount")
            {
                IncludeCaption = true;
            }
            column(PostingDate; "Posting Date")
            {
                IncludeCaption = true;
            }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(VATBusPostingGroup; "VAT Bus. Posting Group")
            {
                IncludeCaption = true;
            }
            column(NoPrinted; "No. Printed")
            {
                IncludeCaption = true;
            }
            column(PreAssignedNo; "Pre-Assigned No.")
            {
                IncludeCaption = true;
            }
            column(UserID; "User ID")
            {
                IncludeCaption = true;
            }
            column(CustomerPostingGroup; "Customer Posting Group")
            {
                IncludeCaption = true;
            }
            column(CreatedBy; "Created By")
            {
                IncludeCaption = true;
            }
            column(FromOUPortal; "From OU Portal")
            {
                IncludeCaption = true;
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(Instalment; Instalment)
            {
                IncludeCaption = true;
            }
            column(NIC; NIC)
            {
                IncludeCaption = true;
            }
            column(RDAP; RDAP)
            {
                IncludeCaption = true;
            }
            column(RDBL; RDBL)
            {
                IncludeCaption = true;
            }
            column(PTN; PTN)
            {
                IncludeCaption = true;
            }
            column(CompanyInfo_Name; CompanyInfo.Name) { }
            column(GD1Caption; GD1Caption) { }
            column(GD2Caption; GD2Caption) { }
            column(GD1DimDescription; GD1DimDescription) { }
            column(GD2DimDescription; GD2DimDescription) { }
            trigger OnAfterGetRecord()
            begin
                if DimValues.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code") then
                    GD1DimDescription := DimValues."Name 2"
                else
                    clear(GD1DimDescription);

                if DimValues.Get(GLSetup."Global Dimension 2 Code", "Shortcut Dimension 2 Code") then
                    GD2DimDescription := DimValues."Name 2"
                else
                    Clear(GD2DimDescription);

            end;
        }

    }
    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        GLSetup.Get();
        if Dimension.Get(GLSetup."Global Dimension 1 Code") then
            GD1Caption := Dimension."Code Caption"
        else
            Clear(GD1Caption);

        if Dimension.Get(GLSetup."Global Dimension 2 Code") then
            GD2Caption := Dimension."Code Caption"
        else
            clear(GD2Caption);
    end;

    var
        CompanyInfo: Record "Company Information";
        Dimension: Record Dimension;
        DimValues: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        GD1Caption: Text;
        GD2Caption: Text;
        GD1DimDescription: Text;
        GD2DimDescription: Text;
}
