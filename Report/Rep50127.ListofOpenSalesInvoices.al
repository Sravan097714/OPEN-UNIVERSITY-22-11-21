report 50127 "List of Open Sales Invoices"
{
    ApplicationArea = All;
    Caption = 'List of Open Sales Invoices';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\ListofOpenSalesInvoices.rdl';
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.", "Posting Date", "Order Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "From OU Portal", "Gov Grant";
            CalcFields = Amount, "Amount Including VAT";
            DataItemTableView = where("Document Type" = const(Invoice));
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
            column(ExternalDocumentNo_SalesHeader; "External Document No.")
            {
                IncludeCaption = true;
            }
            column(BankCode_SalesHeader; "Bank Code")
            {
                IncludeCaption = true;
            }
            column(CurrencyCode; "Currency Code")
            {
                IncludeCaption = true;
            }
            column(OrderDate_SalesHeader; "Order Date")
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
            column(CustomerPostingGroup; "Customer Posting Group")
            {
                IncludeCaption = true;
            }
            column(CreatedBy; "Created By")
            {
                IncludeCaption = true;
            }
            column(DueDate; "Due Date")
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
            column(GovGrant_SalesHeader; "Gov Grant")
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
