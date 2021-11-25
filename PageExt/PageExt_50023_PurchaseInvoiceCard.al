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
                        grecEarmarkingClaim.Active := false;
                        grecEarmarkingClaim.Modify();
                    end;
                end;
            }
        }
    }
}