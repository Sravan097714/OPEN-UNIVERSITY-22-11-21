pageextension 50129 AccountantRoleCenterExt extends "Accountant Role Center"
{
    layout
    {

        addafter(Control76)
        {
            part(ControlRetention; "Retention Due")
            {
                ApplicationArea = Basic, Suite;
            }
        }


    }

    actions
    {
        modify(SetupAndExtensions)
        {
            Visible = false;
        }
        modify(Action84)
        {
            Visible = false;
        }
        //movebefore(Inventory;fixed)

        addbefore(SetupAndExtensions)
        {
            group("Accounts Receivable")
            {
                action("Customer List")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer List";
                }
            }

            group("Accounts Payable")
            {
                action("Vendor List")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vendor List";
                }
            }

            group(Inventory)
            {
                action("Item List")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Item List";
                }
            }

            group(Procurement)
            {
                action("Vendor List ")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vendor List";
                }
            }

            group("OU Portal")
            {
                action("Customer List ")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer List";
                }
            }

            group("General Ledger Reports")
            {
                action("Trial Balance")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "Trial Balance";
                }
            }

            group("Cash Management Reports")
            {
                action("Bank Reconciliation Report")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "Bank Reconciliation Report";
                }
            }
            group("Payroll Reports")
            {
                action("AP - Payroll GL Entries")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "AP - Payroll GL Entries";
                }

            }


            group("Fixed Assets Reports")
            {
                action("Fixed Asset Register")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "Fixed Asset Register";
                }
            }

            group("Accounts Payable Reports")
            {
                action("Aged Accounts Payable")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "Aged Accounts Payable";
                }
            }

            group("Accounts Receivable Reports")
            {
                action("Aged Receivable Payable")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "Aged Accounts Receivable";
                }
                action("List of Posted Sales Invoice")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "List of Posted Sales Invoices";
                }
                action("List of Posted Sales Cr. Note")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "List of Posted Sales Cr. Note";
                }
                action("List of Open Sales Invoices")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "List of Open Sales Invoices";
                }
                action("List of Open Sales Cr. Note")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "List of Open Sales Cr. Note";
                }

            }

            group("Inventory Reports")
            {
                action("Stock Reorder Level")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "Stock Reorder Level";
                }
            }

            group("Procurement Reports")
            {
                action("Suppliers Appraisal ")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "Supplier's Appraisal";
                }
            }

            group(Administration)
            {
                action("Dimensions ")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Dimension List";
                }
            }

            group("Posted Sales Document")
            {
                action("Posted Sales Invoice")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Posted Sales Invoice";
                }
            }

            group("Posted Purchase Document")
            {
                action("Posted Purchase Invoice")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Posted Purchase Invoice";
                }
            }


            group("Posted Inventory")
            {
                action("Value Entries")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Value Entries";
                }
            }
        }
    }

    var
        myInt: Integer;
}