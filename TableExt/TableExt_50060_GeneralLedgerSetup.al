tableextension 50060 GenLedgerSetupExt extends "General Ledger Setup"
{
    fields
    {
        field(50000; "VAT %"; Decimal) { }
        field(50001; "Name of Bank"; text[50])
        {
            Caption = 'Name of Bank';
        }
        field(50002; "Account to Credit"; Text[20]) { }
    }
}