tableextension 50023 PurchaseCueExt extends "Purchase Cue"
{
    fields
    {
        field(50000; "Retentions Due"; Integer)
        {
            Caption = 'Retentions Due';
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Order), "Retention Due Date" = field("Date filter"), Status = const(Released)));
            FieldClass = FlowField;
        }
    }
}
