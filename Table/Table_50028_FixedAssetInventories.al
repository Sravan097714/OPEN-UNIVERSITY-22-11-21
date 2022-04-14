table 50028 "Fixed Asset Inventories"
{

    fields
    {
        field(1; "Fixed Asset No."; Code[20]) { }
        field(2; Description; Text[100]) { }
        field(3; "FA Class Code"; Text[10]) { }
        field(4; "FA Location Code"; Text[10]) { }
        field(5; "Serial No."; Text[50]) { }
        field(6; Make; Text[50]) { }
        field(7; Model; Text[50]) { }
        field(8; "Insurance Type"; Text[50]) { }
        field(9; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(10; "Scanned By"; Code[50]) { Editable = false; }
        field(11; "Scanned On"; DateTime) { Editable = false; }
        field(12; "Scan Here"; Text[50])
        {
            trigger OnValidate()
            var
                FAInventoryRec: Record "Fixed Asset Inventories";
            begin
                if "FA Inventory No." <> '' then begin
                    FAInventoryRec.SetRange("FA Inventory No.", "FA Inventory No.");
                    if FAInventoryRec.FindFirst() then begin
                        "Created by" := FAInventoryRec."Created by";
                        "Created On" := FAInventoryRec."Created On";
                    end;
                end;
            end;
        }
        field(13; "FA Inventory No."; Code[10])
        {

        }
        field(14; "Created by"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Archived By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Archived on"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(18; Archived; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; Updated; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Update By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Updated on"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "FA Subclass Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }

    }


    keys
    {
        key(Key1; "FA Inventory No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "FA Inventory No.")
        {

        }
    }

}