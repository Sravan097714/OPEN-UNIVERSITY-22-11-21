report 50096 "Purchase Register Consolidated"
{
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            trigger OnPreDataItem()
            begin
                "Purchase Header".SetCurrentKey(Status);
                "Purchase Header".SetFilter("Order Date", gtextDate);
                "Purchase Header".SetRange("Document Type", "Document Type"::Order);
                "Purchase Header".SetRange(Claim, false);
                ExcelBuf.DeleteAll(false);
                MakeExcelDataHeader1();
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(EarMaskedAmount);
                grecPurchLine.Reset();
                grecPurchLine.SetRange("Document No.", "No.");
                if grecPurchLine.FindSet() then begin
                    grecPurchLine.CalcSums("Line Amount");
                    EarMaskedAmount := grecPurchLine."Line Amount";
                end;

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn("Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Buy-from Vendor No." + ' ' + "Buy-from Vendor Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Posting Description", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(grecPurchLine."Date Earmarked", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(EarMaskedAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn("Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                "Purchase Header".CalcFields("Amount Including VAT");
                ExcelBuf.AddColumn("Amount Including VAT", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                if grecNewCategories.Get('Purchase Header', 'Procurement Method', "Procurement Method") then
                    ExcelBuf.AddColumn(grecNewCategories.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
                else
                    ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Vendor Invoice No.", false, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Supplier Invoice Date", FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('Open', FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            end;

            trigger OnPostDataItem()
            begin
                //ExcelBuf.CreateNewBook('Open Purchase Orders');
                //ExcelBuf.WriteSheet('', '', '');
                //ExcelBuf.CreateNewBook('Open Purchase Orders');
                /* ExcelBuf.WriteSheet('', '', '');
                ExcelBuf.CloseBook();
                ExcelBuf.OpenExcel(); */
            end;
        }

        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            RequestFilterFields = "No.";
            trigger OnPreDataItem()
            begin
                // "Purch. Inv. Header".SetFilter("Posting Date", gtextDate);
                "Purch. Inv. Header".SetFilter("Order Date", gtextDate);
                "Purch. Inv. Header".SetRange(Claim, false);
                //ExcelBuf.DeleteAll(false);
                //ExcelBuf.SelectOrAddSheet('Posted Purchase Invoices');

                //MakeExcelDataHeader2();
            end;

            trigger OnAfterGetRecord()
            var
                lrecDetVendLedgerEntry: Record "Detailed Vendor Ledg. Entry";
                lrecDetVendLedgerEntry2: Record "Detailed Vendor Ledg. Entry";
                lrecVendorLedgerEntry: Record "Vendor Ledger Entry";
            begin
                Clear(EarMaskedAmount);
                grecPurchInvLine.Reset();
                grecPurchInvLine.SetRange("Document No.", "No.");
                if grecPurchInvLine.FindSet() then begin
                    grecPurchInvLine.CalcSums("Line Amount");
                    EarMaskedAmount := grecPurchInvLine."Line Amount";
                end;
                if ("Vendor Posting Group" = 'PAYROLL') or ("Order No." = '') then
                    CurrReport.Skip();
                ExcelBuf.NewRow;
                ExcelBuf.AddColumn("Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Buy-from Vendor No." + ' ' + "Buy-from Vendor Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Posting Description", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(grecPurchInvLine."Date Earmarked", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(EarMaskedAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                ExcelBuf.AddColumn("Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                "Purch. Inv. Header".CalcFields("Amount Including VAT");
                ExcelBuf.AddColumn("Amount Including VAT", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                lrecDetVendLedgerEntry.Reset();
                lrecDetVendLedgerEntry.SetRange("Document Type", lrecDetVendLedgerEntry."Document Type"::Invoice);
                lrecDetVendLedgerEntry.SetRange("Entry Type", lrecDetVendLedgerEntry."Entry Type"::"Initial Entry");
                lrecDetVendLedgerEntry.SetRange("Document No.", "No.");
                if lrecDetVendLedgerEntry.FindFirst() then begin
                    lrecDetVendLedgerEntry2.Reset();
                    lrecDetVendLedgerEntry2.SetRange("Document Type", lrecDetVendLedgerEntry."Document Type"::Payment);
                    lrecDetVendLedgerEntry2.SetRange("Entry Type", lrecDetVendLedgerEntry."Entry Type"::Application);
                    lrecDetVendLedgerEntry2.SetRange("Vendor Ledger Entry No.", lrecDetVendLedgerEntry."Vendor Ledger Entry No.");
                    if lrecDetVendLedgerEntry2.FindFirst() then begin
                        lrecVendorLedgerEntry.Reset();
                        lrecVendorLedgerEntry.SetRange("Entry No.", lrecDetVendLedgerEntry2."Applied Vend. Ledger Entry No.");
                        if lrecVendorLedgerEntry.FindFirst() then begin
                            ExcelBuf.AddColumn(lrecVendorLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(lrecVendorLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(lrecVendorLedgerEntry."PV Number", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        end else begin
                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        end;
                    end else begin
                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    end;
                end else begin
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                end;

                ExcelBuf.AddColumn('', FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Vendor Invoice No.", FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Supplier Invoice Date", FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('Invoiced', FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

            end;

            trigger OnPostDataItem()
            begin
                //ExcelBuf.WriteSheet('', '', '');
            end;
        }


        dataitem("Purchase Header Archive"; "Purchase Header Archive")
        {
            DataItemTableView = sorting("No.") where("Cancelled By" = filter(<> ''));
            RequestFilterFields = "Document Type", "No.";
            trigger OnPreDataItem()
            begin
                "Purchase Header Archive".SetFilter("Order Date", gtextDate);
                "Purchase Header Archive".SetRange(Claim, false);
                //ExcelBuf.DeleteAll(false);
                //ExcelBuf.SelectOrAddSheet('Closed Purchase Orders');
                //MakeExcelDataHeader3();
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(EarMaskedAmount);
                grecPurchLineArchive.Reset();
                grecPurchLineArchive.SetRange("Document No.", "No.");
                if grecPurchLineArchive.FindSet() then begin
                    grecPurchLineArchive.CalcSums("Line Amount");
                    EarMaskedAmount := grecPurchLineArchive."Line Amount";
                end;
                ExcelBuf.NewRow;
                ExcelBuf.AddColumn("Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Buy-from Vendor No." + ' ' + "Buy-from Vendor Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Posting Description", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(grecPurchLineArchive."Date Earmarked", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(EarMaskedAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                "Purchase Header Archive".CalcFields("Amount Including VAT");
                ExcelBuf.AddColumn("Amount Including VAT", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Vendor Order No.", FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Vendor Invoice No.", FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Supplier Invoice Date", FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('Cancelled', FALSE, '', false, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            end;

            trigger OnPostDataItem()
            begin
                //ExcelBuf.WriteSheet('', '', '');
                ExcelBuf.CreateNewBook('Purchase Register');
                ExcelBuf.WriteSheet('', '', '');
                ExcelBuf.CloseBook();
                ExcelBuf.OpenExcel();
                //ExcelBuf.WriteSheet('', '', '');

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Date Filter")
                {
                    field(Date; gtextDate)
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        var
                        //TextManagement: Codeunit TextManagement;
                        begin
                            //TextManagement.MakeDateFilter(gtextDate);
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        /* if gtextDate = '' then
            error(gtextDateFilterError); */

    end;
    /* 
        trigger OnPostReport()
        begin
            ExcelBuf.CloseBook();
            ExcelBuf.OpenExcel();
        end; */

    local procedure MakeExcelDataHeader1()
    begin
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Purchase Register - Open Purchase Orders', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(gtextDate, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        */
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase Order', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Earmarked Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Earmarked Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Director General Signature', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplied Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplied Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Procurement Method', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Date Sent for Payment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment PV No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Remarks', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Invoice No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Status', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;


    local procedure MakeExcelDataHeader2()
    begin
        //ExcelBuf.ClearNewRow();
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Purchase Register - Posted Purchase Invoices', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(gtextDate, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase Order', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Earmarked Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Earmarked Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Director General Signature', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplied Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplied Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Date Sent for Payment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Amount Paid', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment PV No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Remarks', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;


    local procedure MakeExcelDataHeader3()
    begin
        //ExcelBuf.ClearNewRow();
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Purchase Register - Closed Purchase Orders', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(gtextDate, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase Order', FALSE, '', True, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Earmarked Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Earmarked Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Director General Signature', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplied Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplied Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Date Sent for Payment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment PV No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Remarks', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

    end;


    var
        gtextDate: Text;
        grecPurchHdr: Record "Purchase Header";
        grecPurchLine: Record "Purchase Line";
        grecPurchInvHdr: Record "Purch. Inv. Header";
        grecPurchInvLine: Record "Purch. Inv. Line";
        grecPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        grecPurchCrMemoLine: Record "Purch. Cr. Memo Line";
        grecPurchHdrArchive: Record "Purchase Header Archive";
        grecPurchLineArchive: Record "Purchase Line Archive";
        ExcelBuf: Record "Excel Buffer";
        gtextDateFilterError: Label 'Date filter should be fill in.';
        grecNewCategories: Record "New Categories";
        EarMaskedAmount: Decimal;

}