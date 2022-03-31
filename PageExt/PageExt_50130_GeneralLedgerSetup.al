pageextension 50130 GeneralLedgerSetupExt extends "General Ledger Setup"
{
    layout
    {
        addlast(General)
        {
            field("VAT %"; "VAT %") { ApplicationArea = All; }
            field("Name of Bank"; Rec."Name of Bank")
            {
                ToolTip = 'Specifies the value of the Name of Bank field.';
                ApplicationArea = All;
            }
            field("Account to Credit"; Rec."Account to Credit")
            {
                ToolTip = 'Specifies the value of the Account to Credit field.';
                ApplicationArea = All;
            }
        }
    }
}