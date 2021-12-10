page 50068 "Bank List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bank Details";
    Editable = false;
    CardPageId = "Bank Card";
    DataCaptionFields = "Bank Code";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Bank Code"; "Bank Code")
                {
                    ApplicationArea = All;

                }
                field("Bank Name"; "Bank Name")
                {
                    ApplicationArea = All;

                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;

                }
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