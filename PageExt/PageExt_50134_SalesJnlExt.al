pageextension 50134 SalesJnlExt extends "Sales Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Apply Entries")
        {
            action("Import Entries")
            {
                ApplicationArea = All;
                Caption = 'Import Entries';
                Promoted = true;
                PromotedCategory = Process;
                Image = Import;
                ToolTip = 'Import journal from desktop';

                trigger OnAction()
                var
                    GenImportData: Codeunit "Import Files";
                begin
                    GenImportData.SetJournalTemplateBatch(Rec."Journal Template Name", Rec."Journal Batch Name");
                    GenImportData.ImportPurchaseJnl();
                end;
            }
        }
    }

    var
        myInt: Integer;
}