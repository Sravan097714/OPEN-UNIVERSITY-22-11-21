pageextension 50104 ReminderExt extends Reminder
{
    layout
    {
        addlast(General)
        {
            field("Deadline for Payment"; "Deadline for Payment")
            {
                ApplicationArea = All;
            }
            field("Reminder Ref"; "Reminder Ref")
            {
                ApplicationArea = All;
                Caption = 'Our Ref';
            }
            field("Your Reference"; "Your Reference") { ApplicationArea = all; }
            field("Created By"; "Created By") { ApplicationArea = All; }
            field("Created On"; "Created On") { ApplicationArea = All; }
        }
        addafter(Contact)
        {
            field("Posting Description"; "Posting Description") { ApplicationArea = all; }
        }
        modify("Fin. Charge Terms Code")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Post Code") { Visible = false; }
    }

    actions
    {
        modify(CreateReminders)
        {
            trigger OnBeforeAction()
            begin
                REPORT.RunModal(REPORT::"Create Reminders - Normal");
                Error('');
            end;
        }
    }
}