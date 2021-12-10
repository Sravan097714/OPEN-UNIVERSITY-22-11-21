table 50025 "Bank Details"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Bank List";
    fields
    {
        field(1; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Bank Name"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Bank Address"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Bank Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Contact Title"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Contact Name"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Contact Department"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Bank Code")
        {
            Clustered = true;
        }

    }
    fieldgroups
    {
        fieldgroup(DropDown; "Bank Code", "Bank Name", "Bank Account No.")
        {
        }
        fieldgroup(Brick; "Bank Code", "Bank Name", "Bank Account No.")
        {
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}