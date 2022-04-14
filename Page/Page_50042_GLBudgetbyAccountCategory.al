page 50042 "G/L Budget by Account Category"
{
    PageType = List;
    AutoSplitKey = true;
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
                    trigger OnValidate()
                    var
                        grecBudgetCategory: Record "Budget Category";
                        grecGLBudgetByAccCategory: Record "G/L Budget by Account Category";
                        grecGLBudgetByAccCategory2: Record "G/L Budget by Account Category";
                        BudgetByAccount: record "G/L Budget by Account Category";
                        EntryNo: Integer;
                    begin
                        if gtextBudgetName <> '' then begin
                            //ktm
                            Clear(gdateDateFrom);
                            Clear(gdateDateTo);

                            SetRange("Budget Name", gtextBudgetName);
                            CurrPage.Update(false);
                            CurrPage.Editable(true);
                        end;
                    end;
                }
                field("Date From"; gdateDateFrom)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin

                        //CurrPage.Update(true);
                    end;
                }
                field("Date To"; gdateDateTo)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        //CurrPage.Update(true);
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
                field("Original Budgeted Amt for Year"; "Original Budgeted Amt for Year")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;

                }
                field("Revised Amount for Year (1)"; "Revised Amount for Year (1)")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;

                }
                field("Revised Amount for Year (2)"; "Revised Amount for Year (2)")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;

                }
                field("Revised Amount for Year (3)"; "Revised Amount for Year (3)")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Revised Amount for Year (4)"; "Revised Amount for Year (4)")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Revised Amount for Year (5)"; "Revised Amount for Year (5)")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Revised Amount for Year (6)"; "Revised Amount for Year (6)")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Final Budgeted Amount for Year"; "Final Budgeted Amount for Year")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Plan Budget for Curr. Year+ 1"; "Plan Budget for Curr. Year 1")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Plan Budget for Curr. Year+ 2"; "Plan Budget for Curr. Year 2")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Plan Budget for Curr. Year+ 3"; "Plan Budget for Curr. Year 3")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Actual Amount used for Year"; gdecActualAmt)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        GLEntryRec: Record "G/L Entry";
                    begin

                        // grecGLEntry.Reset();
                        // grecGLEntry.SetRange("Posting Date", gdateDateFrom, gdateDateTo);
                        // grecGLEntry.SetRange("Budget Category", "Budget Category");
                        // if grecGLEntry.FindSet then;
                        GLAccount.Reset();
                        GLAccount.SetRange("Budget Category", "Budget Category");
                        if GLAccount.Find('-') then begin
                            repeat
                                grecGLEntry.Reset();
                                grecGLEntry.SetRange("Posting Date", gdateDateFrom, gdateDateTo);
                                grecGLEntry.SetRange("G/L Account No.", GLAccount."No.");
                                if grecGLEntry.FindSet then begin
                                    repeat
                                        grecGLEntry.Mark(true);
                                    until grecGLEntry.Next = 0;
                                end;
                            until GLAccount.Next() = 0;
                        end;
                        grecGLEntry.MarkedOnly(true);
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
                                grecEarmarkingClaim.SetRange("Date From", gdateDateFrom);
                                grecEarmarkingClaim.SetRange("Date To", gdateDateTo);
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
    trigger OnOpenPage()
    var
        BudgetByAccount: record "G/L Budget by Account Category";
    begin
        BudgetByAccount.setfilter("Budget Category", '=%1', '');
        if BudgetByAccount.FindSet() then begin
            repeat
                BudgetByAccount.Delete();
            until BudgetByAccount.Next() = 0;
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        "Budget Name" := gtextBudgetName;
    end;

    trigger OnAfterGetRecord()
    var
        gdecActualAmtLocal: Decimal;
    begin
        SetRange("Budget Name", gtextBudgetName);
        SetFilter("Budget Category", '<>%1', '');
        Clear(gdecActualAmt);
        Clear(gdecActualAmtLocal);
        Clear(gdecBudgetedAmtUsed);
        Clear(gdecRemainingAmt);

        if "Budget Category" <> '' then begin

            //D
            GLAccount.Reset();
            GLAccount.SetRange("Budget Category", "Budget Category");
            if GLAccount.Find('-') then begin
                repeat
                    grecGLEntry.Reset();
                    grecGLEntry.SetRange("Posting Date", gdateDateFrom, gdateDateTo);
                    grecGLEntry.SetRange("G/L Account No.", GLAccount."No.");
                    if grecGLEntry.FindSet then begin
                        repeat
                            gdecActualAmtLocal += grecGLEntry.Amount;
                        until grecGLEntry.Next = 0;
                    end;

                    gdecActualAmt += gdecActualAmtLocal;
                until GLAccount.Next() = 0;
            end;


            //E
            grecPurchHeader.Reset();
            grecPurchHeader.SetCurrentKey("Document Type", "No.");
            grecPurchHeader.SetRange("Document Type", grecPurchHeader."Document Type"::Order);
            grecPurchHeader.SetRange("Order Date", gdateDateFrom, gdateDateTo);
            grecPurchHeader.SetRange(Status, grecPurchHeader.Status::Released);
            if grecPurchHeader.Findset() then begin
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



            //F
            Clear(ActiveRemainingAmountEarmarked);
            GLAccount.Reset();
            GLAccount.SetRange("Budget Category", "Budget Category");
            if GLAccount.FindSet() then
                repeat
                    grecEarmarkingClaim.Reset();
                    grecEarmarkingClaim.SetRange("G/L Account Earmarked", GLAccount."No.");
                    grecEarmarkingClaim.SetRange("Date From", gdateDateFrom);
                    grecEarmarkingClaim.SetRange("Date To", gdateDateTo);
                    grecEarmarkingClaim.SetRange(Active, true);
                    if grecEarmarkingClaim.FindSet() then begin
                        grecEarmarkingClaim.CalcSums("Remaining Amount Earmarked");
                        ActiveRemainingAmountEarmarked += grecEarmarkingClaim."Remaining Amount Earmarked";
                    end;
                until GLAccount.Next() = 0;

            // -(ActiveRemainingAmountEarmarked+gdecBudgetedAmtUsed+gdecActualAmt)
            //G
            case genumBudgetToUse of
                genumBudgetToUse::"Original Budgeted Amount for the Year":
                    gdecRemainingAmt := "Original Budgeted Amt for Year" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (1)":
                    gdecRemainingAmt := "Revised Amount for Year (1)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (2)":
                    gdecRemainingAmt := "Revised Amount for Year (2)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (3)":
                    gdecRemainingAmt := "Revised Amount for Year (3)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (4)":
                    gdecRemainingAmt := "Revised Amount for Year (4)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (5)":
                    gdecRemainingAmt := "Revised Amount for Year (5)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (6)":
                    gdecRemainingAmt := "Revised Amount for Year (6)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Final Budgeted Amount for the Year":
                    gdecRemainingAmt := "Final Budgeted Amount for Year" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);
            end;


        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        gdecActualAmtLocal: Decimal;
    begin
        SetRange("Budget Name", gtextBudgetName);
        SetFilter("Budget Category", '<>%1', '');
        Clear(gdecActualAmt);
        Clear(gdecActualAmtLocal);
        Clear(gdecBudgetedAmtUsed);
        Clear(gdecRemainingAmt);

        if "Budget Category" <> '' then begin

            //D
            GLAccount.Reset();
            GLAccount.SetRange("Budget Category", "Budget Category");
            if GLAccount.Find('-') then begin
                repeat
                    grecGLEntry.Reset();
                    grecGLEntry.SetRange("Posting Date", gdateDateFrom, gdateDateTo);
                    grecGLEntry.SetRange("G/L Account No.", GLAccount."No.");
                    if grecGLEntry.FindSet then begin
                        repeat
                            gdecActualAmtLocal += grecGLEntry.Amount;
                        until grecGLEntry.Next = 0;
                    end;

                    gdecActualAmt += gdecActualAmtLocal;
                until GLAccount.Next() = 0;
            end;


            //E
            grecPurchHeader.Reset();
            grecPurchHeader.SetCurrentKey("Document Type", "No.");
            grecPurchHeader.SetRange("Document Type", grecPurchHeader."Document Type"::Order);
            grecPurchHeader.SetRange("Order Date", gdateDateFrom, gdateDateTo);
            grecPurchHeader.SetRange(Status, grecPurchHeader.Status::Released);
            if grecPurchHeader.Findset() then begin
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



            //F
            Clear(ActiveRemainingAmountEarmarked);
            GLAccount.Reset();
            GLAccount.SetRange("Budget Category", "Budget Category");
            if GLAccount.FindSet() then
                repeat
                    grecEarmarkingClaim.Reset();
                    grecEarmarkingClaim.SetRange("G/L Account Earmarked", GLAccount."No.");
                    grecEarmarkingClaim.SetRange("Date From", gdateDateFrom);
                    grecEarmarkingClaim.SetRange("Date To", gdateDateTo);
                    grecEarmarkingClaim.SetRange(Active, true);
                    if grecEarmarkingClaim.FindSet() then begin
                        grecEarmarkingClaim.CalcSums("Remaining Amount Earmarked");
                        ActiveRemainingAmountEarmarked += grecEarmarkingClaim."Remaining Amount Earmarked";
                    end;
                until GLAccount.Next() = 0;

            // -(ActiveRemainingAmountEarmarked+gdecBudgetedAmtUsed+gdecActualAmt)
            //G
            case genumBudgetToUse of
                genumBudgetToUse::"Original Budgeted Amount for the Year":
                    gdecRemainingAmt := "Original Budgeted Amt for Year" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (1)":
                    gdecRemainingAmt := "Revised Amount for Year (1)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (2)":
                    gdecRemainingAmt := "Revised Amount for Year (2)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (3)":
                    gdecRemainingAmt := "Revised Amount for Year (3)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (4)":
                    gdecRemainingAmt := "Revised Amount for Year (4)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (5)":
                    gdecRemainingAmt := "Revised Amount for Year (5)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Revised Amount for the Year (6)":
                    gdecRemainingAmt := "Revised Amount for Year (6)" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);

                genumBudgetToUse::"Final Budgeted Amount for the Year":
                    gdecRemainingAmt := "Final Budgeted Amount for Year" - (ActiveRemainingAmountEarmarked + gdecBudgetedAmtUsed + gdecActualAmt);
            end;


        end;

    end;

    trigger OnClosePage()
    begin
        CurrPage.Update();
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

    procedure Setvalues(BugetNameP: Code[20])
    begin
        gtextBudgetName := BugetNameP;
    end;

}