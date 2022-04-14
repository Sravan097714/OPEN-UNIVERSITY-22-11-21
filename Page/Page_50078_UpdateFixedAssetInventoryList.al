page 50078 "Updated Fixed Asset Inv. List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    Editable = false;
    Caption = 'Updated Fixed Asset Inventory List';
    SourceTableView = where(archived = const(false), Updated = const(true));
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
                field("Update By"; "Update By")
                {
                    ApplicationArea = all;
                }
                field("Update on"; "Updated on")
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
            action(ProcessedFAInventory)
            {
                Caption = 'Processed Fixed Asset Inventory';
                ApplicationArea = All;
                Image = Process;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Processed Fixed Asset Inv.";
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