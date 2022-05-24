codeunit 50005 "Upload Module Process"
{
    TableNo = "Module Upload";

    trigger OnRun()
    begin
        ModuleUpload := Rec;

        if ValidatedUploadModule(ModuleUpload) then
            CreateItem(ModuleUpload);

        Rec := ModuleUpload;

    end;

    procedure ValidatedUploadModule(var ModuleUploadLRec: Record "Module Upload"): Boolean
    var
        Item: Record Item;
    begin
        Item.Reset();
        Item.SetRange("No.", ModuleUploadLRec."No.");
        if not Item.IsEmpty then
            Error('Module Item Already exists %1', ModuleUploadLRec."No.");
        exit(true);
    end;

    procedure CreateItem(var ModuleUploadLRec: Record "Module Upload")
    var
        ItemLRec: Record Item;
    begin
        ItemLRec.Init();
        ItemLRec.Validate("No.", ModuleUploadLRec."No.");
        ItemLRec.Validate(Description, ModuleUploadLRec.Description);
        ItemLRec.Validate("Common Module Code", ModuleUploadLRec."Common Module Code");
        ItemLRec.Validate(Credit, ModuleUploadLRec.Credit);
        ItemLRec.Validate(Year, ModuleUploadLRec.Year);
        ItemLRec.Validate(Semester, ModuleUploadLRec.Semester);
        ItemLRec.Insert(true);
        //Default Values
        ItemLRec."Search Description" := ModuleUploadLRec.Description;
        ItemLRec.Validate("Base Unit of Measure", 'UNIT');
        ItemLRec.Validate(Type, ItemLRec.Type::Service);
        ItemLRec.Validate("Costing Method", ItemLRec."Costing Method"::FIFO);
        ItemLRec.Validate("Gen. Prod. Posting Group", 'MODULE');
        ItemLRec.Validate("VAT Prod. Posting Group", 'VAT');
        ItemLRec.Validate("Stockout Warning", ItemLRec."Stockout Warning"::Yes);
        ItemLRec.Validate("Prevent Negative Inventory", ItemLRec."Prevent Negative Inventory"::Yes);
        ItemLRec.Validate(Module, true);
        ItemLRec.Validate("Item Type", 'MODULE');
        ItemLRec.Modify(true);
        ModuleUploadLRec."NAV Doc No." := ItemLRec."No.";
        ModuleUploadLRec.Modify();

    end;

    var
        ModuleUpload: Record "Module Upload";

}
