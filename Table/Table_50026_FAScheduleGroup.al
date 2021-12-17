table 50026 "FA Schedule Grouping"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Report Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FA Schedule Grouping"."Report Type";
            ValidateTableRelation = false;
        }
        field(2; "Group Code"; Code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "FA Posting Filters"; Text[250])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Report Type", "Group Code")
        {
            Clustered = true;
        }
    }
}