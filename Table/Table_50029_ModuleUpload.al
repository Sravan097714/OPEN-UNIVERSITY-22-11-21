table 50029 "Module Upload"
{
    Caption = 'Module Upload';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(4; "Common Module Code"; Code[50])
        {
            Caption = 'Common Module Code';
            DataClassification = ToBeClassified;
        }
        field(5; Credit; Decimal)
        {
            Caption = 'Credit';
            DataClassification = ToBeClassified;
        }
        field(6; Year; Decimal)
        {
            Caption = 'Year';
            DataClassification = ToBeClassified;
        }
        field(7; Semester; Integer)
        {
            Caption = 'Semester';
            DataClassification = ToBeClassified;
        }
        field(8; Error; Text[250])
        {
            Caption = 'Error';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "NAV Doc No."; code[20])
        {
            Caption = 'NAV Doc No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
