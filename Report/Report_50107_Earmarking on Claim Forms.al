report 50107 "Earmarking on Claim Forms"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\EarmarkingOnclaimforms.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Earmarking Claim Forms Table"; "Earmarking Claim Forms Table")
        {
            DataItemTableView = where(Active = const(true));
            RequestFilterFields = "Earmark ID", "Date Earmarked", "G/L Account Earmarked";
            column(Company_Name; CompanyInfo.Name)
            {

            }
            column(Earmark_IDCaptionLbl; FieldCaption("Earmark ID"))
            {

            }
            column(Date_EarmarkedCaptionLbl; FieldCaption("Date Earmarked"))
            {

            }
            column(DescriptionCaptionLbl; FieldCaption(Description))
            {

            }
            column(G_L_Account_EarmarkedCaptionLbl; FieldCaption("G/L Account Earmarked"))
            {

            }
            column(G_L_DescriptionCaptionLbl; FieldCaption("G/L Description"))
            {

            }
            column(Amount_EarmarkedCaptionLbl; FieldCaption("Amount Earmarked"))
            {

            }
            column(RemainingAmountEarmarkedCaptionLbl; FieldCaption("Remaining Amount Earmarked"))
            {

            }
            column(ClaimFormNoCaptionLbl; ClaimFormNoCaptionLbl)
            {

            }
            column(AmountEarmarkedCaptionLbl; AmountEarmarkedCaptionLbl)
            {

            }
            column(Earmark_ID; "Earmark ID")
            {

            }
            column(Date_Earmarked; "Date Earmarked")
            {

            }
            column(Description; Description)
            {

            }
            column(G_L_Account_Earmarked; "G/L Account Earmarked")
            {

            }
            column(G_L_Description; "G/L Description")
            {

            }
            column(Amount_Earmarked; "Amount Earmarked")
            {

            }
            column(Remaining_Amount_Earmarked; "Remaining Amount Earmarked")
            {

            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Earmark ID" = field("Earmark ID");
                column(Document_No_; "Document No.")
                {

                }
                column(Line_Amount; "Line Amount")
                {

                }
            }
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
    trigger OnPreReport()
    begin
        CompanyInfo.get();
    end;

    var
        myInt: Integer;
        LineAmount: Decimal;
        ClaimFormNoCaptionLbl: Label 'Claim Form No.';
        AmountEarmarkedCaptionLbl: Label 'Amount Earmarked on Claim';
        CompanyInfo: Record "Company Information";
}