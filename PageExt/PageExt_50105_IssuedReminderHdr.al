pageextension 50105 IssuedReminderExt extends "Issued Reminder"
{
    layout
    {
        addlast(General)
        {
            field("Deadline for Payment"; "Deadline for Payment") { ApplicationArea = All; }
            field("Reminder Ref"; "Reminder Ref")
            {
                ApplicationArea = All;
                Caption = 'Our Ref';
            }
            field("Your Reference"; "Your Reference") { ApplicationArea = all; }
            field("Customer Posting Group"; "Customer Posting Group")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Posting Description"; "Posting Description")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Created By"; "Created By") { ApplicationArea = All; }
            field("Created On"; "Created On") { ApplicationArea = All; }
        }
        modify(Canceled)
        {
            Visible = false;
        }
        modify("Fin. Charge Terms Code")
        {
            Visible = false;
        }
    }

    actions
    {
        /*
        modify("&Print")
        {
            trigger OnBeforeAction()
            begin
                if "Shortcut Dimension 1 Code" = '' then
                    error('');
            end;
        }
        */
        modify("&Print")
        {
            Visible = false;
        }
        addafter("&Print")
        {
            action("Print ")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    IsHandled: Boolean;
                begin
                    IssuedReminderHeader := Rec;
                    /* IsHandled := false;
                    OnBeforePrintRecords(Rec, IssuedReminderHeader, IsHandled);
                    if IsHandled then
                        exit; */
                    CurrPage.SetSelectionFilter(IssuedReminderHeader);
                    //IssuedReminderHeader.PrintRecords(true, false, false);
                    Report.Run(50080, true, true, IssuedReminderHeader);
                end;
            }

        }
    }
    var
        IssuedReminderHeader: Record "Issued Reminder Header";
}