page 50042 "G/L Budget by Account Category"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "G/L Budget by Account Category";

    layout
    {
        area(Content)
        {
            group(" ")
            {
                field("Budget Name"; gtextBudgetName)
                {
                    ApplicationArea = All;
                    TableRelation = "G/L Budget Name";

                    /*trigger OnLookup(var Text: Text): Boolean
                    var
                        grecBudgetCategory: Record "Budget Category";
                        grecGLBudgetByAccCategory: Record "G/L Budget by Account Category";
                    begin
                        if gtextBudgetName <> '' then begin
                            grecBudgetCategory.Reset();
                            grecBudgetCategory.SetRange("Budget Category Code");
                            if grecBudgetCategory.FindFirst() then begin
                                repeat
                                    grecGLBudgetByAccCategory.Init();
                                    grecGLBudgetByAccCategory."Budget Name" := gtextBudgetName;
                                    grecGLBudgetByAccCategory."Budget Category" := grecBudgetCategory."Budget Category Code";
                                    grecGLBudgetByAccCategory.Description := grecBudgetCategory.Description;
                                    grecGLBudgetByAccCategory.Insert;
                                until grecBudgetCategory.Next = 0;
                            end;
                        end;
                    end;*/

                    trigger OnValidate()
                    var
                        grecBudgetCategory: Record "Budget Category";
                        grecGLBudgetByAccCategory: Record "G/L Budget by Account Category";
                        grecGLBudgetByAccCategory2: Record "G/L Budget by Account Category";
                        EntryNo: Integer;
                    begin
                        if gtextBudgetName <> '' then begin
                            grecGLBudgetByAccCategory2.Reset();
                            if grecGLBudgetByAccCategory2.FindLast() then
                                EntryNo := grecGLBudgetByAccCategory2."Entry No." + 1
                            else
                                EntryNo := 1;
                            grecBudgetCategory.Reset();
                            grecBudgetCategory.SetRange("Budget Category Code");
                            if grecBudgetCategory.FindFirst() then begin
                                repeat
                                    grecGLBudgetByAccCategory2.Reset();
                                    grecGLBudgetByAccCategory2.SetRange("Budget Name", gtextBudgetName);
                                    grecGLBudgetByAccCategory2.SetRange("Budget Category", grecBudgetCategory."Budget Category Code");
                                    if not grecGLBudgetByAccCategory2.FindFirst() then begin
                                        grecGLBudgetByAccCategory.Init();
                                        grecGLBudgetByAccCategory."Entry No." := EntryNo;
                                        grecGLBudgetByAccCategory."Budget Name" := gtextBudgetName;
                                        grecGLBudgetByAccCategory."Budget Category" := grecBudgetCategory."Budget Category Code";
                                        grecGLBudgetByAccCategory.Description := grecBudgetCategory.Description;
                                        grecGLBudgetByAccCategory.Insert();
                                        EntryNo += 1;
                                    end;
                                until grecBudgetCategory.Next = 0;
                            end;
                        end;
                        CurrPage.Update(true);
                    end;
                }
                field("Date From"; gdateDateFrom)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Date To"; gdateDateTo)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Budget Column to Use"; genumBudgetToUse)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = all;
                }
                field(Remarks2; Remarks2)
                {
                    ApplicationArea = all;
                }
            }
            repeater(GroupName)
            {
                field("Budget Category"; "Budget Category")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(Description; Description) { ApplicationArea = All; }
                field("Original Budgeted Amt for Year"; "Original Budgeted Amt for Year") { ApplicationArea = All; }
                field("Revised Amount for Year (1)"; "Revised Amount for Year (1)") { ApplicationArea = All; }
                field("Revised Amount for Year (2)"; "Revised Amount for Year (2)") { ApplicationArea = All; }
                field("Revised Amount for Year (3)"; "Revised Amount for Year (3)") { ApplicationArea = All; }
                field("Revised Amount for Year (4)"; "Revised Amount for Year (4)") { ApplicationArea = All; }
                field("Revised Amount for Year (5)"; "Revised Amount for Year (5)") { ApplicationArea = All; }
                field("Revised Amount for Year (6)"; "Revised Amount for Year (6)") { ApplicationArea = All; }
                field("Final Budgeted Amount for Year"; "Final Budgeted Amount for Year") { ApplicationArea = All; }
                field("Plan Budget for Curr. Year+ 1"; "Plan Budget for Curr. Year 1") { ApplicationArea = All; }
                field("Plan Budget for Curr. Year+ 2"; "Plan Budget for Curr. Year 2") { ApplicationArea = All; }
                field("Plan Budget for Curr. Year+ 3"; "Plan Budget for Curr. Year 3") { ApplicationArea = All; }
                field("Actual Amount used for Year"; gdecActualAmt)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        grecGLEntry.Reset();
                        grecGLEntry.SetRange("Posting Date", gdateDateFrom, gdateDateTo);
                        grecGLEntry.SetRange("Budget Category", "Budget Category");
                        if grecGLEntry.FindSet then;
                        gpageGLEntry.SetTableView(grecGLEntry);
                        gpageGLEntry.Run();
                    end;
                }
                field("Budgeted Amt on Released Purch Orders"; gdecBudgetedAmtUsed) { Editable = false; ApplicationArea = All; }
                field("Active Remaining Amount Earmarked"; ActiveRemainingAmountEarmarked)
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        GLAccount.Reset();
                        GLAccount.SetRange("Budget Category", "Budget Category");
                        if GLAccount.FindSet() then
                            repeat
                                grecEarmarkingClaim.Reset();
                                grecEarmarkingClaim.SetRange("G/L Account Earmarked", GLAccount."No.");
                                grecEarmarkingClaim.SetRange(Active, true);
                                if grecEarmarkingClaim.FindSet() then
                                    repeat
                                        grecEarmarkingClaim.Mark(true)
                                    until grecEarmarkingClaim.Next() = 0;
                            until GLAccount.Next() = 0;
                        grecEarmarkingClaim.MarkedOnly(true);
                        Page.RunModal(50061, grecEarmarkingClaim)
                    end;
                }
                field("Remaining Amount for the Year"; gdecRemainingAmt) { Editable = false; ApplicationArea = All; }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Export Budget")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = ExportToExcel;

                trigger OnAction();
                var
                    grepExportBudget: Report "Export Budget";
                begin
                    grepExportBudget.SetBudgetName(gtextBudgetName, genumBudgetToUse, gdateDateFrom, gdateDateTo);
                    grepExportBudget.Run();
                end;
            }
            action("Import Budget")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = ImportExcel;

                trigger OnAction();
                begin
                    Report.Run(50084);
                end;
            }

            action("Print G/L Budget")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = PrintReport;

                trigger OnAction();
                var
                    grepGLBudgetReport: Report "G/L Budget Report";
                begin
                    grepGLBudgetReport.SetBudgetName(gtextBudgetName);
                    grepGLBudgetReport.Run();
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Budget Name" := gtextBudgetName;
    end;

    trigger OnAfterGetRecord()
    begin
        SetRange("Budget Name", gtextBudgetName);
        SetFilter("Budget Category", '<>%1', '');
        Clear(gdecActualAmt);
        Clear(gdecBudgetedAmtUsed);
        Clear(gdecRemainingAmt);

        grecGLEntry.Reset();
        grecGLEntry.SetRange("Posting Date", gdateDateFrom, gdateDateTo);
        grecGLEntry.SetRange("Budget Category", "Budget Category");
        if grecGLEntry.FindSet then begin
            repeat
                gdecActualAmt += grecGLEntry.Amount;
            until grecGLEntry.Next = 0;
        end;


        grecPurchHeader.Reset();
        grecPurchHeader.SetCurrentKey("Document Type", "No.");
        grecPurchHeader.SetRange("Document Type", grecPurchHeader."Document Type"::Order);
        grecPurchHeader.SetRange(Status, grecPurchHeader.Status::Released);
        if grecPurchHeader.FindFirst() then begin
            repeat
                grecPurchLine.Reset();
                grecPurchLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                grecPurchLine.SetRange("Document No.", grecPurchHeader."No.");
                grecPurchLine.SetRange("Budget Category", "Budget Category");
                if grecPurchLine.FindFirst() then begin
                    repeat
                        gdecBudgetedAmtUsed += grecPurchLine.Amount;
                    until grecPurchLine.Next = 0;
                end;
            until grecPurchHeader.Next = 0;
        end;


        case genumBudgetToUse of
            genumBudgetToUse::"Original Budgeted Amount for the Year":
                gdecRemainingAmt := "Original Budgeted Amt for Year";

            genumBudgetToUse::"Revised Amount for the Year (1)":
                gdecRemainingAmt := "Revised Amount for Year (1)";

            genumBudgetToUse::"Revised Amount for the Year (2)":
                gdecRemainingAmt := "Revised Amount for Year (2)";

            genumBudgetToUse::"Revised Amount for the Year (3)":
                gdecRemainingAmt := "Revised Amount for Year (3)";

            genumBudgetToUse::"Revised Amount for the Year (4)":
                gdecRemainingAmt := "Revised Amount for Year (4)";

            genumBudgetToUse::"Revised Amount for the Year (5)":
                gdecRemainingAmt := "Revised Amount for Year (5)";

            genumBudgetToUse::"Revised Amount for the Year (6)":
                gdecRemainingAmt := "Revised Amount for Year (6)";

            genumBudgetToUse::"Final Budgeted Amount for the Year":
                gdecRemainingAmt := "Final Budgeted Amount for Year";
        end;

        gdecRemainingAmt -= gdecActualAmt;
        gdecRemainingAmt -= gdecBudgetedAmtUsed;

        Clear(ActiveRemainingAmountEarmarked);
        GLAccount.Reset();
        GLAccount.SetRange("Budget Category", "Budget Category");
        if GLAccount.FindSet() then
            repeat
                grecEarmarkingClaim.Reset();
                grecEarmarkingClaim.SetRange("G/L Account Earmarked", GLAccount."No.");
                grecEarmarkingClaim.SetRange(Active, true);
                if grecEarmarkingClaim.FindSet() then begin
                    grecEarmarkingClaim.CalcSums("Remaining Amount Earmarked");
                    ActiveRemainingAmountEarmarked += grecEarmarkingClaim."Remaining Amount Earmarked";
                end;
            until GLAccount.Next() = 0;

    end;

    trigger OnAfterGetCurrRecord()
    begin
        Clear(gdecActualAmt);
        Clear(gdecBudgetedAmtUsed);
        Clear(gdecRemainingAmt);

        grecGLEntry.Reset();
        grecGLEntry.SetRange("Posting Date", gdateDateFrom, gdateDateTo);
        grecGLEntry.SetRange("Budget Category", "Budget Category");
        if grecGLEntry.FindSet then begin
            repeat
                gdecActualAmt += grecGLEntry.Amount;
            until grecGLEntry.Next = 0;
        end;


        grecPurchHeader.Reset();
        grecPurchHeader.SetCurrentKey("Document Type", "No.");
        grecPurchHeader.SetRange("Document Type", grecPurchHeader."Document Type"::Order);
        grecPurchHeader.SetRange(Status, grecPurchHeader.Status::Released);
        if grecPurchHeader.FindFirst() then begin
            repeat
                grecPurchLine.Reset();
                grecPurchLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                grecPurchLine.SetRange("Document No.", grecPurchHeader."No.");
                grecPurchLine.SetRange("Budget Category", "Budget Category");
                if grecPurchLine.FindFirst() then begin
                    repeat
                        gdecBudgetedAmtUsed += grecPurchLine.Amount;
                    until grecPurchLine.Next = 0;
                end;
            until grecPurchHeader.Next = 0;
        end;


        case genumBudgetToUse of
            genumBudgetToUse::"Original Budgeted Amount for the Year":
                gdecRemainingAmt := "Original Budgeted Amt for Year";

            genumBudgetToUse::"Revised Amount for the Year (1)":
                gdecRemainingAmt := "Revised Amount for Year (1)";

            genumBudgetToUse::"Revised Amount for the Year (2)":
                gdecRemainingAmt := "Revised Amount for Year (2)";

            genumBudgetToUse::"Revised Amount for the Year (3)":
                gdecRemainingAmt := "Revised Amount for Year (3)";

            genumBudgetToUse::"Revised Amount for the Year (4)":
                gdecRemainingAmt := "Revised Amount for Year (4)";

            genumBudgetToUse::"Revised Amount for the Year (5)":
                gdecRemainingAmt := "Revised Amount for Year (5)";

            genumBudgetToUse::"Revised Amount for the Year (6)":
                gdecRemainingAmt := "Revised Amount for Year (6)";

            genumBudgetToUse::"Final Budgeted Amount for the Year":
                gdecRemainingAmt := "Final Budgeted Amount for Year";
        end;

        gdecRemainingAmt -= gdecActualAmt;
        gdecRemainingAmt -= gdecBudgetedAmtUsed;
        Clear(ActiveRemainingAmountEarmarked);
        GLAccount.Reset();
        GLAccount.SetRange("Budget Category", "Budget Category");
        if GLAccount.FindSet() then
            repeat
                grecEarmarkingClaim.Reset();
                grecEarmarkingClaim.SetRange("G/L Account Earmarked", GLAccount."No.");
                grecEarmarkingClaim.SetRange(Active, true);
                if grecEarmarkingClaim.FindSet() then begin
                    grecEarmarkingClaim.CalcSums("Remaining Amount Earmarked");
                    ActiveRemainingAmountEarmarked += grecEarmarkingClaim."Remaining Amount Earmarked";
                end;
            until GLAccount.Next() = 0;
    end;


    var
        gtextBudgetName: Text[20];
        gdateDateFrom: Date;
        gdateDateTo: Date;
        genumBudgetToUse: Enum "Budget Account Category";


        grecGLEntry: Record "G/L Entry";
        gpageGLEntry: Page "General Ledger Entries";


        grecPurchHeader: Record "Purchase Header";
        grecPurchLine: Record "Purchase Line";
        gpagePurchLine: Page "Purchase Lines";


        gdecActualAmt: Decimal;
        gdecBudgetedAmtUsed: Decimal;
        gdecRemainingAmt: Decimal;
        ActiveRemainingAmountEarmarked: Decimal;
        GLAccount: Record "G/L Account";
        grecEarmarkingClaim: Record "Earmarking Claim Forms Table";
        Remarks: Text[150];
        Remarks2: Text[150];

}