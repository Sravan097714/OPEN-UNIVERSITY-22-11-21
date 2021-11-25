page 50066 "Allow PostPeriod for allusers"
{
    AdditionalSearchTerms = 'finance setup,general ledger setup,g/l setup';
    ApplicationArea = Basic, Suite;
    Caption = 'Allowed Posting Period for all users';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,General,Posting,VAT,Bank,Journal Templates';
    SourceTable = "General Ledger Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Allow Posting From"; "Allow Posting From")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the earliest date on which posting to the company books is allowed.';
                }
                field("Allow Posting To"; "Allow Posting To")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the last date on which posting to the company books is allowed.';
                }
            }
        }
    }
    var
        test: Page "User Setup";
}

