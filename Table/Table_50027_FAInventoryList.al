table 50027 "FA Inventory List"
{


    fields
    {
        field(1; "FA Inventory No."; Code[10])
        {
            trigger OnValidate()
            var
                FASetup: Record "FA Setup";
                NoSeriesManagement: Codeunit NoSeriesManagement;
            begin
                if "FA Inventory No." = '' then begin
                    FASetup.Get();
                    FASetup.TestField("FA Inventory");
                    NoSeriesManagement.TestManual(FASetup."FA Inventory");
                end;
            end;
        }
        field(2; "Created by"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(5; Archived; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Archived on"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(7; "Archived By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; Updated; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Update By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Updated on"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }

    keys
    {
        key(PK; "FA Inventory No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    var
        FASetup: Record "FA Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        if "FA Inventory No." = '' then begin
            FASetup.Get();
            FASetup.TestField("FA Inventory");
            NoSeriesManagement.InitSeries(FASetup."FA Inventory", FASetup."FA Inventory", WorkDate(), "FA Inventory No.", FASetup."FA Inventory");
        end;
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