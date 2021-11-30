table 50024 "OU Portal Import Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer) { AutoIncrement = true; Editable = false; }
        field(2; "Import Date"; DateTime) { }
        field(3; "Fees Type"; Text[100]) { }
        field(4; "Source File Path"; Text[250]) { }
        field(5; "Archive File Path"; Text[250]) { }
        field(6; "Rows Processed"; Integer) { }
        field(7; "Mail Sent"; Boolean) { }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}