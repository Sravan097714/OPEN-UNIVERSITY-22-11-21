pageextension 50106 IssuedReminderListExt extends "Issued Reminder List"
{
    layout
    {
        addlast(Control1)
        {
            field("Reminder Level"; "Reminder Level") { ApplicationArea = All; }
            field("Document Date"; "Document Date") { ApplicationArea = All; }
            field("Posting Date"; "Posting Date") { ApplicationArea = All; }
            field("Due Date"; "Due Date") { ApplicationArea = All; }
            field("Posting Description"; "Posting Description") { ApplicationArea = All; }
            field("Customer Posting Group"; "Customer Posting Group") { ApplicationArea = All; Visible = false; }
            field("Created By"; "Created By") { ApplicationArea = All; }
            field("Created On"; "Created On") { ApplicationArea = All; }
        }
        modify(Canceled)
        {
            Visible = false;
        }
    }

    actions
    {
        // modify("&Print")
        // {
        //     trigger OnBeforeAction()
        //     begin
        //         /*
        //         if "Shortcut Dimension 1 Code" = '' then
        //             error('');
        //         */
        //     end;
        // }
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
    trigger OnOpenPage()
    begin
        SetRange("Course Reminder", false);
    end;

    var
        IssuedReminderHeader: Record "Issued Reminder Header";
}