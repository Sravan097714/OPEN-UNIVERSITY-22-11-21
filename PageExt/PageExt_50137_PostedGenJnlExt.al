pageextension 50137 PostedGenJnlExt extends "Posted General Journal"
{
    layout
    {
        modify(Quantity)
        {
            Visible = false;
        }
        modify("VAT Amount")
        {
            Visible = false;
        }
        modify("Deferral Code")
        {
            Visible = false;
        }
        modify("Bal. Account Type")
        {
            Visible = false;
        }
        modify("Bal. Account No.")
        {
            Visible = false;
        }
        modify("Bal. Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Bal. Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        addlast(Control1)
        {
            field(SystemCreatedBy; GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
            }
        }
    }
    local procedure GetUserName(GuidPar: Guid): Text
    var
        UserRec: Record User;
    begin
        if UserRec.Get(GuidPar) then
            exit(UserRec."Full Name")
        else
            exit('');
    end;
}

