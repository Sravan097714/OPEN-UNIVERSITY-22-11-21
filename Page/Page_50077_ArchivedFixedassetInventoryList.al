page 50077 "Archiv Asset Inventories List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    Caption = 'Archived Fixed Asset Inventory List';
    SourceTableView = where(archived = const(true));
    SourceTable = "FA Inventory List";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("FA Inventory No."; "FA Inventory No.")
                {
                    ApplicationArea = all;
                }
                field("Archived By"; "Archived By")
                {
                    ApplicationArea = all;
                }
                field("Archived on"; "Archived on")
                {
                    ApplicationArea = all;
                }

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ProcessFAInventory)
            {
                Caption = 'Process Fixed Asset Inventory';
                ApplicationArea = All;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Archived Fixed Asset Inventory";
                RunPageLink = "FA Inventory No." = field("FA Inventory No.");

            }

        }

    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        FASetup: Record "FA Setup";
    begin
        "Created by" := UserId;
        "Created On" := CurrentDateTime;
    end;
}