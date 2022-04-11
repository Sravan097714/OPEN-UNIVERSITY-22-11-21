pageextension 50023 PurchInvoiceCardExt extends "Purchase Invoice"
{
    layout
    {
        modify("Buy-from Country/Region Code")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Tax Liable")
        {
            Visible = false;
        }
        modify("Buy-from Contact No.")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Buy-from Contact")
        {
            Visible = false;
        }
        modify("Buy-from County")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Shipping and Payment")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        modify("Prices Including VAT")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Payment Terms Code")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            Visible = false;
        }
        modify("Payment Reference")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("On Hold")
        {
            Visible = false;
        }
        modify("Pay-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Posting Description")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }

        /* modify("No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                grecVendor: Record Vendor;
                gpageVendorList: Page "Vendor List";
            begin
                Clear(gpageVendorList);
                grecVendor.Reset();
                grecVendor.SetFilter("Vendor Category", '%1|%2', 'Service Provider', 'Tutor');
                if grecVendor.FindFirst() then begin
                    gpageVendorList.SetRecord(grecVendor);
                    gpageVendorList.SetTableView(grecVendor);
                    gpageVendorList.LookupMode(true);
                    if gpageVendorList.RunModal() = Action::LookupOK then begin
                        gpageVendorList.GetRecord(grecVendor);
                        Rec."VAT Bus. Posting Group" := grecVendor."No.";
                    end;
                end;
            end;
        } */

        addafter("Vendor Invoice No.")
        {
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
                Editable = true;
                ApplicationArea = All;
            }
        }
        addbefore("Posting Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
            }
        }

        addlast(General)
        {
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
            }
            field(BRN; BRN) { ApplicationArea = All; }
        }
        modify("Pay-to Name")
        {
            Visible = true;
            Editable = false;
        }
        moveafter("VAT Bus. Posting Group"; "Pay-to Name")
        addbefore("Pay-to Name")
        {
            field("Pay-to Vendor No."; "Pay-to Vendor No.") { ApplicationArea = all; Editable = false; }
        }
        addafter(PurchLines)
        {
            group(Earmarking)
            {
                //field("Earmark ID"; "Earmark ID") { ApplicationArea = All; }
                field(Earmarked; Earmarked) { ApplicationArea = All; }
                //field("Date Earmarked"; "Date Earmarked") { ApplicationArea = All; }
                field("Amount Earmarked"; "Amount Earmarked") { ApplicationArea = All; }
            }
        }

        addlast(FactBoxes)
        {
            part("Purchase Line Details"; 9100)
            {
                ApplicationArea = All;
                Provider = PurchLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = true;
            }
        }
    }
    actions
    {
        addafter(MoveNegativeLines)
        {
            action("Get Earmarked Amount")
            {
                ApplicationArea = All;
                Image = LedgerBook;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    gpageEarmarkClaimForms: Page "Earmarking for Claim Forms";
                    grecEarmarkingClaim: Record "Earmarking Claim Forms Table";
                    grecPurchaseLine: Record "Purchase Line";
                    gintLineNo: Integer;
                begin
                    Clear(gpageEarmarkClaimForms);
                    grecEarmarkingClaim.Reset();
                    grecEarmarkingClaim.SetRange(Active, true);
                    if grecEarmarkingClaim.FindFirst() then;
                    if Page.RunModal(50061, grecEarmarkingClaim) = Action::LookupOK then begin
                        clear(gintLineNo);
                        grecPurchaseLine.reset;
                        grecPurchaseLine.SetRange("Document No.", "No.");
                        if grecPurchaseLine.FindLast() then
                            gintLineNo := grecPurchaseLine."Line No.";

                        grecPurchaseLine.init;
                        grecPurchaseLine."Line No." := gintLineNo + 10000;
                        grecPurchaseLine."Document Type" := "Document Type";
                        grecPurchaseLine."Document No." := "No.";
                        grecPurchaseLine.Type := grecPurchaseLine.Type::"G/L Account";
                        grecPurchaseLine.validate("No.", grecEarmarkingClaim."G/L Account Earmarked");
                        grecPurchaseLine."G/L Account for Budget" := grecEarmarkingClaim."G/L Account Earmarked";
                        grecPurchaseLine.Validate("Direct Unit Cost", grecEarmarkingClaim."Remaining Amount Earmarked");
                        grecPurchaseLine."Earmark ID" := grecEarmarkingClaim."Earmark ID";
                        grecPurchaseLine."Date Earmarked" := grecEarmarkingClaim."Date Earmarked";
                        grecPurchaseLine.Insert;
                    end;
                end;
            }
        }
        modify(Post)
        {
            Visible = false;
        }
        modify(PostAndPrint)
        {
            Visible = false;
        }

        addbefore(Post)
        {
            action(Post1)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                var
                    PurchaseLineRec: record "Purchase Line";
                begin
                    VerifyTotal;
                    PurchaseLineRec.reset;
                    with PurchaseLineRec do begin
                        SetFilter("Document No.", Rec."No.");
                        SETRANGE("Document Type", "Document Type"::Invoice);
                        if Find('-') then begin
                            repeat
                                if (StrLen("G/L Account for Budget") <> 0) then begin
                                    if ("Earmark ID" = '') or ("Date Earmarked" = 0D) then begin
                                        Message('Please select the %1 for line %2', FieldCaption("G/L Account for Budget"), "Line No.");
                                        exit;
                                    end;

                                end;
                            until next() = 0;
                        end
                    end;
                    PostDocument(CODEUNIT::"Purch.-Post (Yes/No)", "Navigate After Posting"::"Posted Document");
                end;
            }

            action("PostAndPrint ")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post and &Print';
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F9';
                ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                Visible = NOT IsOfficeAddin;

                trigger OnAction()
                var
                    PurchaseLineRec: Record "Purchase Line";
                begin
                    VerifyTotal;
                    //ktm
                    PurchaseLineRec.reset;
                    with PurchaseLineRec do begin
                        SetFilter("Document No.", Rec."No.");
                        SETRANGE("Document Type", "Document Type"::Invoice);
                        if Find('-') then begin
                            repeat
                                if (StrLen("G/L Account for Budget") <> 0) then begin
                                    if ("Earmark ID" = '') or ("Date Earmarked" = 0D) then begin
                                        Message('Please select the %1 for line %2', FieldCaption("G/L Account for Budget"), "Line No.");
                                        exit;
                                    end;

                                end;
                            until next() = 0;
                        end
                    end;
                    PostDocument(CODEUNIT::"Purch.-Post + Print", "Navigate After Posting"::"Do Nothing");
                end;
            }
        }

    }
    var
        OpenPostedPurchaseInvQst: Label 'The invoice is posted as number %1 and moved to the Posted Purchase Invoices window.\\Do you want to open the posted invoice?', Comment = '%1 = posted document number';
        TotalsMismatchErr: Label 'The invoice cannot be posted because the total is different from the total on the related incoming document.';
        DocumentIsPosted: Boolean;
        IsOfficeAddin: Boolean;

    local procedure VerifyTotal()
    begin
        if not IsTotalValid then
            Error(TotalsMismatchErr);
    end;

    local procedure ShowPostedConfirmationMessage()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        PurchInvHeader.SetRange("Pre-Assigned No.", "No.");
        PurchInvHeader.SetRange("Order No.", '');
        if PurchInvHeader.FindFirst then
            if InstructionMgt.ShowConfirm(StrSubstNo(OpenPostedPurchaseInvQst, PurchInvHeader."No."),
                 InstructionMgt.ShowPostedConfirmationMessageCode)
            then
                PAGE.Run(PAGE::"Posted Purchase Invoice", PurchInvHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostDocumentOnBeforePurchaseHeaderInsert(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    local procedure PostDocument(PostingCodeunitID: Integer; Navigate: Enum "Navigate After Posting")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        InstructionMgt: Codeunit "Instruction Mgt.";
        IsScheduledPosting: Boolean;
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        if ApplicationAreaMgmtFacade.IsFoundationEnabled then
            LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

        SendToPosting(PostingCodeunitID);

        IsScheduledPosting := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        DocumentIsPosted := (not PurchaseHeader.Get("Document Type", "No.")) or IsScheduledPosting;

        if IsScheduledPosting then
            CurrPage.Close;
        CurrPage.Update(false);

        if PostingCodeunitID <> CODEUNIT::"Purch.-Post (Yes/No)" then
            exit;

        case Navigate of
            "Navigate After Posting"::"Posted Document":
                begin
                    if IsOfficeAddin then begin
                        PurchInvHeader.SetRange("Pre-Assigned No.", "No.");
                        PurchInvHeader.SetRange("Order No.", '');
                        if PurchInvHeader.FindFirst then
                            PAGE.Run(PAGE::"Posted Purchase Invoice", PurchInvHeader);
                    end else
                        if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) then
                            ShowPostedConfirmationMessage;
                end;
            "Navigate After Posting"::"New Document":
                if DocumentIsPosted then begin
                    Clear(PurchaseHeader);
                    PurchaseHeader.Init();
                    PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Invoice);
                    OnPostDocumentOnBeforePurchaseHeaderInsert(PurchaseHeader);
                    PurchaseHeader.Insert(true);
                    PAGE.Run(PAGE::"Purchase Invoice", PurchaseHeader);
                end;
        end;


    end;
}