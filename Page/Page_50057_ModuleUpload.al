page 50057 "Module Upload"
{
    Caption = 'Module Upload';
    PageType = List;
    SourceTable = "Module Upload";
    SourceTableView = where("NAV Doc No." = filter(''));
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Common Module Code"; Rec."Common Module Code")
                {
                    ToolTip = 'Specifies the value of the Common Module Code field.';
                    ApplicationArea = All;
                }
                field(Credit; Rec.Credit)
                {
                    ToolTip = 'Specifies the value of the Credit field.';
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                    ApplicationArea = All;
                }
                field(Semester; Rec.Semester)
                {
                    ToolTip = 'Specifies the value of the Semester field.';
                    ApplicationArea = All;
                }
                field(Error; Rec.Error)
                {
                    ToolTip = 'Specifies the value of the Error field.';
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; GetUserName(Rec.SystemCreatedBy))
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; GetUserName(Rec.SystemModifiedBy))
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Upload Modules")
            {
                Caption = 'Upload Modules';
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(Report::"Import Module");
                end;
            }
            action("Create Module")
            {
                Caption = 'Create Modules';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = CreateDocuments;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ModuleUpload: Record "Module Upload";
                    ProcessOuPortal: Codeunit "OU Portal Files Scheduler";
                begin
                    if Not Confirm('Do you want to create module for selected lines?', true) then
                        exit;
                    CurrPage.SetSelectionFilter(ModuleUpload);
                    ProcessOuPortal.ModuleUpload(ModuleUpload);
                end;
            }
            action("Delete All")
            {
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ModuleUpload: Record "Module Upload";
                begin
                    if Confirm('Do you want to delete all the lines.', true) then
                        Rec.DeleteAll();

                end;
            }
        }
    }
    procedure GetUserName(USID: Guid): text
    var
        UserLRec: Record User;
    begin
        if UserLRec.Get(USID) then
            exit(UserLRec."User Name")
        else
            exit('');
    end;
}
