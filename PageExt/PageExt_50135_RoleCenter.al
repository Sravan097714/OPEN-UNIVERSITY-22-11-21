pageextension 50135 BusinessCenterRole extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Setup)
        {
            action("Process OU Portal")
            {
                ApplicationArea = All;
                caption = 'Process OU Portal Data';
                RunObject = codeunit "OU Portal Files Scheduler";
            }
        }
    }

    var
        myInt: Integer;
}