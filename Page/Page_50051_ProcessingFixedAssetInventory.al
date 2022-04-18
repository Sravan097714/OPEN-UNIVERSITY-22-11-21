page 50051 "Process Fixed Asset Inventory"
{
    // AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTableView = where(archived = const(false));
    SourceTable = "Fixed Asset Inventories";
    Caption = 'Processing Fixed Asset Inventory';


    layout
    {
        area(Content)
        {
            repeater("Fixed Asset")
            {


                field("Fixed Asset No."; "Fixed Asset No.") { ApplicationArea = All; Editable = false; }
                field(Description; Description) { ApplicationArea = All; Editable = false; }
                field("FA Class Code"; "FA Class Code") { ApplicationArea = ALl; Editable = false; }
                field("FA Subclass Code"; "FA Subclass Code") { ApplicationArea = all; Editable = false; }

                field("Serial No."; "Serial No.") { ApplicationArea = All; Editable = false; }
                field(Make; Make) { ApplicationArea = All; Editable = false; }
                field(Model; Model) { ApplicationArea = All; Editable = false; }
                field("Insurance Type"; "Insurance Type") { ApplicationArea = ALl; Editable = false; }
                field("Scanned By"; "Scanned By") { ApplicationArea = All; Editable = false; }
                field("Scanned On"; "Scanned On") { ApplicationArea = All; Editable = false; }
                field("FA Location Code"; "FA Location Code")
                {
                    ApplicationArea = All;
                    Editable = FALocationEditable;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FALocationPage: Page "FA Locations";
                        FAlocationRec: Record "FA Location";
                        FAInventories: record "Fixed Asset Inventories";
                        FirstLine: Integer;
                    begin
                        FAlocationRec.Reset();
                        Clear(FALocationPage);

                        FALocationPage.SetTableView(FAlocationRec);
                        FALocationPage.SetRecord(FAlocationRec);
                        FALocationPage.lookupmode(true);
                        if FALocationPage.RunModal() = Action::LookupOK then begin
                            FALocationPage.GetRecord(FAlocationRec);
                            "FA Location Code" := FAlocationRec.Code;
                        end;

                        Clear(FirstLine);
                        FAInventories.Reset();
                        FAInventories.SetRange("FA Inventory No.", REC."FA Inventory No.");
                        IF FAInventories.FindFirst() then
                            FirstLine := FAInventories."Entry No.";

                        if Rec."Entry No." = FirstLine then begin
                            FAInventories.Reset();
                            FAInventories.SetRange("FA Inventory No.", Rec."FA Inventory No.");
                            FAInventories.SetFilter("Entry No.", '<>%1', FirstLine);
                            if FAInventories.FindSet() then begin
                                repeat
                                    FAInventories."FA Location Code" := Rec."FA Location Code";
                                    FAInventories.Modify();
                                until FAInventories.Next() = 0;
                            end;

                        end;



                    end;
                }
                field("Scan Here"; "Scan Here")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        FixedAsset: Record "Fixed Asset";
                        FAInventory: record "Fixed Asset Inventories";
                    begin
                        if "Scan Here" <> '' then begin
                            "Scanned By" := UserId;
                            "Scanned On" := CurrentDateTime;
                            if FixedAsset.Get("Scan Here") then begin
                                "Fixed Asset No." := FixedAsset."No.";
                                Description := FixedAsset.Description;
                                "FA Class Code" := FixedAsset."FA Class Code";
                                "Serial No." := FixedAsset."Serial No.";
                                "FA Subclass Code" := FixedAsset."FA Subclass Code";
                                Make := FixedAsset.Make;
                                Model := FixedAsset.Model;
                                "Insurance Type" := FixedAsset."Insurance Type";

                                FAInventory.Reset();
                                FAInventory.SetRange("FA Inventory No.", Rec."FA Inventory No.");
                                if FAInventory.FindFirst() then
                                    "FA Inventory No." := FAInventory."FA Inventory No.";




                            end else
                                Message('Asset %1 does not exist in Fixed asset list', "Scan Here");
                        end;
                        CurrPage.Update();

                    end;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Update Location Code")
            {
                ApplicationArea = Basic, Suite;
                PromotedIsBig = true;
                Promoted = true;
                Enabled = not Updated;
                PromotedCategory = Process;
                Image = UpdateDescription;

                trigger OnAction();
                var
                    FixedAssetRec: record "Fixed Asset";
                    ConfirmManagement: Codeunit "Confirm Management";
                    FixedAssetInvRec: Record "Fixed Asset Inventories";
                    FAInventoryList: Record "FA Inventory List";
                    Text001: Label 'Do you want to update location code on the fixed assets on the page?';
                begin

                    if not ConfirmManagement.GetResponseOrDefault(Text001, true) then
                        exit;

                    with FixedAssetInvRec do begin
                        SetRange("FA Inventory No.", rec."FA Inventory No.");
                        if Find('-') then begin
                            repeat
                                FixedAssetRec.Reset();
                                if FixedAssetRec.Get("Fixed Asset No.") then
                                    if "FA Class Code" <> '' then begin
                                        FixedAssetRec."FA Location Code" := "FA Location Code";
                                        FixedAssetRec.Validate("FA Location Code");
                                        FixedAssetRec.Modify();
                                    end;
                            until Next() = 0
                        end;
                    end;

                    FixedAssetInvRec.Reset();
                    with FixedAssetInvRec do begin
                        SetRange("FA Inventory No.", Rec."FA Inventory No.");
                        if FindSet() then begin
                            repeat
                                Updated := true;
                                "Update By" := UserId;
                                "Updated on" := CurrentDateTime;
                                Modify();
                            until Next() = 0;
                        end;
                    end;

                    FAInventoryList.Reset();
                    if FAInventoryList.Get(Rec."FA Inventory No.") then begin
                        FAInventoryList.Updated := true;
                        FAInventoryList."Update By" := UserId;
                        FAInventoryList."Updated on" := CurrentDateTime;
                        FAInventoryList.Modify();
                    end;

                    CurrPage.Update();

                    Message('Location Code has been updated on all fixed assets on the page');
                end;
            }
            action("Archive Data")
            {
                ApplicationArea = All;
                PromotedIsBig = true;
                Promoted = true;
                Enabled = not Updated;
                PromotedCategory = Process;
                Image = Archive;
                trigger OnAction();
                var
                    FAAssetInventoriesRec: Record "Fixed Asset Inventories";
                    FAInventoryListRec: record "FA Inventory List";
                    ArchivedFixedAssetInventory: page "Archived Fixed Asset Inventory";
                    FAAssetinventoryList: Page "Fixed Asset Inventories List";
                    FAInvNo: Code[10];
                begin
                    Clear(FAInvNo);
                    FAInvNo := Rec."FA Inventory No.";
                    FAAssetInventoriesRec.Reset();
                    FAAssetInventoriesRec.SetRange("FA Inventory No.", Rec."FA Inventory No.");
                    if FAAssetInventoriesRec.FindSet() then begin
                        repeat
                            FAAssetInventoriesRec.Archived := true;
                            FAAssetInventoriesRec."Archived By" := UserId;
                            FAAssetInventoriesRec."Archived on" := CurrentDateTime;
                            FAAssetInventoriesRec.Modify();
                        until FAAssetInventoriesRec.Next() = 0;
                        Message('Inventory %1 has been archived.', Rec."FA Inventory No.");

                    end;
                    FAInventoryListRec.Reset();
                    FAInventoryListRec.SetRange("FA Inventory No.", Rec."FA Inventory No.");
                    if FAInventoryListRec.FindFirst() then begin
                        FAInventoryListRec.Archived := true;
                        FAInventoryListRec."Archived By" := UserId;
                        FAInventoryListRec."Archived on" := CurrentDateTime;
                        FAInventoryListRec.Modify();
                    end;


                    FAAssetInventoriesRec.Reset();
                    FAAssetInventoriesRec.SetRange("FA Inventory No.", FAInvNo);
                    ArchivedFixedAssetInventory.SetTableView(FAAssetInventoriesRec);
                    // ArchivedFixedAssetInventory.SetRecord(FAAssetInventoriesRec);
                    ArchivedFixedAssetInventory.Run();


                    CurrPage.Close();
                    FAAssetinventoryList.Update();

                end;
            }
            action("Enable FA Location Code")
            {
                ApplicationArea = All;
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    FALocationEditable := true;
                    CurrPage.Update();
                end;
            }
            action("Disable FA Location Code")
            {
                ApplicationArea = All;
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    FALocationEditable := false;
                    CurrPage.Update();
                end;
            }
        }
    }
    var
        FANosGlobal: Code[10];
        FALocationEditable: Boolean;
        Scan: Boolean;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean

    begin
        if FANosGlobal <> '' then
            "FA Inventory No." := FANosGlobal;
    end;



    procedure InitFANos(FANosLocal: Code[10])
    begin
        FANosGlobal := FANosLocal;
    end;

    trigger OnOpenPage()
    begin
        FALocationEditable := false;
    end;

}