tableextension 50041 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50000; "Common Module Code"; Code[20]) { }
        field(50001; Instalment; Boolean) { Editable = false; }
        field(50002; "Original Amount"; Decimal) { }
        field(50003; "Module Code"; Code[20]) { Editable = false; }
        field(50004; "Module Credit"; Decimal) { }
    }
}