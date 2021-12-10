page 50069 "Bank Card"
{
    PageType = Card;
    SourceTable = "Bank Details";

    layout
    {
        area(Content)
        {
            group(GroupName)
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
                field("Bank Address"; "Bank Address")
                {
                    ApplicationArea = All;

                }
                field("Bank Address 2"; "Bank Address 2")
                {
                    ApplicationArea = All;

                }
                field("Contact Title"; "Contact Title")
                {
                    ApplicationArea = All;

                }
                field("Contact Name"; "Contact Name")
                {
                    ApplicationArea = All;

                }
                field("Contact Department"; "Contact Department")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}