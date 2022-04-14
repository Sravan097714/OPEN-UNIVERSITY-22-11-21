tableextension 50066 "FA SetupExt" extends "FA Setup"
{
    fields
    {
        field(50000; "FA Inventory"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        // Add changes to table fields here
    }

    var
        myInt: Integer;
}