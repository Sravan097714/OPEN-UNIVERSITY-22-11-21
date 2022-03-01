tableextension 50035 CustLedgerEntryExt extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Voucher No."; Text[50]) { }
        field(50001; "Created By"; Text[50]) { }
        field(50002; "Customer Category"; Text[50]) { }
        field(50003; "From OU Portal"; Boolean) { Editable = false; }
        field(50004; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
    }

    trigger OnInsert()
    var
        grecCustomer: Record Customer;
    begin
        if grecCustomer.get("Customer No.") then
            "Customer Category" := grecCustomer."Customer Category";
    end;
}