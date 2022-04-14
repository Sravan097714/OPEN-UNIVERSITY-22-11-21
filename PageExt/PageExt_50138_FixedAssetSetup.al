pageextension 50138 "Fixed Asset SetupExt" extends "Fixed Asset Setup"
{
    layout
    {
        addafter("Insurance Nos.")
        {
            field("FA Inventory"; "FA Inventory")
            {
                Caption = 'FA Inventory Nos';
                ApplicationArea = all;
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}