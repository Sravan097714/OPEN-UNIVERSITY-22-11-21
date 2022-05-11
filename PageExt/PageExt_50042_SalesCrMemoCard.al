pageextension 50042 SalesCrMemoCardExt extends "Sales Credit Memo"
{
    layout
    {
        modify("Sell-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        /*  modify("External Document No.")
         {
             Visible = false;
         } */
        modify("Salesperson Code")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Work Description")
        {
            Visible = false;
        }
        // addafter(categ)
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Sell-to Contact No.")
        {
            Visible = false;
        }
        modify("Sell-to Contact")
        {
            Visible = false;
        }
        modify(Billing)
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify("Payment Terms Code")
        {
            Visible = false;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify("Bill-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Posting Description")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Location Code")
        {
            Visible = false;
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
            field("Our Ref"; "Our Ref") { ApplicationArea = All; }
            field("Your Ref"; "Your Ref") { ApplicationArea = All; }
        }
        modify("Transaction Type")
        {
            ApplicationArea = all;
            Caption = 'Category';
            Visible = true;
        }
        moveafter(Status; "Transaction Type")
        addafter(Status)
        {
            field("From OU Portal"; "From OU Portal")
            {
                ApplicationArea = all;
            }
            field("Bank Code"; "Bank Code")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        addbefore(TestReport)
        {
            action("Load G/L Entries")
            {
                ApplicationArea = All;
                ToolTip = 'Load G/L Entries before Test Report';
                Image = GetEntries;

                trigger OnAction()
                var
                    PreviewPostingCU: Codeunit 50012;
                begin
                    PreviewPostingCU.RunPreviewPostingInTheBackground(Rec);
                end;
            }
        }
        modify(CopyDocument)
        {
            Visible = false;
        }
        addafter(CopyDocument)
        {
            action(CopyDocument2)
            {
                ApplicationArea = Suite;
                Caption = 'Copy Document';
                Ellipsis = true;
                Enabled = "No." <> '';
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Category7;
                ToolTip = 'Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.';

                trigger OnAction()

                var
                    CopySalesDocument: Report "Copy Sales Document Cust";
                    IsHandled: Boolean;
                begin
                    IsHandled := false;
                    OnBeforeCopyDocument(Rec, IsHandled);
                    if IsHandled then
                        exit;

                    CopySalesDocument.SetSalesHeader(Rec);
                    CopySalesDocument.RunModal;
                    if Get("Document Type", "No.") then;
                end;
            }
        }
    }

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyDocument(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean);
    begin
    end;
}