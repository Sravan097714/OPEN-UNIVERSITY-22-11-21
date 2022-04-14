page 50075 "Fixed Asset Inventories List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableView = where(archived = const(false), Updated = const(false));
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
                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Created by"; "Created by")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                // field()
                field("Created On"; "Created On")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                // part("Process FA Location"; "Process Fixed Asset Inventory")
                // {
                //     ApplicationArea = all;
                //     SubPageLink = "FA Inventory No." = field("FA Inventory No.");
                // }

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
                PromotedIsBig = true;
                RunObject = Page "Process Fixed Asset Inventory";
                RunPageLink = "FA Inventory No." = field("FA Inventory No.");
                // trigger OnAction();
                // var
                //     ProcessFAInventoryPage: Page "Process Fixed Asset Inventory";
                //     FixedAssetInventories: record "Fixed Asset Inventories";
                // begin8
                //     FixedAssetInventories.SetRange("FA Inventory No.", rec."FA Inventory No.");
                //     ProcessFAInventoryPage.SetRecord(FixedAssetInventories);
                //     ProcessFAInventoryPage.SetTableView(FixedAssetInventories);
                //     ProcessFAInventoryPage.InitFANos(rec."FA Inventory No.");
                //     ProcessFAInventoryPage.Run();

                // end;
            }


        }

    }
    var
        FASetup: Record "FA Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FAInventoryListrec: record "FA Inventory List";

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean

    begin
        "Created by" := UserId;
        "Created On" := CurrentDateTime;
    end;


    procedure AssistEdit(OldFAInventoryList: Record "FA Inventory List"): Boolean
    begin
        with FAInventoryListrec do begin
            FAInventoryListrec := Rec;
            FASetup.Get();
            FASetup.TestField("FA Inventory");
            if NoSeriesMgt.SelectSeries(FASetup."FA Inventory", OldFAInventoryList."FA Inventory No.", "FA Inventory No.") then begin
                FASetup.Get();
                FASetup.TestField("FA Inventory");
                NoSeriesMgt.SetSeries("FA Inventory No.");
                Rec := FAInventoryListrec;
                exit(true);
            end;
        end;
    end;
}