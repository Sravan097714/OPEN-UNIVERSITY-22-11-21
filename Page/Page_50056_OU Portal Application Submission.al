page 50056 "OU Portal App Submission"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "OU Portal App Submission";
    SourceTableView = where("NAV Doc No." = filter(''));
    Caption = 'OU Portal Application Submission';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(User_ID; User_ID) { ApplicationArea = All; }
                field(Submission; Submission) { ApplicationArea = All; }
                field(RDAP; RDAP) { ApplicationArea = All; }
                field(RDBL; RDBL) { ApplicationArea = ALl; }
                field(NIC; NIC) { ApplicationArea = All; }
                field("First Name"; "First Name") { ApplicationArea = All; }
                field("Last Name"; "Last Name") { ApplicationArea = ALl; }
                field("Maiden Name"; "Maiden Name") { ApplicationArea = All; }
                field(Intake; Intake) { ApplicationArea = All; }
                field("Intake Formatted"; "Intake Formatted") { ApplicationArea = All; }
                field("Login Email"; "Login Email") { ApplicationArea = ALl; }
                field("Contact Email"; "Contact Email") { ApplicationArea = All; }
                field(Phone; Phone) { ApplicationArea = All; }
                field(Mobile; Mobile) { ApplicationArea = All; }
                field(Address; Address) { ApplicationArea = All; }
                field(Country; Country) { ApplicationArea = All; }
                field("Programme 1"; "Programme 1") { ApplicationArea = All; }
                field("Programme 2"; "Programme 2") { ApplicationArea = All; }
                field("Programme 3"; "Programme 3") { ApplicationArea = All; }
                field("Programme 4"; "Programme 4") { ApplicationArea = All; }
                field(Status; Status) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Upload Application Submsission")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(50092);
                end;
            }
            action("Create Cash Receipt Journal")
            {
                ApplicationArea = All;
                Image = DocumentEdit;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ProcessApplSub: Codeunit "Process Appl Submission Fee";
                    grecGenJnlBatch: Record "Gen. Journal Batch";
                    gpageGenJnlBatch: Page "General Journal Batches 2";
                    JournalTemplate: Code[10];
                    JournalBatch: Code[10];
                    ApplSubmissionFee: Record "OU Portal App Submission";
                    ApplSubmissionFee2: Record "OU Portal App Submission";
                    ConfirmTxt: Label '%1 Lines are selected, Do you want to create cash receipt journal for selected lines.';
                begin
                    Clear(gpageGenJnlBatch);
                    grecGenJnlBatch.Reset();
                    grecGenJnlBatch.SetRange("Journal Template Name", 'CASH RECE');
                    if grecGenJnlBatch.Findset() then begin
                        gpageGenJnlBatch.SetRecord(grecGenJnlBatch);
                        gpageGenJnlBatch.SetTableView(grecGenJnlBatch);
                        gpageGenJnlBatch.LookupMode(true);
                        if gpageGenJnlBatch.RunModal() = Action::LookupOK then begin
                            gpageGenJnlBatch.GetRecord(grecGenJnlBatch);
                            JournalTemplate := grecGenJnlBatch."Journal Template Name";
                            JournalBatch := grecGenJnlBatch.Name;
                        end;
                    end;
                    if (JournalTemplate = '') or (JournalBatch = '') then
                        Error('Journal Template or Journal Batch is empty.');

                    ProcessApplSub.SetJournal(JournalTemplate, JournalBatch);
                    CurrPage.SetSelectionFilter(ApplSubmissionFee);
                    if ApplSubmissionFee.FindSet() then
                        if not Confirm(StrSubstNo(ConfirmTxt, ApplSubmissionFee.Count), false) then
                            exit;
                    repeat
                        ApplSubmissionFee2 := ApplSubmissionFee;
                        Commit();
                        if not ProcessApplSub.Run(ApplSubmissionFee2) then begin
                            ApplSubmissionFee2.Error := CopyStr(GetLastErrorText(), 1, MaxStrLen(ApplSubmissionFee2.Error));
                            ApplSubmissionFee2.Modify();
                        end else
                            ApplSubmissionFee2.Delete();
                    until ApplSubmissionFee.Next() = 0;
                end;
            }
        }
    }
}