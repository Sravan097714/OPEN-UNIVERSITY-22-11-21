table 50016 "G/L Budget by Account Category"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Account Category"; Enum "G/L Account Category") { }
        field(3; Description; Text[250]) { }
        field(4; "Original Budgeted Amt for Year"; Decimal)
        {
            Caption = 'Original Budgeted Amount for the Year';
        }
        field(5; "Revised Amount for Year (1)"; Decimal)
        {
            Caption = 'Revised Amount for the Year (1)';
        }
        field(6; "Revised Amount for Year (2)"; Decimal)
        {
            Caption = 'Revised Amount for the Year (2)';
        }
        field(7; "Revised Amount for Year (3)"; Decimal)
        {
            Caption = 'Revised Amount for the Year (3)';
        }
        field(8; "Revised Amount for Year (4)"; Decimal)
        {
            Caption = 'Revised Amount for the Year (4)';
        }
        field(9; "Revised Amount for Year (5)"; Decimal)
        {
            Caption = 'Revised Amount for the Year (5)';
        }
        field(10; "Revised Amount for Year (6)"; Decimal)
        {
            Caption = 'Revised Amount for the Year (6)';
        }
        field(11; "Final Budgeted Amount for Year"; Decimal)
        {
            Caption = 'Final Budgeted Amount for the Year';
        }
        field(12; "Actual Amount used for Year"; Decimal)
        {
            Caption = 'Actual Amount used for the Year';
        }
        field(13; "Budgeted Amt on Purch Orders"; Decimal)
        {
            Caption = 'Budgeted Amount Used on Open Released Purchase Orders';
        }
        field(14; "Remaining Amount for the Year"; Decimal) { }
        field(15; "Budget Category"; Code[20])
        {
            TableRelation = "Budget Category"."Budget Category Code";
            trigger OnValidate()
            Var
                BudgetCategory: Record "Budget Category";
            begin
                if BudgetCategory.Get("Budget Category") then
                    Description := BudgetCategory.Description;
            end;
        }
        field(16; "Budget Name"; Text[250]) { }
        field(17; "Date From"; Date) { }
        field(18; "Date To"; Date) { }
        field(19; "Plan Budget for Curr. Year 1"; Decimal)
        {
            Caption = 'Planned Budget for Current Year + 1';
            DataClassification = ToBeClassified;
        }
        field(20; "Plan Budget for Curr. Year 2"; Decimal)
        {
            Caption = 'Planned Budget for Current Year + 2';
            DataClassification = ToBeClassified;
        }
        field(21; "Plan Budget for Curr. Year 3"; Decimal)
        {
            Caption = 'Planned Budget for Current Year + 3';
            DataClassification = ToBeClassified;
        }
        field(22; "Line no."; Integer)
        {
            ObsoleteState = Removed;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        // key(PK2; "Line no.")
        // {

        // }
    }

}