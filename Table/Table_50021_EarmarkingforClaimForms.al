table 50021 "Earmarking Claim Forms Table"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Earmarking for Claim Forms";
    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Earmark ID"; Text[25]) { }
        field(3; "Date Earmarked"; Date) { }
        field(4; "G/L Account Earmarked"; Code[20])
        {
            TableRelation = "G/L Account";
            trigger OnValidate()
            var
                grecPurchPayableSetup: Record "Purchases & Payables Setup";
                gtextEarmarkID: Text;
                gtextCounter: Text;
                grecPurchHeader: Record "Purchase Header";
                grecGLAccount: Record "G/L Account";
            begin
                clear(gtextEarmarkID);
                grecPurchPayableSetup.Get;
                gtextEarmarkID := 'R' + FORMAT(Today, 0, '<Year4><Month,2><Day,2>');

                if grecPurchPayableSetup."EarmarkID Counter Date" <> Today then begin
                    grecPurchPayableSetup."EarmarkID Counter" := 1;
                    grecPurchPayableSetup."EarmarkID Counter Date" := Today;
                end else
                    grecPurchPayableSetup."EarmarkID Counter" += 1;
                grecPurchPayableSetup.Modify;

                gtextCounter := format(grecPurchPayableSetup."EarmarkID Counter");
                gtextEarmarkID += PADSTR('', 3 - STRLEN(gtextCounter), '0') + gtextCounter;
                "Earmark ID" := gtextEarmarkID;
                "Date Earmarked" := Today;
                "Earmarked By" := UserId;
                Active := true;

                if grecGLAccount.get("G/L Account Earmarked") then
                    "G/L Description" := grecGLAccount.Name;

            end;
        }
        field(5; "Earmarked By"; text[50]) { }
        field(6; "Amount Earmarked"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Remaining Amount Earmarked" = 0 then
                    "Remaining Amount Earmarked" := "Amount Earmarked"
                else
                    if Confirm('Do you want to update field Remaining Amount also?', true) then
                        "Remaining Amount Earmarked" := "Amount Earmarked";
            end;
        }
        field(7; Description; Text[100]) { }
        field(8; Active; Boolean) { }
        field(9; "G/L Description"; Text[100]) { }
        field(10; "Remaining Amount Earmarked"; Decimal) { }

        field(15; "Date From"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Date To"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; Marked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}