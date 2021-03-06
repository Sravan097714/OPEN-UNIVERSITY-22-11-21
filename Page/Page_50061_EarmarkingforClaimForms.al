page 50061 "Earmarking for Claim Forms"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Earmarking Claim Forms Table";

    layout
    {
        area(Content)
        {
            repeater(" ")
            {
                field("G/L Account Earmarked"; "G/L Account Earmarked")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Active := true;
                    end;
                }
                field("G/L Description"; "G/L Description") { ApplicationArea = All; }
                field("Earmark ID"; "Earmark ID") { ApplicationArea = ALl; }
                field("Date Earmarked"; "Date Earmarked") { ApplicationArea = All; }
                field("Earmarked By"; "Earmarked By") { ApplicationArea = All; }
                field("Amount Earmarked"; "Amount Earmarked") { ApplicationArea = All; }
                field("Remaining Amount Earmarked"; "Remaining Amount Earmarked") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Active; Active) { ApplicationArea = All; }
                field("Date From"; Rec."Date From")
                {
                    ToolTip = 'Specifies the value of the Date From field.';
                    ApplicationArea = All;
                }
                field("Date To"; Rec."Date To")
                {
                    ToolTip = 'Specifies the value of the Date To field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}