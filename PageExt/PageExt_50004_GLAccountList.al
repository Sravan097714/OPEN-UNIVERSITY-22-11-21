pageextension 50004 GLAccountList extends "G/L Account List"
{
    layout
    {
        modify("Account Category")
        {
            Visible = true;
            Editable = false;
        }
        modify("Reconciliation Account")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        addlast(Control1)
        {
            field("FA Acquisition"; "FA Acquisition")
            {
                ApplicationArea = all;
            }
            field("FA Acquisition 2"; "FA Acquisition 2")
            {
                ApplicationArea = all;
            }
            field("Budget Category"; "Budget Category") { ApplicationArea = All; }
        }
    }
}