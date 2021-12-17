page 50070 "FA Schedule Grouping"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FA Schedule Grouping";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Report Type"; Rec."Report Type") { ApplicationArea = All; }
                field("Group Code"; Rec."Group Code") { ApplicationArea = All; }
                field("FA Posting Filters"; Rec."FA Posting Filters") { ApplicationArea = All; }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}