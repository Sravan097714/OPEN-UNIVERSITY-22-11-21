tableextension 50039 FALedgerEntryExt extends "FA Ledger Entry"
{
    fields
    {
        field(50000; "Created By"; Text[50]) { }
        field(50001; "FA Revaluation"; Boolean) { }
        field(50002; "Description 2"; Text[250]) { }
        field(50003; "FA Supplier No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Supplier No.';
            TableRelation = Vendor."No.";
        }
        field(50004; "Purch Rcpt No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
    }

    trigger OnInsert()
    var
        grecDeprBook: Record "Depreciation Book";
    begin
        if grecDeprBook.Get("Depreciation Book Code") then
            "FA Revaluation" := grecDeprBook."FA Revaluation";
    end;
}