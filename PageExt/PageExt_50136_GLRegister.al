pageextension 50136 GLRegExt extends "G/L Registers"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("G/L Register")
        {
            action("Print Out")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    GLReg: Record "G/L Register";
                begin
                    GLReg.Get(Rec."No.");
                    GLReg.SetRecFilter();
                    REPORT.Run(3, false, true, GLReg);
                end;
            }
        }
    }

    var
        myInt: Integer;
}