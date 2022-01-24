pageextension 50002 SalesReceivablesSetup extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Doc. Posting Date as WORKDATE"; rec."Doc. Posting Date as WORKDATE")
            {
                ApplicationArea = All;
            }
            field("Use Available Inventory Only"; rec."Use Available Inventory Only")
            {
                ApplicationArea = All;
            }
            field("Upload Customer Payments"; "Upload Customer Payments")
            {
                ApplicationArea = All;
            }
            field("VAT Product on OU Sales App"; "VAT Product on OU Sales App")
            {
                ApplicationArea = All;
            }
            field("Sales Invoice Signature Name"; "Sales Invoice Signature Name") { ApplicationArea = All; }
            field("Sign for Statement of Accounts"; "Sign for Statement of Accounts") { ApplicationArea = All; }
            field("Sign for Reminders"; "Sign for Reminders") { ApplicationArea = All; }
            field("Post Cash Receipts today"; "Post Cash Receipts today") { ApplicationArea = All; }
        }

        addlast(content)
        {
            group("Application Fee OU Portal")
            {
                field("Journal Batch Name OU Portal"; "Journal Batch Name OU Portal")
                {
                    ApplicationArea = All;
                }
                field("G/L Acc. for App Reg OU Portal"; "G/L Acc. for App Reg OU Portal")
                {
                    ApplicationArea = All;
                }
                field("Bank Acc. for Bank OU Portal"; "Bank Acc. No. for OU Portal")
                {
                    ApplicationArea = All;
                }
                field("No. Series for AppReg."; "No. Series for AppReg.")
                {
                    ApplicationArea = All;
                }
            }

            group("Module Fee OU Portal")
            {
                Caption = 'User Module Fee';
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group") { ApplicationArea = all; }
                field("Cust. PG Mod. Fee Ins"; Rec."Cust. PG Mod. Fee Ins") { ApplicationArea = all; }
                field("Cust. PG Mod. Fee Without Ins"; Rec."Cust. PG Mod. Fee Without Ins") { ApplicationArea = all; }
            }

            group("Re-registration Fee OU Portal")
            {
                field("G/L for Penalty Fee"; "G/L for Penalty Fee")
                {
                    ApplicationArea = All;
                }
                field("Cust. PG Rereg. Fee Ins"; Rec."Cust. PG Rereg. Fee Ins") { ApplicationArea = all; }
                field("Cust. PG Rereg.Fee Without Ins"; Rec."Cust. PG Rereg.Fee Without Ins") { ApplicationArea = all; }
            }

            group("Exemption Fee OU Portal")
            {
                field("G/L for Exemption Fee"; "G/L for Exemption Fee")
                {
                    ApplicationArea = All;
                }
                field("Exemption Amount"; "Exemption Amount")
                {
                    ApplicationArea = All;
                }
                field("Cust. PG Exe. Fee Ins"; Rec."Cust. PG Exe. Fee") { ApplicationArea = all; }
            }
            group("Resit Fee From OU Portal")
            {
                field("Cust. PG Resit.Fee"; Rec."Cust. PG Resit.Fee") { ApplicationArea = all; }
            }
            group("Application Submission From OU Portal")
            {
                field("G/L for Appl Submission Fee"; Rec."G/L for Appl Submission Fee") { ApplicationArea = all; }
                field("Appl Submission Amount"; Rec."Appl Submission Amount") { ApplicationArea = all; }
            }
            group("Full Program Fee From OU Portal")
            {
                field("G/L for Full Pgm Fee"; Rec."G/L for Full Pgm Fee") { ApplicationArea = all; }
                field("Cust. PG Full Pgm. Fee"; Rec."Cust. PG Full Pgm. Fee") { ApplicationArea = all; }
            }
        }
        addlast("Number Series")
        {
            field("No. Series for OU Portal"; "No. Series for OU Portal")
            {
                ApplicationArea = All;
            }
            field("Posted Inv Nos. for OU Portal"; "Posted Inv Nos. for OU Portal")
            {
                ApplicationArea = All;
            }
            field("Bank Standing Order Nos."; "Bank Standing Order Nos.")
            {
                ApplicationArea = All;
            }
        }
    }
}