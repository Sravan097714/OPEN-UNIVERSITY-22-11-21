page 50076 "Retention Due"
{
    Caption = 'Retentions Due';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Purchase Cue";

    layout
    {
        area(content)
        {
            cuegroup(RetentionsDue)
            {
                Caption = 'Retentions Due';
                field("Retentions Due"; "Retentions Due")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of Purchase Order Due today.';
                }


            }



        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;
        //Use this to filter on Date
        SetFilter("Date Filter", '%1', Today);
    end;
}
