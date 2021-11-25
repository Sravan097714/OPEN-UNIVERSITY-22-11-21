page 50067 "AllowPosting period per user"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Allowed Posting period per user';
    PageType = List;
    SourceTable = "User Setup";
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("User ID"; "User ID")
                {
                    ApplicationArea = Basic, Suite;
                    LookupPageID = "User Lookup";
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                }
                field("Allow Posting From"; "Allow Posting From")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the earliest date on which the user is allowed to post to the company.';
                }
                field("Allow Posting To"; "Allow Posting To")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the last date on which the user is allowed to post to the company.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        HideExternalUsers;
    end;
}

